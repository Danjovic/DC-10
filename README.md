# DC-10
My implementation of a clock using the C10 decimal time system

In the decimal time system one whole day is divided into 100 intervals which are subsequently divide into 100 'centivals' wich in turn are divided into 100 'ticks'.

Using more familiar base12 time base as a reference we have:

1 tick = 86,4ms

10 ticks = 864ms = 0,864 seconds (a bit less than a second)

100 ticks = 8,64 seconds = 1 centival

1000 ticks = 86,4 seconds = 10 centivals   (1 minute and 26 seconds)

10000 ticks = 864 seconds = 1 interval    (14 minutes and 24 seconds)

10000 ticks = 8640 seconds = 10 intervals (2 hours and 24 minutes)   

100000 ticks = 86400 seconds = 100 intervals (24 hours)

This project implements a very simple digital clock with 4 digits capable of showing centivals and intervals. The least significant digit changes each decival (8,64 seconds) and the most significant turns every 10 intervals (2 hours and 24 minutes)

The circuit is based on a PIC16F628 and four 7-segment displays in a conventional multiplex configuration. One of the displays is turned upside down so we can have two decimal points to separate intervals from decivals.  

The timebase is provided by a 4.0Mhz crystal which generates a tick (86,4ms) using a bresenham algorythm (code borrowed from Roman Black). As a result we have some microseconds of jitter yet imperceptible to the eye.

Each display is turned on by 4ms at a time which gives an overall display refresh rate of 16ms or ~60Hz in terms of frequency. 

There are two buttons to adjust the time. One is for advance the centivals while another advances the intervals. 

The circuit board measures 60x42mm (2.35" x 1.65") and it was designed to be single face friendly with few connections on the upper side and no connection on the top layer is hidden under any component.

The firmware uses the timer0 running at 1:1 thus overflowing exactly each 256us. At every 16 interrupts or 4096us a flag is set to allow the main loop to run. Another flag is set at each tick (86.4ms) and tells the main loop to increment the tick counter. At 100 ticks the main loop calls the function to increment the decivals and after 100 decivals another function is called to increment the intervals. Functions were used to implement the increments to make easy to perform the increments when commanded by the buttons. 
