#!/usr/bin/make -f

# Requirements:
# libasound2-dev armpl linux-libc-dev
# Also recommended: libasound2-dbgsym

export

objs = main.o capture.o freq.o gauge.o util.o vrb.o

pkg = pkg-config --cflags alsa

armpl = /opt/arm/armpl_23.10_gcc-12.2

cflags = $(shell ${pkg}) $\
         -I${armpl}/include -D_GNU_SOURCE -Wall -std=c18
ifdef DEBUG
	cflags += -ggdb
else
	cflags += -s -O3 -flto -fomit-frame-pointer -march=native
endif

ldflags = $(shell ${pkg} --libs) -L${armpl}/lib -Xlinker -rpath=${armpl}/lib -larmpl -lm -Wl,--warn-common
ifndef DEBUG
	ldflags += -Wl,--relax,-O3
endif

$(info cflags=${cflags})
$(info ldflags=${ldflags})


all: pianotuner

pianotuner: $(objs)
	gcc $$cflags -o $@ $^ $$ldflags

vrb_test: vrb_test.o vrb.o
	gcc $$cflags -o $@ $^ $$ldflags

gauge_test: gauge_test.o gauge.o
	gcc $$cflags -o $@ $^ $$ldflags

gauge_cal: gauge_cal.o gauge.o
	gcc $$cflags -o $@ $^ $$ldflags

%.o: %.c makefile
	gcc $$cflags -c -o $@ $<

clean:
	git clean -Xf

