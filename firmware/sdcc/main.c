/*  
    DC-10 - A C10 clock implementation by Danjovic
	(c) Daniel Jose Viana, 2016 - danjovic@hotmail.com
	Release under GPL V2.0

	V0.1 - April 23, 2016 - basic implementation
	V0.2 - November 26, 2016 - Ported to SDCC
*/

#include <pic16f628.h>
#include <stdint.h>
#include <stdbool.h>

uint16_t __at _CONFIG configWord = _HS_OSC & _WDT_OFF & _PWRTE_ON & _MCLRE_OFF & _BODEN_OFF & _LVP_OFF &  _CPD_OFF &  _CP_OFF; 


// ****** Definitions ******
#define _t40ms 10
/*  Original PCB
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
*/

// Prototype pinout
//            D.CGBFAE
#define _0 ~0b10101111
#define _1 ~0b00101000
#define _2 ~0b10011011
#define _3 ~0b10111010
#define _4 ~0b00111100
#define _5 ~0b10110110
#define _6 ~0b10110111
#define _7 ~0b00101010
#define _8 ~0b10111111
#define _9 ~0b10111110


#define _decimal_point (1<<6) // bit where dp is mapped

#define BUTTON1 ((PORTA & (1<<4)))  // RA4
#define BUTTON2 ((PORTA & (1<<5)))  // RA5
#define BYTE unsigned char

// ****** SFR Definitions ******
//CCS C only
//#byte PORTA      = 0x05
//#byte PORTB      = 0x06
//#byte TRISA      = 0x85
//#byte TRISB      = 0x86
//#byte OPTION_REG = 0x81
//#byte INTCON     = 0x0B


// ****** Constants ******
const unsigned char common[4] = { 1, 2, 4, 8 }; // common pins for displays
const unsigned char digits[10] = { _0,_1,_2,_3,_4,_5,_6,_7,_8,_9 };
  

// ****** Variables ******
static volatile unsigned char go=0;
static volatile unsigned char go_counter=0;
static volatile unsigned char new_tick=0; // 4ms tick
//unsigned char tick_01,tick_10,interval_01,interval_10,centival_01,centival_10=0;
  
unsigned char tick_01=0;
unsigned char tick_10=0;
unsigned char interval_01=0;
unsigned char interval_10=0;
unsigned char centival_01=0;
unsigned char centival_10=0;

unsigned char digit=0;
unsigned char display [4] = { _0,_0,_0,_0 };
unsigned char Time_B1_Pressed,Time_B2_Pressed=0;

static uint32_t bres=0; 


// ****** Interrupts ******
//#int_timer0 
//void timer0interrupt() {
	
//static void isr(void) interrupt 0 {	
static void irqHandler(void) __interrupt 0 {
	// interrupt each 256us
	bres+=256;
	if (bres>=86400) { 
		bres=bres-86400;
		new_tick=1;
	}
	if ((++go_counter&15) == 0) go=1;
	
	T0IF = 0;
}


// ****** Functions ******
unsigned char advance_tick(void) {
	unsigned char r=0;
	// increment units and tenths
	if ((++tick_01)>9) {
		tick_01=0;
		
		if ((++tick_10)>9){
			tick_10=0;
			r=1;   // overflow
		}
		// update display each 10 ticks (0,864s)
		display [1] ^= _decimal_point;
		//display [2] ^= _decimal_point;	
	}
	return r;
}


unsigned char advance_centival(void) {
	unsigned char r=0;
	// increment units and tenths
	if ((++centival_01)>9) {
		centival_01=0;
		if ((++centival_10)>9){
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
	TMR0  =0;
	T0IF  = 0;
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
		++digit;
		digit&=3;  // next digit to display
		PORTA=common[digit];
		PORTB=display[digit]; // update display

		// Test for buttons
		if (BUTTON1) { // button pressed
			if (Time_B1_Pressed<255) Time_B1_Pressed++;	
		} else {       // Release
			if (Time_B1_Pressed > _t40ms) {
				advance_centival();
			}
			Time_B1_Pressed =0;
		}

		if (BUTTON2) { // button pressed
			if (Time_B2_Pressed<255) Time_B2_Pressed++;	
		} else {       // Release
			if (Time_B2_Pressed > _t40ms) {
				advance_interval();
			}
			Time_B2_Pressed =0;
		}		
	} // end of main loop
}
