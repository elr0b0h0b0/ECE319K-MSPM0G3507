//****************** ECE319K_Lab1.s ***************
// My solution to Lab 1 in assembly code
// Author: Colby McLane
// Last Modified: 1/26/2024
// Spring 2024
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
        .global Phase
Phase:  .long 10           // 0 for info, 1-6 for debug, 10 for grade

        .global Lab1
// Input: R0 points to the list
// Return: R0 as specified in Lab 1 assignment and terminal window
// According to AAPCS, you must save/restore R4-R7
// If your function calls another function, you must save/restore LR

Lab1: PUSH {R4-R7,LR}
       // your solution goes here
AGAIN:
	   // is R0 pointing to NULL?
	   LDR R1, [R0]               // R0 is pointer to the struct entry of the EID we're looking at. R1 is pointer to string in question.
	   CMP R1, #0                 // Does the struct entry contain an actual pointer?
	   BEQ NULL                   // If it does not, jump to NULL
	   // is the EID me?
       LDR R2, =EID               // R2 is pointer to my EID string
       MOVS R6, R0                // Save pointer to struct entry into R6.
       BL StrCmp                  // Jump to string compare.
       CMP R5, #1                 // check if we have a match!
       BEQ MATCH_FOUND            // Jump if we do have a match!
       MOVS R0, R6                // Restore struct entry pointer into R0
       ADDS R0, #8                // Advance to next struct entry
       B AGAIN                    // Repeat
	   // go to next element
NULL:
	   LDR R0, =-1                // Write -1 to R0
       POP  {R4-R7,PC}            // return
MATCH_FOUND:
	   ADDS R6, #4                // advance pointer to score location
	   MOVS R0, R6                // place this pointer into R0
       LDR R0, [R0]               // dereference the pointer
	   POP  {R4-R7,PC} // return
       // string compare subroutine
StrCmp:
       LDRB R3, [R1]     // load character of str0
       LDRB R4, [R2]     // load character of my eid
       CMP R3, R4        // compare the characters
       BNE no            // if not equal, str0 != eid
       CMP R3, #0        // if str0 reached null
       BEQ yes           // both reached null, str0 = str1, done
       ADDS R1, #1       // increment both pointers to the next character
       ADDS R2, #1
       B StrCmp
no:
       MOVS R5, #0       // no match R5 = 0
       B done
yes:
       MOVS R5, #1       // match R5 = 1
       B done
done:
       BX LR             // exit subroutine
       .end
