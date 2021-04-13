#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>
#include <termios.h>

#include "gauge.h"

static GaugeContext *gauge = NULL;
static bool exiting = false;

static void cleanup()
{
    putchar('\n'); // after the \r from consume()

    if (gauge)
        gauge_deinit(&gauge);
}


static void handle_sigint(int signal)
{
    exit(0);
}


int main(int argc, const char **argv)
{
    if (atexit(cleanup) != 0)
    {
        perror("Failed to register deinit");
        exit(-1);
    }
    signal(SIGINT, handle_sigint);

    gauge = gauge_init();

    //gauge_demo(gauge);

    struct termios s;
    tcgetattr(STDIN_FILENO, &s);
    s.c_lflag &= ~(ICANON|ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &s);

    unsigned i = 0;
    unsigned d = 0x80;
    while (true)
    {
        printf("%4d %4d\n", i, d);
        switch (fgetc(stdin))
        {
        case 'w':
            d <<= 1;
            break;
        case 's':
            if (d != 1)
                d >>= 1;
            break;
        case 'a':
            i -= d;
            break;
        case 'd':
            i += d;
            break;
        }
        float x = (float)i / 0x100;
        gauge_message(gauge, x, x, x, x);
    }
}
