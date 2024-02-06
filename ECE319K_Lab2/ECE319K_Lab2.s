//****************** ECE319K_Lab2.s ***************
// Your solution to Lab 2 in assembly code
// Author: Colby C. McLane
// Last Modified: 2/5/2024
// ECE319K Spring 2024 (ECE319H students do Lab2H)

// ECE319K Lab 2, Spring 2024
// Student EID= CCM3887
// Implement the Change switch using PB0
// Implement the LED on PB18
// Implement duty cycles 15,35,45,75%, Score=0
   .equ GPIOB_RSTCTL,   0x400A2804
   .equ GPIOB_PWREN,    0x400A2800
   .equ GPIOB_DOE31_0,  0x400A32C0
   .equ GPIOB_DOUT31_0, 0x400A3280
   .equ GPIOB_DIN31_0,  0x400A3380
   .equ IOMUXPB0,       0x40428004+4*11
   .equ IOMUXPB1,       0x40428004+4*12
   .equ IOMUXPB2,       0x40428004+4*14
   .equ IOMUXPB3,       0x40428004+4*15
   .equ IOMUXPB16,      0x40428004+4*32
   .equ IOMUXPB17,      0x40428004+4*42
   .equ IOMUXPB18,      0x40428004+4*43

        .data
        .align 2
// Declare global variables here if needed
// with the .space assembly directive

        .text
        .thumb
        .align 2
        .global EID
EID:    .string "CCM3887" // replace ZZZ123 with your EID here
        .align 2

// this allow your Lab2 programs to the Lab2 grader
        .global Lab2Grader
// this allow the Lab2 grader to call your Lab2 program
        .global Lab2
// these two allow your Lab2 programs to all your Lab3 solutions
        .global Debug_Init
        .global Dump

// Switch input: PB2 PB1 or PB0, depending on EID
// LED output:   PB18 PB17 or PB16, depending on EID
// logic analyzer pins PB18 PB17 PB16 PB2 PB1 PB0
// analog scope pin PB20
Lab2:
//   Initially the main program will
//   set bus clock at 80 MHz,
//   reset and power enable both Port A and Port B
//   Lab2Grader will
//   configure interrupts  on TIMERG0 for grader or TIMERG7 for TExaS
//   initialize ADC0 PB20 for scope,
//   initialize UART0 for grader or TExaS
     MOVS R0,#10  // 0 for info, 1 debug with logic analyzer, 2 debug with scope, 10 for grade
     BL   Lab2Grader
     BL   Debug_Init // your Lab3
     BL   Lab2Init // initialize input and output pins
// other initializations
loop:

	 MOVS R0,#1
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   // ON
     STR R0,[R1]                    //
/////////////////////////////////////

     LDR  R0,=150000
     BL Timedelay

     MOVS R0,#0
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   //  OFF
     STR R0,[R1]                    //
/////////////////////////////////////
     LDR  R0,=150000
     BL Timedelay

	 LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BNE PRESSED1
     B loop
PRESSED1:
     LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BEQ fifteen
	 B PRESSED1

fifteen:

	 MOVS R0,#1
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   // ON
     STR R0,[R1]                    //
/////////////////////////////////////

     LDR  R0,=45000
     BL Timedelay

     MOVS R0,#0
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   //  OFF
     STR R0,[R1]                    //
/////////////////////////////////////
     LDR  R0,=255000
     BL Timedelay

	 LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BNE PRESSED2
     B fifteen
PRESSED2:
     LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BEQ thirtyfive
	 B PRESSED2

thirtyfive:
	 MOVS R0,#1
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   // ON
     STR R0,[R1]                    //
/////////////////////////////////////

     LDR  R0,=105000
     BL Timedelay

     MOVS R0,#0
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   //  OFF
     STR R0,[R1]                    //
/////////////////////////////////////
     LDR  R0,=195000
     BL Timedelay

	 LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BNE PRESSED3
     B thirtyfive
PRESSED3:
     LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BEQ fortyfive
	 B PRESSED3

hack:
	BEQ loop

fortyfive:
	 MOVS R0,#1
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   // ON
     STR R0,[R1]                    //
/////////////////////////////////////

     LDR  R0,=135000
     BL Timedelay

     MOVS R0,#0
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   //  OFF
     STR R0,[R1]                    //
/////////////////////////////////////
     LDR  R0,=165000
     BL Timedelay

	 LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BNE PRESSED4
     B fortyfive
PRESSED4:
     LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BEQ seventyfive
	 B PRESSED4

seventyfive:
	 MOVS R0,#1
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   // ON
     STR R0,[R1]                    //
/////////////////////////////////////

     LDR  R0,=225000
     BL Timedelay

     MOVS R0,#0
     LSLS R0,R0,#18
//////////////////////////////////////////
     LDR R1,=GPIOB_DOUT31_0            //
     LDR R2,[R1]                      //
     ORRS R2,R2,R0                   //  OFF
     STR R0,[R1]                    //
/////////////////////////////////////
     LDR  R0,=75000
     BL Timedelay

	 LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BNE PRESSED5
     B seventyfive
PRESSED5:
     LDR R5,=GPIOB_DIN31_0
	 MOVS R4, #1
	 LDR R6,[R5]
	 ANDS R6,R6,R4
	 ADDS R6,R6, #0
     BEQ hack
	 B PRESSED5
// input: R0 amount of time
// output: none
// wait for R0 amount of time
// 16000000 Hz/3/N = 50Hz
// 5333333 Hz/N = 50Hz, so N is about 100000
Timedelay:
   CMP  R0,#0     // done???
   BEQ  end       // if done, return
   SUBS R0,#1     // not done, subtract
   B    Timedelay // do it again
end:
   BX   LR

// make switch the input, LED the output
// PortB is already reset and powered
// Set IOMUX for your input and output
// Set GPIOB_DOE31_0 for your output (be friendly)

Lab2Init:
   LDR R1,=0x00000081
   LDR R0,=IOMUXPB18      // PB18 PINCM register
   STR R1,[R0]            // PB18 is output

   LDR R1,=0x00040081
   LDR R0,=IOMUXPB0       // PB0 PINCM register
   STR R1,[R0]            // PB0 is input
   
   LDR R0,=GPIOB_DOE31_0
   LDR R1,[R0]   // previous
   MOVS R2,#1    // Bit 0 means PA0
   LSLS R2,R2,#18
   ORRS R1,R1,R2 // friendly
   STR R1,[R0]   // enable out
   BX   LR
  DONE:
   .end














































