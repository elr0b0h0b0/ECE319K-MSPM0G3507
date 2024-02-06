/* ECE319K_Lab2main.c
 * Jonathan Valvano
 * December 4, 2023
 * Derived from uart_rw_multibyte_fifo_poll_LP_MSPM0G3507_nortos_ticlang
 */
/*
 Copyright 2023 by Jonathan W. Valvano, valvano@mail.utexas.edu
    You may use, edit, run or distribute this file
    as long as the above copyright notice remains
 THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 VALVANO SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL,
 OR CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 For more information about my classes, my research, and my books, see
 http://users.ece.utexas.edu/~valvano/
 */
#include <ti/devices/msp/msp.h>
#include "../inc/LaunchPad.h"
#include "../inc/Clock.h"
#include "../inc/UART.h"
#include "../inc/Timer.h"

#include <stdio.h>
#include <string.h>

// PA10 is UART0 Tx    index 20 in IOMUX PINCM table
// PA11 is UART0 Rx    index 21 in IOMUX PINCM table
// Insert jumper J25: Connects PA10 to XDS_UART
// Insert jumper J26: Connects PA11 to XDS_UART
// Switch input PB2 PB1 or PB0
// LED output PB18 PB17 or PB16
// logic analyzer pins PB18 PB17 PB16 PB2 PB1 PB0
// analog scope pin PB20, channel 6
uint32_t Score;

uint32_t M;
uint32_t Random32(void){
  M = 1664525*M+1013904223;
  return M;
}
uint32_t Random(uint32_t n){
  return (Random32()>>16)%n;
}
char setUpper(char in){
  if((in >= 'a')&&(in <= 'z')){
    return in-0x20;
  }
  return in;
}

extern const char EID[20]; // student's EID
uint32_t SizeofEID;
uint32_t Phase; // 0 for info, 1 debug with logic analyzer, 2 debug with scope, 10 for grade
int Mode0=0; // randomly assigns 0 to 3
int Mode1=0; // randomly assigns 0 to 3
int Mode2=0; // randomly assigns 0 to 3
const char ChangeProblem[4][80]={
  "\n\rImplement the Change switch using PB0",  // Mode0=0
  "\n\rImplement the Change switch using PB1",  // Mode0=1
  "\n\rImplement the Change switch using PB2",  // Mode0=2
  "\n\rImplement the Change switch using PB3"   // Mode0=3
};
const uint32_t InMux[4]={PB0INDEX,PB1INDEX,PB2INDEX,PB3INDEX};
const uint32_t ChangeMask[4]={1,2,4,8};
const char LEDProblem[3][80]={
  "\n\rImplement the LED on PB16",               // Mode1=0
  "\n\rImplement the LED on PB17",               // Mode1=1
  "\n\rImplement the LED on PB18"                // Mode1=2
};
const uint32_t OutMux[3]={PB16INDEX,PB17INDEX,PB18INDEX};
const uint32_t LEDMask[3]={(1<<16),(1<<17),(1<<18)};

const uint32_t Duties[8][4]={ // checks for 4 different duty cycles
  {20, 40, 70, 80},  // Mode2=0
  {10, 35, 50, 85},  // Mode2=1
  {25, 45, 60, 85},  // Mode2=2
  {15, 35, 55, 75},  // Mode2=3
  {10, 30, 65, 70},  // Mode2=4
  {15, 35, 45, 75},  // Mode2=5
  {10, 30, 40, 70},  // Mode2=6
  {25, 35, 75, 85}}; // Mode2=7
const int32_t Tolerance=3; // +/- 3% percent
void ShowProblem(void){
  UART_OutString((char*)ChangeProblem[Mode0]);
  UART_OutString((char*)LEDProblem[Mode1]);
  UART_OutString("\n\rImplement duty cycles ");
  UART_OutUDec(Duties[Mode2][0]); UART_OutChar(',');
  UART_OutUDec(Duties[Mode2][1]); UART_OutChar(',');
  UART_OutUDec(Duties[Mode2][2]); UART_OutChar(',');
  UART_OutUDec(Duties[Mode2][3]); UART_OutString("%,");
}
uint32_t Inflag[4]; // 0 if found, 1 means looking for duty cycle

uint32_t Time=0;
uint32_t Score=0;
uint32_t ErrorFlag=1; // 0 means stop grading
uint32_t LastLED;
uint32_t FirstCount,SecondCount,Period;
uint32_t Duty;
void EndLab2(void){
  NVIC->ICER[0] = 1 << 16; // TIMG0 disarm interrupt
  UART_OutString(" Score="); UART_OutUDec(Score);
  UART_OutString("\n\rEnd of Lab 2, Spring 2024\n\r");
  while(1){
  }
}
void CheckInit(void){uint32_t inmux,outmux,doe;
  inmux = IOMUX->SECCFG.PINCM[InMux[Mode0]];
  outmux = IOMUX->SECCFG.PINCM[OutMux[Mode1]];
  doe = GPIOB->DOE31_0&(LEDMask[Mode1]);
  if(inmux != 0x00040081){
    UART_OutString("IOMUX for input not 0x00040081.\n\r");
    EndLab2(); // stop printing errors
  }
  if(outmux != 0x00000081){
    UART_OutString("IOMUX for output not 0x00000081.\n\r");
    EndLab2(); // stop printing errors
  }
  if(doe == 0){
    UART_OutString("DOE31 for output not set.\n\r");
    EndLab2(); // stop printing errors
  }
}


void AddPoints(uint32_t in,uint32_t duty){
  Inflag[in] = 0;
  Score += 4;
  if(Score >= 16){
    Score = 25;
  }
//  UART_OutChar(in+0x30);
  UART_OutUDec(duty); //Duties[Mode2][in]);
  UART_OutChar(','); // 3 characters will not fill 4-deep FIFO
//  UART_OutString("% duty cycle, Score="); UART_OutUDec(Score);
  if(Score == 25){
    UART_OutString(" Perfect, "); // messes up timing but ok
    EndLab2();
  }
}

void TIMG0_IRQHandler(void){uint32_t change,led;
  if((TIMG0->CPU_INT.IIDX) == 1){ // this will acknowledge
    Time++;
    if(Time > 20){
      CheckInit(); // will not return if error
      change = GPIOB->DIN31_0&ChangeMask[Mode0];
      led = GPIOB->DOUT31_0&LEDMask[Mode1];
      if(change==0){ // measure period
        if((LastLED == 0)&&(led != 0)){ // rising edge
          Period = Time-FirstCount;
          Duty = (100*(SecondCount-FirstCount))/Period;
          FirstCount = Time;
          // 50Hz = 1/20ms, sampled at 10kHz
          if((Period >= 150)&&(Period <= 250)){
            for(uint32_t i=0; i<4 ;i++){
              if(Inflag[i]){
                if((Duty >= (Duties[Mode2][i]-Tolerance))&&(Duty <= (Duties[Mode2][i]+Tolerance))){
                  AddPoints(i,Duty);
                  i=5;
                 }
               }
             }
           }
        }
        if((LastLED!=0)&&(led == 0)){ // falling edge
          SecondCount = Time;
        }
        LastLED = led;
      }
    }
  }
}

// blind
#define UART_Out(data) (UART0->TXDATA = data)

#define ADC_In(adc12) ((adc12)->ULLMEM.MEMRES[0])
ADC12_Regs *TExaSadc;
uint32_t test=0;

#define ADCVREF_INT  0x200
// choose internal 2.5V reference for accuracy
#define ADCVREF_EXT  0x100
// external reference not tested
#define ADCVREF_VDDA 0x000
//choose power line 3.3V reference for 0 to 3.3V range

// Bus frequency set by main program
// continuous sampling, 8 bit mode
void ADC_Init(ADC12_Regs *adc12, uint32_t channel, uint32_t reference){
    // Reset ADC and VREF
    // RSTCLR
    //   bits 31-24 unlock key 0xB1
    //   bit 1 is Clear reset sticky bit
    //   bit 0 is reset ADC
  TExaSadc = adc12;
  adc12->ULLMEM.GPRCM.RSTCTL = (uint32_t)0xB1000003;
  if(reference == ADCVREF_INT){
    VREF->GPRCM.RSTCTL = (uint32_t)0xB1000003;
  }
    // Enable power ADC and VREF
    // PWREN
    //   bits 31-24 unlock key 0x26
    //   bit 0 is Enable Power
  adc12->ULLMEM.GPRCM.PWREN = (uint32_t)0x26000001;
  if(reference == ADCVREF_INT){
    VREF->GPRCM.PWREN = (uint32_t)0x26000001;
  }
  Clock_Delay(24); // time for ADC and VREF to power up
  adc12->ULLMEM.GPRCM.CLKCFG = 0xA9000000; // SYSOSC
  // bits 31-24 key=0xA9
  // bit 5 CCONSTOP= 0 not continuous clock in stop mode
  // bit 4 CCORUN= 0 not continuous clock in run mode
  // bit 1-0 0=SYSOSC,1=MCLK,2=HFCLK
  if(Clock_Freq() > 32000000){
    adc12->ULLMEM.CLKFREQ = 7; // 7 is 40 MHz
  }else{
    adc12->ULLMEM.CLKFREQ = 5; //5 is 32MHz
  }
  adc12->ULLMEM.CTL0 = 0x03010000;
  // bits 26-24 = 011 divide by 8
  // bit 16 PWRDN=1 for manual, =0 power down on completion, if no pending trigger
  // bit 0 ENC=0 disable (1 to 0 will end conversion), =1 for enable
  adc12->ULLMEM.CTL1 = 0x00020000;
  // bits 30-28 =0  no shift
  // bits 26-24 =0  no averaging
  // bit 20 SAMPMODE=0 high phase
  // bits 17-16 CONSEQ=00 ADC at start will be sampled once, 10 for repeated sampling
  // bit 8 SC=0 for stop, =1 to software start
  // bit 0 TRIGSRC=0 software trigger
  adc12->ULLMEM.CTL2 = 0x00000004;
  // bits 28-24 ENDADD (which  MEMCTL to end)
  // bits 20-16 STARTADD (which  MEMCTL to start)
  // bits 15-11 SAMPCNT (for DMA)
  // bit 10 FIFOEN=0 disable FIFO
  // bit 8  DMAEN=0 disable DMA
  // bits 2-1 RES=00 for 12 bit (=01 for 10bit,=10for 8-bit)
  // bit 0 DF=0 unsigned formant (1 for signed, left aligned)
  adc12->ULLMEM.MEMCTL[0] = reference+channel;
  // bit 28 WINCOMP=0 disable window comparator
  // bit 24 TRIG trigger policy, =0 for auto next, =1 for next requires trigger
  // bit 20 BCSEN=0 disable burn out current
  // bit 16 = AVGEN =0 for no averaging
  // bit 12 = STIME=0 for SCOMP0
  // bits 9-8 VRSEL = 10 for internal VREF,(00 for VDDA)
  // bits 4-0 channel = 0 to 7 available
  adc12->ULLMEM.SCOMP0 = 0; // 8 sample clocks
//  adc12->ULLMEM.GEN_EVENT.ICLR |= 0x0100; // clear flag MEMCTL[0]
  adc12->ULLMEM.GEN_EVENT.IMASK = 0; // no interrupt
  if(reference == ADCVREF_INT){
    VREF->CLKSEL = 0x00000008; // bus clock
    VREF->CLKDIV = 0; // divide by 1
    VREF->CTL0 = 0x0001;
  // bit 8 SHMODE = off
  // bit 7 BUFCONFIG=0 for 2.4 (=1 for 1.4)
  // bit 0 is enable
    VREF->CTL2 = 0;
  // bits 31-16 HCYCLE=0
    // bits 15-0 SHCYCLE=0
    while((VREF->CTL1&0x01)==0){}; // wait for VREF to be ready
  }
}

// start continuous sampling 12-bit ADC
void ADC_Start(ADC12_Regs *adc12){
  adc12->ULLMEM.CTL0 |= 0x00000001; // enable conversions
  adc12->ULLMEM.CTL1 |= 0x00000100; // start ADC
}
// return last sample 12-bit ADC
uint32_t ADC_Data(ADC12_Regs *adc12){
  return adc12->ULLMEM.MEMRES[0];
}
void TIMG7_IRQHandler(void){
  TIMG7->GEN_EVENT0.ICLR = 1; //acknowledge
// UART_Out(test); test =( test+1)&0xFF;
//  GPIOA->DOUTTGL31_0 = 1;
  if(TExaSadc){
   // test = ADC_In(TExaSadc);
   //  UART_Out(test);
     UART_Out(ADC_In(TExaSadc)); // 8-bit data at 10 kHz
  }else{
     // logic analyzer for PB18-16 outputs, PB3-0 input
    UART_Out(0x80|((GPIOB->DOUT31_0&0x70000)>>12)|(GPIOB->DIN31_0&0x0F)); // 7-bit digital data at 10 kHz
  }
}
void Lab2(void);
  int main(void){
  Clock_Init80MHz(0);
  LaunchPad_Init(); // this resets and activated both Port A and Port B
  UART_Init();
  Score = 0;
  Time = 0;
  LastLED = 0;
  SecondCount=FirstCount=0;
  for(int i=0;i<4;i++){
    Inflag[i] = 1; // not found
  }
  if(strcmp(EID,"ZZZ123")==0){
    UART_OutString("Please enter your EID in ECE319K_Lab2.s,");
    EndLab2();
  }
  Lab2();
  while(1);
}

uint32_t Dummy;
void Lab2Grader(uint32_t phase){
  __disable_irq();
  Phase = phase;


  M = 3; // seed changes only with EID
  SizeofEID = 0;
  for(int i=0; EID[i]; i++){
    M = M*setUpper(EID[i]);
    SizeofEID++;
    if(SizeofEID>10){
      UART_OutString("EID too long,");
      EndLab2();
    }
  }
  Mode0 = Random(4);
  Mode1 = Random(3);
  Mode2 = Random(8);
  // hard code for testing
//  Mode0 = 3;
//  Mode1 = 2;
//  Mode2 = 5;
  if(Phase == 0){ // 0 for info
    UART_OutString("\n\rECE319K Lab 2, Spring 2024\n\rStudent EID= ");
    UART_OutString((char *)EID);
    ShowProblem();
    EndLab2();
  }
  if(Phase == 1){//  1 debug with logic analyzer
    TExaSadc = 0;
    TimerG7_IntArm(Clock_Freq()/10000,1,3); // G7 is in Power domain PD2
    __enable_irq();
    return;
  }

  if(Phase == 2){//  2 debug with scope,
    ADC_Init(ADC0,6,ADCVREF_VDDA); // PB20, 0 to 3.3V range
    ADC_Start(ADC0);
  //  ADC0_Init(6,ADCVREF_VDDA); // PB20, 0 to 3.3V range
    TimerG7_IntArm(Clock_Freq()/10000,1,3); // G7 is in Power domain PD2
    __enable_irq();
    return;
  }

  if(Phase == 10){//  10 for grade
    UART_OutString("\n\rECE319K Lab 2, Spring 2024\n\rStudent EID= ");
    UART_OutString((char *)EID);
    UART_OutString("\n\rRunning the grader\n\r");
    TimerG0_IntArm(100,40,2); // 40MHz/40/100 = 10kHz
    __enable_irq();
    return;
  }
}
