/*  
    DC-10 - A C10 clock implementation by Danjovic
	(c) Daniel Jose Viana, 2016 - danjovic@hotmail.com
	Release under GPL V2.0

	V0.1 - April 23, 2016 - basic implementation
*/

#include <16f628.h> 
#fuses XT,NOWDT,NOPROTECT, NOPUT, NOMCLR, NOBROWNOUT 
#use delay(clock=4000000) 


// ****** Definitions ******
#define _t40ms 10

//           GFABCDE.
#define _0 0b01111110
#define _1 0b00011000
#define _2 0b10110110
#define _3 0b10111100
#define _4 0b11011000
#define _5 0b11101100
#define _6 0b11101110
#define _7 0b00011100
#define _8 0b11111110
#define _9 0b11111100

#define _decimal_point 0 // bit where dp is mapped

#define BUTTON1 (PORTA & (1<<4))  // RA4
#define BUTTON2 (PORTA & (1<<5))  // RA5

// ****** SFR Definitions ******
#byte PORTA      = 0x05
#byte PORTB      = 0x06
#byte TRISA      = 0x85
#byte TRISB      = 0x86
#byte OPTION_REG = 0x81
#byte INTCON     = 0x0B


// ****** Constants ******
BYTE CONST common[4] = { 1, 2, 4, 8 }; // common pins for displays
BYTE CONST digits[10] = { _0,_1,_2,_3,_4,_5,_6,_7,_8,_9 };
  

// ****** Variables ******
static volatile char go,go_counter,new_tick=0; // 4ms tick
unsigned char tick_01,tick_10,interval_01,interval_10,centival_01,centival_10=0;
unsigned char digit=0;
unsigned char display [4] = { _0,_0,_0,_0 };
unsigned char Time_B1_Pressed,Time_B2_Pressed=0;

static int32 bres=0; 


// ****** Interrupts ******
#int_timer0 
void timer0interrupt() {
	// interrupt each 256us
	bres+=256;
	if (bres>=86400) { 
		bres=bres-86400;
		new_tick=1;
	}
	if ((++go_counter&15) == 0) go=1;
}


// ****** Functions ******
unsigned char advance_tick(void) {
	unsigned char r=0;
	// increment units and tenths
	if (++tick_01>9) {
		tick_01=0;
		
		if (++tick_10>9){
			tick_10=0;
			r=1;   // overflow
		}
		// update display each 10 ticks (0,864s)
		display [1] ^= _decimal_point;
		display [2] ^= _decimal_point;	
	}
	return r;
}


unsigned char advance_centival(void) {
	unsigned char r=0;
	// increment units and tenths
	if (++centival_01>9) {
		centival_01=0;
		if (++centival_10>9){
			centival_10=0;
			r=1;   // overflow
		}
	}
	// update display
	display [3] = digits[centival_01];
	display [2] = digits[centival_10];	
	return r;
}


unsigned char advance_interval(void) {
	unsigned char r=0;
	// increment units and tenths
	if (++interval_01>9) {
		interval_01=0;
		if (++interval_10>9){
			interval_10=0;
			r=1;   // overflow
		}
	}
	// update display
	display [1] = digits[interval_01];
	display [0] = digits[interval_10];		
	return r;
}

void init_hw(void){
	// initialize I/O ports
	TRISB=0b00000000; // All as outputs (segments) 
	TRISA=0b11110000; // bits [3..0] as outputs (common a/k)

	// initialize prescale and interrupts
	OPTION_REG = 0b11011111;  // Timer0 internal clock, 1:1 rate (prescaler to wdt)
	INTCON     = 0b10100000;  // enable timer0 and global interrupts

	

}


// ****** Main ******
void main (void) {

	init_hw(); // Initialize hardware
	
	// main loop
	for (;;){
		while (!go); // wait for 4ms flag
		go=0;        // reset go flag
		
		// check if new tick (84,4ms or ~21/22 go's) 
		if (new_tick) {
			new_tick=0;
			if (advance_tick()) {
				if (advance_centival()) {
					advance_interval();
				}
			}
		}
		
		// update display
		++digit&=3;  // next digit to display
		PORTA=common[digit];
		PORTB=display[digit]; // update display

		// Test for buttons
		if (PORTA & BUTTON1) { // Release
			if (Time_B1_Pressed > _t40ms) {
				advance_centival();
			}
			Time_B1_Pressed =0;
		} else {// button pressed
			if (Time_B1_Pressed<255) Time_B1_Pressed++;
		}

		if (PORTA & BUTTON2) { // Release
			if (Time_B2_Pressed > _t40ms) {
				advance_interval();
			}
			Time_B2_Pressed =0;
		} else {// button pressed
			if (Time_B2_Pressed<255) Time_B2_Pressed++;
		}		
	} // end of main loop
}
