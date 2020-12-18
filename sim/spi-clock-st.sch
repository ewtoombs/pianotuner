<Qucs Schematic 0.0.19>
<Properties>
  <View=64,230,970,655,1.12455,0,0>
  <Grid=10,10,1>
  <DataSet=spi-clock-st.dat>
  <DataDisplay=spi-clock-st.dpl>
  <OpenDisplay=1>
  <Script=spi-clock-st.m>
  <RunScript=0>
  <showFrame=0>
  <FrameText0=Title>
  <FrameText1=Drawn By:>
  <FrameText2=Date:>
  <FrameText3=Revision:>
</Properties>
<Symbol>
</Symbol>
<Components>
  <R R3 1 400 350 15 -26 1 3 "100kOhm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <OpAmp U1 1 570 430 -26 42 0 0 "1e6" 0 "2.6 V" 1>
  <GND * 1 330 470 0 0 0 0>
  <Vdc Vddb 5 360 350 -77 -26 1 1 "2.6 V" 1>
  <Vdc Vdda 5 360 530 -77 -26 1 1 "2.6 V" 1>
  <R R2 1 570 370 -26 -53 1 0 "82 kOhm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <Vrect Vin_tri 5 240 460 -96 -26 1 1 "3.04 V" 1 "500 ns" 1 "500 ns" 1 "1 us" 1 "1 us" 1 "0 ns" 0>
  <Vdc Vin_low 5 240 550 18 -26 1 3 "1.72 V" 1>
  <GND * 1 240 590 0 0 0 0>
  <.TR TR1 1 750 300 0 66 0 0 "lin" 1 "0" 0 "2us" 1 "501" 1 "Trapezoidal" 0 "2" 0 "1 ns" 0 "1e-16" 0 "150" 0 "0.001" 0 "1 pA" 0 "1 uV" 0 "26.85" 0 "1e-3" 0 "1e-6" 0 "1" 0 "CroutLU" 0 "no" 0 "yes" 0 "0" 0>
  <Eqn Eqn1 5 780 500 -30 16 0 0 "Vin=Vin_off.Vt - Vss.Vt" 1 "Vout=Vout_off.Vt - Vss.Vt" 1 "yes" 0>
  <R R1 1 290 410 -26 -53 1 0 "33 kOhm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <R R4 1 400 510 15 -26 1 3 "82kOhm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
</Components>
<Wires>
  <520 410 540 410 "" 0 0 0 "">
  <610 430 620 430 "" 0 0 0 "">
  <360 300 360 320 "" 0 0 0 "">
  <360 300 400 300 "" 0 0 0 "">
  <400 300 400 320 "" 0 0 0 "">
  <400 380 400 450 "" 0 0 0 "">
  <400 450 540 450 "Vn" 490 420 119 "">
  <620 430 640 430 "" 0 0 0 "">
  <360 380 360 450 "" 0 0 0 "">
  <330 450 360 450 "" 0 0 0 "">
  <330 450 330 470 "" 0 0 0 "">
  <360 450 360 500 "" 0 0 0 "">
  <360 560 360 580 "" 0 0 0 "">
  <620 370 620 430 "" 0 0 0 "">
  <600 370 620 370 "" 0 0 0 "">
  <520 370 520 410 "" 0 0 0 "">
  <520 370 540 370 "" 0 0 0 "">
  <240 490 240 520 "" 0 0 0 "">
  <240 580 240 590 "" 0 0 0 "">
  <320 410 520 410 "" 0 0 0 "">
  <240 410 240 430 "" 0 0 0 "">
  <240 410 260 410 "" 0 0 0 "">
  <360 580 400 580 "" 0 0 0 "">
  <400 540 400 580 "" 0 0 0 "">
  <400 450 400 480 "" 0 0 0 "">
  <520 410 520 410 "Vp" 490 380 0 "">
  <360 300 360 300 "Vdd" 315 270 0 "">
  <640 430 640 430 "Vout_off" 660 400 0 "">
  <360 580 360 580 "Vss" 320 590 0 "">
  <240 410 240 410 "Vin_off" 172 380 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
</Paintings>