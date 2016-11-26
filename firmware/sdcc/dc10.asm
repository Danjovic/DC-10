;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Jun 20 2015) (MINGW64)
; This file was generated Sat Nov 26 03:09:07 2016
;--------------------------------------------------------
; PIC port for the 14-bit core
;--------------------------------------------------------
;	.file	"main.c"
	list	p=16f628
	radix dec
	include "p16f628.inc"
;--------------------------------------------------------
; config word(s)
;--------------------------------------------------------
	__config 0x3f02
;--------------------------------------------------------
; external declarations
;--------------------------------------------------------
	extern	_STATUSbits
	extern	_PORTAbits
	extern	_PORTBbits
	extern	_INTCONbits
	extern	_PIR1bits
	extern	_T1CONbits
	extern	_T2CONbits
	extern	_CCP1CONbits
	extern	_RCSTAbits
	extern	_CMCONbits
	extern	_OPTION_REGbits
	extern	_TRISAbits
	extern	_TRISBbits
	extern	_PIE1bits
	extern	_PCONbits
	extern	_TXSTAbits
	extern	_EECON1bits
	extern	_VRCONbits
	extern	_INDF
	extern	_TMR0
	extern	_PCL
	extern	_STATUS
	extern	_FSR
	extern	_PORTA
	extern	_PORTB
	extern	_PCLATH
	extern	_INTCON
	extern	_PIR1
	extern	_TMR1
	extern	_TMR1L
	extern	_TMR1H
	extern	_T1CON
	extern	_TMR2
	extern	_T2CON
	extern	_CCPR1
	extern	_CCPR1L
	extern	_CCPR1H
	extern	_CCP1CON
	extern	_RCSTA
	extern	_TXREG
	extern	_RCREG
	extern	_CMCON
	extern	_OPTION_REG
	extern	_TRISA
	extern	_TRISB
	extern	_PIE1
	extern	_PCON
	extern	_PR2
	extern	_TXSTA
	extern	_SPBRG
	extern	_EEDATA
	extern	_EEADR
	extern	_EECON1
	extern	_EECON2
	extern	_VRCON
	extern	___sdcc_saved_fsr
	extern	__gptrget1
	extern	__sdcc_gsinit_startup
;--------------------------------------------------------
; global declarations
;--------------------------------------------------------
	global	_advance_tick
	global	_advance_centival
	global	_advance_interval
	global	_init_hw
	global	_main
	global	_tick_01
	global	_tick_10
	global	_interval_01
	global	_interval_10
	global	_centival_01
	global	_centival_10
	global	_digit
	global	_display
	global	_Time_B1_Pressed
	global	_Time_B2_Pressed
	global	_common
	global	_digits

	global PSAVE
	global SSAVE
	global WSAVE
	global STK12
	global STK11
	global STK10
	global STK09
	global STK08
	global STK07
	global STK06
	global STK05
	global STK04
	global STK03
	global STK02
	global STK01
	global STK00

sharebank udata_ovr 0x0070
PSAVE	res 1
SSAVE	res 1
WSAVE	res 1
STK12	res 1
STK11	res 1
STK10	res 1
STK09	res 1
STK08	res 1
STK07	res 1
STK06	res 1
STK05	res 1
STK04	res 1
STK03	res 1
STK02	res 1
STK01	res 1
STK00	res 1

;--------------------------------------------------------
; global definitions
;--------------------------------------------------------
UD_main_0	udata
_Time_B1_Pressed	res	1

;--------------------------------------------------------
; absolute symbol definitions
;--------------------------------------------------------
;--------------------------------------------------------
; compiler-defined variables
;--------------------------------------------------------
UDL_main_0	udata
r0x1015	res	1
r0x1016	res	1
r0x1017	res	1
r0x1018	res	1
r0x1019	res	1
r0x101A	res	1
;--------------------------------------------------------
; initialized data
;--------------------------------------------------------

ID_main_0	idata
_go
	db	0x00


ID_main_1	idata
_go_counter
	db	0x00


ID_main_2	idata
_new_tick
	db	0x00


ID_main_3	idata
_tick_01
	db	0x00


ID_main_4	idata
_tick_10
	db	0x00


ID_main_5	idata
_interval_01
	db	0x00


ID_main_6	idata
_interval_10
	db	0x00


ID_main_7	idata
_centival_01
	db	0x00


ID_main_8	idata
_centival_10
	db	0x00


ID_main_9	idata
_digit
	db	0x00


ID_main_10	idata
_display
	db	0x50
	db	0x50
	db	0x50
	db	0x50


ID_main_11	idata
_Time_B2_Pressed
	db	0x00


ID_main_12	idata
_bres
	db	0x00, 0x00, 0x00, 0x00


ID_main_13	code
_common
	retlw 0x01
	retlw 0x02
	retlw 0x04
	retlw 0x08


ID_main_14	code
_digits
	retlw 0x50
	retlw 0xd7
	retlw 0x64
	retlw 0x45
	retlw 0xc3
	retlw 0x49
	retlw 0x48
	retlw 0xd5
	retlw 0x40
	retlw 0x41

;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
;	udata_ovr
;--------------------------------------------------------
; reset vector 
;--------------------------------------------------------
STARTUP	code 0x0000
	nop
	pagesel __sdcc_gsinit_startup
	goto	__sdcc_gsinit_startup
;--------------------------------------------------------
; interrupt and initialization code
;--------------------------------------------------------
c_interrupt	code	0x4
__sdcc_interrupt
;***
;  pBlock Stats: dbName = I
;***
;entry:  _irqHandler	;Function start
; 0 exit points
;; Starting pCode block
_irqHandler	;Function start
; 0 exit points
;	.line	93; "main.c"	static void irqHandler(void) __interrupt 0 {
	MOVWF	WSAVE
	SWAPF	STATUS,W
	CLRF	STATUS
	MOVWF	SSAVE
	MOVF	PCLATH,W
	CLRF	PCLATH
	MOVWF	PSAVE
	MOVF	FSR,W
	BANKSEL	___sdcc_saved_fsr
	MOVWF	___sdcc_saved_fsr
;	.line	95; "main.c"	bres+=256;
	BANKSEL	_bres
	INCF	(_bres + 1),F
	BTFSC	STATUS,2
	INCF	(_bres + 2),F
	BTFSC	STATUS,2
	INCF	(_bres + 3),F
;;unsigned compare: left < lit(0x15180=86400), size=4
;	.line	96; "main.c"	if (bres>=86400) { 
	MOVLW	0x00
	SUBWF	(_bres + 3),W
	BTFSS	STATUS,2
	GOTO	_00117_DS_
	MOVLW	0x01
	SUBWF	(_bres + 2),W
	BTFSS	STATUS,2
	GOTO	_00117_DS_
	MOVLW	0x51
	SUBWF	(_bres + 1),W
	BTFSS	STATUS,2
	GOTO	_00117_DS_
	MOVLW	0x80
	SUBWF	_bres,W
_00117_DS_
	BTFSS	STATUS,0
	GOTO	_00106_DS_
;;genSkipc:3247: created from rifx:00000000047558E0
;	.line	97; "main.c"	bres=bres-86400;
	MOVLW	0x80
	BANKSEL	_bres
	ADDWF	_bres,F
	MOVLW	0xae
	BTFSC	STATUS,0
	MOVLW	0xaf
	ADDWF	(_bres + 1),F
	MOVLW	0xfe
	BTFSC	STATUS,0
	MOVLW	0xff
	ADDWF	(_bres + 2),F
	MOVLW	0xff
	BTFSS	STATUS,0
	ADDWF	(_bres + 3),F
;	.line	98; "main.c"	new_tick=1;
	MOVLW	0x01
	BANKSEL	_new_tick
	MOVWF	_new_tick
_00106_DS_
;	.line	100; "main.c"	if ((++go_counter&15) == 0) go=1;
	BANKSEL	_go_counter
	INCF	_go_counter,F
	MOVF	_go_counter,W
	ANDLW	0x0f
	BTFSS	STATUS,2
	GOTO	_00108_DS_
	MOVLW	0x01
	BANKSEL	_go
	MOVWF	_go
_00108_DS_
;	.line	102; "main.c"	T0IF = 0;
	BANKSEL	_INTCONbits
	BCF	_INTCONbits,2
	BANKSEL	___sdcc_saved_fsr
	MOVF	___sdcc_saved_fsr,W
	BANKSEL	FSR
	MOVWF	FSR
	MOVF	PSAVE,W
	MOVWF	PCLATH
	CLRF	STATUS
	SWAPF	SSAVE,W
	MOVWF	STATUS
	SWAPF	WSAVE,F
	SWAPF	WSAVE,W
END_OF_INTERRUPT
	RETFIE	

;--------------------------------------------------------
; code
;--------------------------------------------------------
code_main	code
;***
;  pBlock Stats: dbName = M
;***
;entry:  _main	;Function start
; 2 exit points
;has an exit
;functions called:
;   _init_hw
;   _advance_tick
;   _advance_centival
;   _advance_interval
;   __gptrget1
;   _advance_centival
;   _advance_interval
;   _init_hw
;   _advance_tick
;   _advance_centival
;   _advance_interval
;   __gptrget1
;   _advance_centival
;   _advance_interval
;4 compiler assigned registers:
;   r0x1019
;   r0x101A
;   STK01
;   STK00
;; Starting pCode block
_main	;Function start
; 2 exit points
;	.line	174; "main.c"	init_hw(); // Initialize hardware
	CALL	_init_hw
_00150_DS_
;	.line	178; "main.c"	while (!go); // wait for 4ms flag
	MOVLW	0x00
	BANKSEL	_go
	IORWF	_go,W
	BTFSC	STATUS,2
	GOTO	_00150_DS_
;	.line	179; "main.c"	go=0;        // reset go flag
	CLRF	_go
;	.line	182; "main.c"	if (new_tick) {
	BANKSEL	_new_tick
	MOVF	_new_tick,W
	BTFSC	STATUS,2
	GOTO	_00158_DS_
;	.line	183; "main.c"	new_tick=0;
	CLRF	_new_tick
;	.line	184; "main.c"	if (advance_tick()) {
	CALL	_advance_tick
	BANKSEL	r0x1019
	MOVWF	r0x1019
	MOVF	r0x1019,W
	BTFSC	STATUS,2
	GOTO	_00158_DS_
;	.line	185; "main.c"	if (advance_centival()) {
	CALL	_advance_centival
	BANKSEL	r0x1019
	MOVWF	r0x1019
;	.line	186; "main.c"	advance_interval();
	MOVF	r0x1019,W
;	.line	192; "main.c"	++digit;
	BTFSS	STATUS,2
	CALL	_advance_interval
_00158_DS_
	BANKSEL	_digit
	INCF	_digit,F
;	.line	193; "main.c"	digit&=3;  // next digit to display
	MOVLW	0x03
	ANDWF	_digit,F
;	.line	194; "main.c"	PORTA=common[digit];
	MOVF	_digit,W
	ADDLW	(_common + 0)
	BANKSEL	r0x1019
	MOVWF	r0x1019
	MOVLW	high (_common + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x101A
	MOVF	r0x1019,W
	MOVWF	STK01
	MOVF	r0x101A,W
	MOVWF	STK00
	MOVLW	0x80
	PAGESEL	__gptrget1
	CALL	__gptrget1
	PAGESEL	$
	BANKSEL	_PORTA
	MOVWF	_PORTA
;	.line	195; "main.c"	PORTB=display[digit]; // update display
	BANKSEL	_digit
	MOVF	_digit,W
	ADDLW	(_display + 0)
	BANKSEL	r0x1019
	MOVWF	r0x1019
	MOVLW	high (_display + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x101A
	MOVF	r0x1019,W
	BANKSEL	FSR
	MOVWF	FSR
	BCF	STATUS,7
	BANKSEL	r0x101A
	BTFSC	r0x101A,0
	BSF	STATUS,7
	BANKSEL	INDF
	MOVF	INDF,W
	MOVWF	_PORTB
;	.line	198; "main.c"	if (PORTA & BUTTON1) { // Release
	MOVLW	0x10
	ANDWF	_PORTA,W
	BANKSEL	r0x1019
	MOVWF	r0x1019
	BANKSEL	_PORTA
	MOVF	_PORTA,W
	BANKSEL	r0x1019
	ANDWF	r0x1019,F
	MOVF	r0x1019,W
	BTFSC	STATUS,2
	GOTO	_00164_DS_
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0xB=11), size=1
;	.line	199; "main.c"	if (Time_B1_Pressed > _t40ms) {
	MOVLW	0x0b
;	.line	200; "main.c"	advance_centival();
	BANKSEL	_Time_B1_Pressed
	SUBWF	_Time_B1_Pressed,W
;	.line	202; "main.c"	Time_B1_Pressed =0;
	BTFSC	STATUS,0
	CALL	_advance_centival
	BANKSEL	_Time_B1_Pressed
	CLRF	_Time_B1_Pressed
	GOTO	_00165_DS_
;;unsigned compare: left < lit(0xFF=255), size=1
_00164_DS_
;	.line	204; "main.c"	if (Time_B1_Pressed<255) Time_B1_Pressed++;
	MOVLW	0xff
;	.line	207; "main.c"	if (PORTA & BUTTON2) { // Release
	BANKSEL	_Time_B1_Pressed
	SUBWF	_Time_B1_Pressed,W
	BTFSS	STATUS,0
	INCF	_Time_B1_Pressed,F
_00165_DS_
	MOVLW	0x20
	BANKSEL	_PORTA
	ANDWF	_PORTA,W
	BANKSEL	r0x1019
	MOVWF	r0x1019
	BANKSEL	_PORTA
	MOVF	_PORTA,W
	BANKSEL	r0x1019
	ANDWF	r0x1019,F
	MOVF	r0x1019,W
	BTFSC	STATUS,2
	GOTO	_00171_DS_
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0xB=11), size=1
;	.line	208; "main.c"	if (Time_B2_Pressed > _t40ms) {
	MOVLW	0x0b
;	.line	209; "main.c"	advance_interval();
	BANKSEL	_Time_B2_Pressed
	SUBWF	_Time_B2_Pressed,W
;	.line	211; "main.c"	Time_B2_Pressed =0;
	BTFSC	STATUS,0
	CALL	_advance_interval
	BANKSEL	_Time_B2_Pressed
	CLRF	_Time_B2_Pressed
	GOTO	_00150_DS_
;;unsigned compare: left < lit(0xFF=255), size=1
_00171_DS_
;	.line	213; "main.c"	if (Time_B2_Pressed<255) Time_B2_Pressed++;
	MOVLW	0xff
	BANKSEL	_Time_B2_Pressed
	SUBWF	_Time_B2_Pressed,W
	BTFSC	STATUS,0
	GOTO	_00150_DS_
;;genSkipc:3247: created from rifx:00000000047558E0
	INCF	_Time_B2_Pressed,F
	GOTO	_00150_DS_
	RETURN	
; exit point of _main

;***
;  pBlock Stats: dbName = C
;***
;entry:  _init_hw	;Function start
; 2 exit points
;has an exit
;; Starting pCode block
_init_hw	;Function start
; 2 exit points
;	.line	160; "main.c"	TRISB=0b00000000; // All as outputs (segments) 
	BANKSEL	_TRISB
	CLRF	_TRISB
;	.line	161; "main.c"	TRISA=0b11110000; // bits [3..0] as outputs (common a/k)
	MOVLW	0xf0
	MOVWF	_TRISA
;	.line	164; "main.c"	OPTION_REG = 0b11011111;  // Timer0 internal clock, 1:1 rate (prescaler to wdt)
	MOVLW	0xdf
	MOVWF	_OPTION_REG
;	.line	165; "main.c"	TMR0  =0;
	BANKSEL	_TMR0
	CLRF	_TMR0
;	.line	166; "main.c"	T0IF  = 0;
	BCF	_INTCONbits,2
;	.line	167; "main.c"	INTCON     = 0b10100000;  // enable timer0 and global interrupts
	MOVLW	0xa0
	MOVWF	_INTCON
	RETURN	
; exit point of _init_hw

;***
;  pBlock Stats: dbName = C
;***
;entry:  _advance_interval	;Function start
; 2 exit points
;has an exit
;functions called:
;   __gptrget1
;   __gptrget1
;   __gptrget1
;   __gptrget1
;6 compiler assigned registers:
;   r0x1015
;   r0x1016
;   r0x1017
;   STK01
;   STK00
;   r0x1018
;; Starting pCode block
_advance_interval	;Function start
; 2 exit points
;	.line	143; "main.c"	unsigned char r=0;
	BANKSEL	r0x1015
	CLRF	r0x1015
;	.line	145; "main.c"	if (++interval_01>9) {
	BANKSEL	_interval_01
	INCF	_interval_01,F
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0xA=10), size=1
	MOVLW	0x0a
	SUBWF	_interval_01,W
	BTFSS	STATUS,0
	GOTO	_00141_DS_
;;genSkipc:3247: created from rifx:00000000047558E0
;	.line	146; "main.c"	interval_01=0;
	CLRF	_interval_01
;	.line	147; "main.c"	if (++interval_10>9){
	BANKSEL	_interval_10
	INCF	_interval_10,F
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0xA=10), size=1
	MOVLW	0x0a
	SUBWF	_interval_10,W
	BTFSS	STATUS,0
	GOTO	_00141_DS_
;;genSkipc:3247: created from rifx:00000000047558E0
;	.line	148; "main.c"	interval_10=0;
	CLRF	_interval_10
;	.line	149; "main.c"	r=1;   // overflow
	MOVLW	0x01
	BANKSEL	r0x1015
	MOVWF	r0x1015
_00141_DS_
;	.line	153; "main.c"	display [1] = digits[interval_01];
	BANKSEL	_interval_01
	MOVF	_interval_01,W
	ADDLW	(_digits + 0)
	BANKSEL	r0x1016
	MOVWF	r0x1016
	MOVLW	high (_digits + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x1017
	MOVF	r0x1016,W
	MOVWF	STK01
	MOVF	r0x1017,W
	MOVWF	STK00
	MOVLW	0x80
	PAGESEL	__gptrget1
	CALL	__gptrget1
	PAGESEL	$
	BANKSEL	r0x1018
	MOVWF	r0x1018
	BANKSEL	_display
	MOVWF	(_display + 1)
;	.line	154; "main.c"	display [0] = digits[interval_10];		
	BANKSEL	_interval_10
	MOVF	_interval_10,W
	ADDLW	(_digits + 0)
	BANKSEL	r0x1016
	MOVWF	r0x1016
	MOVLW	high (_digits + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x1017
	MOVF	r0x1016,W
	MOVWF	STK01
	MOVF	r0x1017,W
	MOVWF	STK00
	MOVLW	0x80
	PAGESEL	__gptrget1
	CALL	__gptrget1
	PAGESEL	$
	BANKSEL	r0x1018
	MOVWF	r0x1018
	BANKSEL	_display
	MOVWF	(_display + 0)
;	.line	155; "main.c"	return r;
	BANKSEL	r0x1015
	MOVF	r0x1015,W
	RETURN	
; exit point of _advance_interval

;***
;  pBlock Stats: dbName = C
;***
;entry:  _advance_centival	;Function start
; 2 exit points
;has an exit
;functions called:
;   __gptrget1
;   __gptrget1
;   __gptrget1
;   __gptrget1
;6 compiler assigned registers:
;   r0x1015
;   r0x1016
;   r0x1017
;   STK01
;   STK00
;   r0x1018
;; Starting pCode block
_advance_centival	;Function start
; 2 exit points
;	.line	126; "main.c"	unsigned char r=0;
	BANKSEL	r0x1015
	CLRF	r0x1015
;	.line	128; "main.c"	if ((++centival_01)>9) {
	BANKSEL	_centival_01
	INCF	_centival_01,F
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0xA=10), size=1
	MOVLW	0x0a
	SUBWF	_centival_01,W
	BTFSS	STATUS,0
	GOTO	_00133_DS_
;;genSkipc:3247: created from rifx:00000000047558E0
;	.line	129; "main.c"	centival_01=0;
	CLRF	_centival_01
;	.line	130; "main.c"	if ((++centival_10)>9){
	BANKSEL	_centival_10
	INCF	_centival_10,F
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0xA=10), size=1
	MOVLW	0x0a
	SUBWF	_centival_10,W
	BTFSS	STATUS,0
	GOTO	_00133_DS_
;;genSkipc:3247: created from rifx:00000000047558E0
;	.line	131; "main.c"	centival_10=0;
	CLRF	_centival_10
;	.line	132; "main.c"	r=1;   // overflow
	MOVLW	0x01
	BANKSEL	r0x1015
	MOVWF	r0x1015
_00133_DS_
;	.line	136; "main.c"	display [3] = digits[centival_01];
	BANKSEL	_centival_01
	MOVF	_centival_01,W
	ADDLW	(_digits + 0)
	BANKSEL	r0x1016
	MOVWF	r0x1016
	MOVLW	high (_digits + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x1017
	MOVF	r0x1016,W
	MOVWF	STK01
	MOVF	r0x1017,W
	MOVWF	STK00
	MOVLW	0x80
	PAGESEL	__gptrget1
	CALL	__gptrget1
	PAGESEL	$
	BANKSEL	r0x1018
	MOVWF	r0x1018
	BANKSEL	_display
	MOVWF	(_display + 3)
;	.line	137; "main.c"	display [2] = digits[centival_10];	
	BANKSEL	_centival_10
	MOVF	_centival_10,W
	ADDLW	(_digits + 0)
	BANKSEL	r0x1016
	MOVWF	r0x1016
	MOVLW	high (_digits + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x1017
	MOVF	r0x1016,W
	MOVWF	STK01
	MOVF	r0x1017,W
	MOVWF	STK00
	MOVLW	0x80
	PAGESEL	__gptrget1
	CALL	__gptrget1
	PAGESEL	$
	BANKSEL	r0x1018
	MOVWF	r0x1018
	BANKSEL	_display
	MOVWF	(_display + 2)
;	.line	138; "main.c"	return r;
	BANKSEL	r0x1015
	MOVF	r0x1015,W
	RETURN	
; exit point of _advance_centival

;***
;  pBlock Stats: dbName = C
;***
;entry:  _advance_tick	;Function start
; 2 exit points
;has an exit
;2 compiler assigned registers:
;   r0x1015
;   r0x1016
;; Starting pCode block
_advance_tick	;Function start
; 2 exit points
;	.line	108; "main.c"	unsigned char r=0;
	BANKSEL	r0x1015
	CLRF	r0x1015
;	.line	110; "main.c"	if ((++tick_01)>9) {
	BANKSEL	_tick_01
	INCF	_tick_01,F
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0xA=10), size=1
	MOVLW	0x0a
	SUBWF	_tick_01,W
	BTFSS	STATUS,0
	GOTO	_00125_DS_
;;genSkipc:3247: created from rifx:00000000047558E0
;	.line	111; "main.c"	tick_01=0;
	CLRF	_tick_01
;	.line	113; "main.c"	if ((++tick_10)>9){
	BANKSEL	_tick_10
	INCF	_tick_10,F
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0xA=10), size=1
	MOVLW	0x0a
	SUBWF	_tick_10,W
	BTFSS	STATUS,0
	GOTO	_00123_DS_
;;genSkipc:3247: created from rifx:00000000047558E0
;	.line	114; "main.c"	tick_10=0;
	CLRF	_tick_10
;	.line	115; "main.c"	r=1;   // overflow
	MOVLW	0x01
	BANKSEL	r0x1015
	MOVWF	r0x1015
_00123_DS_
;	.line	118; "main.c"	display [1] ^= _decimal_point;
	BANKSEL	_display
	MOVF	(_display + 1),W
	BANKSEL	r0x1016
	MOVWF	r0x1016
	MOVLW	0x40
	XORWF	r0x1016,F
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6461: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1016,W
	BANKSEL	_display
	MOVWF	(_display + 1)
_00125_DS_
;	.line	121; "main.c"	return r;
	BANKSEL	r0x1015
	MOVF	r0x1015,W
	RETURN	
; exit point of _advance_tick


;	code size estimation:
;	  280+   80 =   360 instructions (  880 byte)

	end
