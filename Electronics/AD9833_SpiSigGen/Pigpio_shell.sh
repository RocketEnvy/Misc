#!/bin/bash

#uses pigpio: http://abyz.me.uk/rpi/pigpio/pdif2.html
#chip datasheet: http://www.analog.com/media/en/technical-documentation/data-sheets/AD9833.pdf
#used the evaluation kit schematic as the basis for my circuit. Skipped the
#clock in favor of using the RPI's general purpose clock since it will allow
#changing the frequency to get good resolution of output frequencies.

# Example of putting AD9833 into 400Hz Sine mode
# MCLK is connected to GPIO 4, pin 7, set to 25MHz
# FSYNC is on RPI SPI0 CS0 (GPIO 8 Alt function,  pin 24)
# SDATA is on RPI SPI0_MOSI (GPIO 10 Alt function,  pin 19)
# SCLK is on RPI SPI0_SCLK (GPIO 11 alt function, pin 23)
# Used pin 17 for +3.3V, pin 25 for ground for V digital and analog

#start pigpio daemon
sudo pigpiod -g -x -1

# MCLK is connected to pin 7, set to 25MHz
pigs hc 4 25000000

#open spi connection on spi0 channel 0 100kBaud mode 3--polarity high phase high

pigs spio 0 100000 1064451                                                  
# returned handle 0 for use below
# the 1064451 is (see pigs man page for spio):
#21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0           
# b  b  b  b  b  b  R  T  n  n  n  n  W  A u2 u1 u0 p2 p1 p0  m  m           
# 0  1  0  0  0  0  0  0  1  1  1  1  1  0  0  0  0  0  0  0  1  1 

# create 400Hz Sine Wave (see http://www.analog.com/media/en/technical-documentation/application-notes/AN-1070.pdf)
# 0x2100 0010 0001 0000 0000
# 0x50C7 0101 0000 1100 0111
# 0x4000 0100 0000 0000 0000
# 0xC000 1100 0000 0000 0000
# 0x2000 0010 0000 0000 0000
pigs spiw 0 0x21 0x00 0x50 0xc7 0x40 0x00 0xc0 0x00 0x20 0x00               

# close handle
pigs spic 0 
