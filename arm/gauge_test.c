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

    gauge_demo(gauge);

    //while (!exiting)
    //{
    //    float x = .5;
    //    gauge_message(gauge, x, x, x, x);
    //}
}
