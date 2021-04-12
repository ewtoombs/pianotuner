#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>

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
    exiting = true;
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

    while (true)
    {
        for (unsigned i = 0; i < 3; i++)
        {
            if (exiting)
            {
                exit(0);  // will call cleanup anyway
            }
            float x = 0.5*i;
            gauge_message(gauge, x, x, x, x);
            char c;
            read(0, &c, 1);
        }
    }
}
