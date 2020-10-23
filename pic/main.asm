#include <xc.inc>

; CONFIG1
#if IsDebug==true
    #warning Programming for debug mode
    config WDTE=OFF     ; Mandatory for debug: watchdog disabled
    config PWRTE=OFF    ; Power-up timer disabled
#else
    config WDTE=ON      ; Watchdog timer enabled even in sleep
    config PWRTE=ON     ; Power-up timer enabled
#endif
    config FOSC=INTOSC  ; RA7 has I/O. High-freq intern osc (HFINTOSC) used.
    config MCLRE=ON     ; Memory clear enabled, weak pull-up enabled
    config CP=OFF       ; Code protection off
    config BOREN=ON     ; Brown-out reset enabled
    config CLKOUTEN=OFF ; RA6 has I/O, no clock out
    config IESO=OFF     ; No internal-external clock switchover
    config FCMEN=OFF    ; No fail-safe clock monitoring
    
; CONFIG2
    config WRT=ALL      ; All flash memory self-writes disabled
    config PPS1WAY=ON   ; Peripheral pin select only unlocked once
    config ZCD=OFF      ; Zero-crossing detect disabled by default
    config PLLEN=ON     ; Enable 4x phase-locked loop for internal osc
    config STVREN=ON    ; Stack over/underflow reset enabled
    config BORV=HI      ; Brown-out threshold is 2.7V typ
    config LPBOR=ON     ; Low-power brown-out reset enabled
    ; leave DEBUG up to the programmer
    config LVP=ON       ; Low-voltage programming disabled
    
code_psect macro name
    psect psect_&name, class=NEARCODE, space=SPACE_CODE, delta=2
    name:
endm

code_psect por_vec
    ; Oscillator config
    banksel OSCCON
    ; IRCF  INTOSC  PRIMUX  PLLMUX  SCS    FOSC
    ; 0111  500kHz       1       0   00  500kHz
    bcf IRCF0
    ; 0110  250kHz       1       0   00  250kHz
    bsf IRCF3
    ; 1110    8MHz       1       1   00   32MHz
    ; At this point, everything should become "ready": MFIOFR, PLLR, HFIOFR;
    ; HFINTOSC PLL should lock within 2% (HFIOFL); 
    ; and it should stabilise within 0.5% (HFIOFS).
    goto init
 
code_psect isr_vec
    retfie
    
code_psect init
    ; Leave WDT at default 2s
    
init_ports:
    ; RA1: ana out OPA1OUT (DAC1)
    ; RA4: ana out DAC4
    ; RB1: ana out OPA2OUT (DAC2)
    ; RB6: dig in  ICSPCLK
    ; RB7: dig in  ICSPDAT
    ; RE3: dig in  MCLR
    ; RC1: SDI (MOSI)
    ; RC2: SDO (MISO)
    ; RC3: SCK
    ; RC6: ana out OPA3OUT (DAC5)
    ; Unused pins dig out driven to 0.
    ; Leave slew rate limitation enabled.
    ; Leave WPUEN disabled.
    
    ; Tristates (OSCCON and TRIS share a bank)
    movlw 0b00010010
    movwf TRISA
    movlw 0b11000010
    movwf TRISB
    movlw 0b01001010
    movwf TRISC
    
    ; The only analogue pins are for DAC/OPA
    banksel ANSELA
    movlw 0b00010010
    movwf ANSELA
    movlw 0b00000010
    movwf ANSELB
    movlw 0b01000000
    movwf ANSELC
    
    ; All Schmitt trigger levels
    banksel INLVLA
    comf INLVLA
    comf INLVLB
    comf INLVLC
    
    ; Zero output latches
    banksel LATA
    clrf LATA
    clrf LATB
    clrf LATC
    
init_dac:
    ; DAC*OUT1 available on pins; four DACs can be internally
    ; buffered through three op-amps:
    ; dac    1   4   2   3   5   7
    ; port RA2 RA4 RA5 RB2 RC0 RC1
    ; pin    4   6   7  23  11  12
    ; oa1    *   *   *   *
    ; oa2    *   *   *   *
    ; oa3                    *   *
    ; bits  10   5  10   5  10   5
    banksel DAC1CON0
    ; Start off with all gauges halfway; other bits start as 0
    bsf DAC1REF9 ; 512/1024
    bsf DAC2REF9 ; 512/1024
    bsf DAC4REF4 ; 16/32
    bsf DAC5REF9 ; 512/1024
    ; The 10-bit double-buffers need explicit load
    movlw DACLD_DAC1LD_MASK \
        | DACLD_DAC2LD_MASK \
	| DACLD_DAC5LD_MASK
    movwf DACLD
    ; Only the 5-bit DAC4 will be exposed unbuffered.
    bsf DAC4OE1
    ; Enabled; right-justified; Vdd+; Vss-
    bsf DAC1EN
    bsf DAC2EN
    bsf DAC4EN
    bsf DAC5EN
    
init_opamp:
    banksel OPA1CON
    movlw 0b0010 ; DAC1
    movwf OPA1PCHS
    movlw 0b0011 ; DAC2
    movwf OPA2PCHS
    movlw 0b0010 ; DAC5
    movwf OPA3PCHS
    ; OPACON: enabled, unity gain, no overrides
    movlw OPA1CON_OPA1EN_MASK | OPA1CON_OPA1UG_MASK
    movwf OPA1CON
    movwf OPA2CON
    movwf OPA3CON
    
init_pps:
    ; RC1: SDI (MOSI)
    ; RC2: SDO (MISO)
    ; RC3: SCK
    banksel RC2PPS
    movlw 0b100011  ; SDO
    movwf RC2PPS
    
    banksel PPSLOCK
    movlw 0b010001  ; RC1
    movwf SSPDATPPS
    movlw 0b010011  ; RC3
    movwf SSPCLKPPS
    ; SSPSSPPS ? 
    
    movlw 0x55
    movwf PPSLOCK
    movlw 0xAA
    movwf PPSLOCK
    bsf PPSLOCKED
    
init_spi:
    ; MSSP SPI child mode on all-PPS selected pins
    ; SCK, SDI (MOSI), SDO (MISO), SS?
    
    ; SPI Slave mode, clock = SCK pin, SS pin control disabled
    movlw SSP1CON1_SSPEN_MASK | 0b0101
    movwf SSP1CON1
    
main:
    sleep
    goto main

    end por_vec