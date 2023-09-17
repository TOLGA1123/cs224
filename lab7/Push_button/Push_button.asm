_Wait:
;Push_button.c,17 :: 		void Wait() {
;Push_button.c,18 :: 		Delay_ms(1000);
LUI	R24, 50
ORI	R24, R24, 56532
L_Wait0:
ADDIU	R24, R24, -1
BNE	R24, R0, L_Wait0
NOP	
NOP	
NOP	
;Push_button.c,19 :: 		}
L_end_Wait:
JR	RA
NOP	
; end of _Wait
_main:
;Push_button.c,21 :: 		void main() {
;Push_button.c,23 :: 		AD1PCFG = 0xFFFF;
ORI	R2, R0, 65535
SW	R2, Offset(AD1PCFG+0)(GP)
;Push_button.c,25 :: 		DDPCON.JTAGEN = 0; // disable JTAG
LBU	R2, Offset(DDPCON+0)(GP)
INS	R2, R0, 3, 1
SB	R2, Offset(DDPCON+0)(GP)
;Push_button.c,27 :: 		TRISA = 0x0000;  //portA is output to turn on LEDs.
SW	R0, Offset(TRISA+0)(GP)
;Push_button.c,28 :: 		TRISE = 0XFFFF;  //portE is inputs to read push-buttons.
ORI	R2, R0, 65535
SW	R2, Offset(TRISE+0)(GP)
;Push_button.c,30 :: 		LATA = 0Xffff;
ORI	R2, R0, 65535
SW	R2, Offset(LATA+0)(GP)
;Push_button.c,31 :: 		LATE = 0X0000;
SW	R0, Offset(LATE+0)(GP)
;Push_button.c,34 :: 		LATA=0xffff;
ORI	R2, R0, 65535
SW	R2, Offset(LATA+0)(GP)
;Push_button.c,35 :: 		Wait();
JAL	_Wait+0
NOP	
;Push_button.c,36 :: 		LATA=0x0000;
SW	R0, Offset(LATA+0)(GP)
;Push_button.c,37 :: 		Wait();
JAL	_Wait+0
NOP	
;Push_button.c,40 :: 		while(1)
L_main2:
;Push_button.c,42 :: 		portA = portE; // read push-buttons and assign them to LEDs
LW	R2, Offset(PORTE+0)(GP)
SW	R2, Offset(PORTA+0)(GP)
;Push_button.c,43 :: 		}//while
J	L_main2
NOP	
;Push_button.c,45 :: 		}//main
L_end_main:
L__main_end_loop:
J	L__main_end_loop
NOP	
; end of _main
