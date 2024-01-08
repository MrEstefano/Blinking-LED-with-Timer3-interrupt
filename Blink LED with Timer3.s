;******************** (C) COPYRIGHT 2011 STMicroelectronics ********************
;*
;* File Name          : Blink LED with Timer3 
;* Author             : Stefan Zakutansky
;* Version            : V1.0
;* Date               : 06/12/2023
;* Description        : The code utilizes Timer to toggle LED
;* 
;*******************************************************************************

; Amount of memory (in bytes) allocated for Stack
; Tailor this value to your application needs
; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000400

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000200

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit

                PRESERVE8
                THUMB

;Reset & Clock Control
RCC_Base	EQU	0x40021000		; Reset and Clock ontrol register base address
RCC_APB2ENR	EQU	0x18			; APB2 peripheral clock enable register
IOPCEN		EQU	0x1<<4			; I/O port C clock enable bit possition
RCC_APB1ENR	EQU	0x1C			; APB1 peripheral clock enable register offset address
TIM3EN		EQU	0x1<<1			; TIM3 enable bit possition
;General Purpose Input Output
GPIOC_Base	EQU	0x40011000		; GPIO Port C base address
GPIOC_CRH	EQU	0x04			; Port configuration register high offset address
CNF9_1		EQU 0x1<<7 			; Port C PIN 9 configuration bits position
CNF9_0		EQU 0x1<<6
MODE9_1		EQU 0x1<<5			; Port C PIN 9 speed configuration bits position
MODE9_0		EQU 0x1<<4
CNF8_1		EQU 0x1<<3			; Port C PIN 8 configuration bits position
CNF8_0		EQU	0x1<<2
MODE8_1		EQU 0x1<<1			; Port C PIN 8 speed configuration bits position
MODE8_0		EQU 0x1<<0
GPIOC_ODR	EQU	0x0C			; Port output data register offset address
;TIM3 Interrupt
TIM3_Base	EQU	0x40000400		; TIM3 base address
TIM3_CR1	EQU	0x00			; TIMx control register 1 offset address
CEN			EQU 0x1<<0			; Counter enable bit possition
TIM3_DIER	EQU 0x0C			; TIMx DMA/Interrupt enable register offset address
UIE			EQU 0x1<<0			; Update interrupt enable bit possition
TIM3_SR		EQU	0x10			; TIM3 status register offset address
UIF			EQU 0x1<<0			; Update interrupt flag bit possition
TIM3_PSC	EQU	0x28			; TIM3 prescaler offset address
TIM3_ARR	EQU	0x2C			; TIMx auto-reload register offset address
;Nested vectored interrupt controller
NVIC_Base	EQU	0xE000E100		; Nested vectored interrupt controller base address
NVIC_ISER0	EQU	0x00			; Interrupt set enable register for TIM3
SETENA29	EQU	0x1<<29

; Vector Table Mapped to Address 0 at Reset
                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors       DCD     __initial_sp                    ; Top of Stack
                DCD     Reset_Handler                   ; Reset Handler
                DCD     NMI_Handler                     ; NMI Handler
                DCD     HardFault_Handler               ; Hard Fault Handler
                DCD     MemManage_Handler               ; MPU Fault Handler
                DCD     BusFault_Handler                ; Bus Fault Handler
                DCD     UsageFault_Handler              ; Usage Fault Handler
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     SVC_Handler                     ; SVCall Handler
                DCD     DebugMon_Handler                ; Debug Monitor Handler
                DCD     0                               ; Reserved
                DCD     PendSV_Handler                  ; PendSV Handler
                DCD     SysTick_Handler                 ; SysTick Handler

                ; External Interrupts
                DCD     WWDG_IRQHandler                 ; Window Watchdog
                DCD     PVD_IRQHandler                  ; PVD through EXTI Line detect
                DCD     TAMPER_IRQHandler               ; Tamper
                DCD     RTC_IRQHandler                  ; RTC
                DCD     FLASH_IRQHandler                ; Flash
                DCD     RCC_IRQHandler                  ; RCC
                DCD     EXTI0_IRQHandler                ; EXTI Line 0
                DCD     EXTI1_IRQHandler                ; EXTI Line 1
                DCD     EXTI2_IRQHandler                ; EXTI Line 2
                DCD     EXTI3_IRQHandler                ; EXTI Line 3
                DCD     EXTI4_IRQHandler                ; EXTI Line 4
                DCD     DMA1_Channel1_IRQHandler        ; DMA1 Channel 1
                DCD     DMA1_Channel2_IRQHandler        ; DMA1 Channel 2
                DCD     DMA1_Channel3_IRQHandler        ; DMA1 Channel 3
                DCD     DMA1_Channel4_IRQHandler        ; DMA1 Channel 4
                DCD     DMA1_Channel5_IRQHandler        ; DMA1 Channel 5
                DCD     DMA1_Channel6_IRQHandler        ; DMA1 Channel 6
                DCD     DMA1_Channel7_IRQHandler        ; DMA1 Channel 7
                DCD     ADC1_IRQHandler                 ; ADC1
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     EXTI9_5_IRQHandler              ; EXTI Line 9..5
                DCD     TIM1_BRK_TIM15_IRQHandler       ; TIM1 Break and TIM15
                DCD     TIM1_UP_TIM16_IRQHandler        ; TIM1 Update and TIM16
                DCD     TIM1_TRG_COM_TIM17_IRQHandler   ; TIM1 Trigger and Commutation and TIM17
                DCD     TIM1_CC_IRQHandler              ; TIM1 Capture Compare
                DCD     TIM2_IRQHandler                 ; TIM2
                DCD     TIM3_IRQHandler                 ; TIM3
                DCD     TIM4_IRQHandler                 ; TIM4
                DCD     I2C1_EV_IRQHandler              ; I2C1 Event
                DCD     I2C1_ER_IRQHandler              ; I2C1 Error
                DCD     I2C2_EV_IRQHandler              ; I2C2 Event
                DCD     I2C2_ER_IRQHandler              ; I2C2 Error
                DCD     SPI1_IRQHandler                 ; SPI1
                DCD     SPI2_IRQHandler                 ; SPI2
                DCD     USART1_IRQHandler               ; USART1
                DCD     USART2_IRQHandler               ; USART2
                DCD     USART3_IRQHandler               ; USART3
                DCD     EXTI15_10_IRQHandler            ; EXTI Line 15..10
                DCD     RTCAlarm_IRQHandler             ; RTC Alarm through EXTI Line
                DCD     CEC_IRQHandler                  ; HDMI-CEC
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved 
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved 
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     TIM6_DAC_IRQHandler             ; TIM6 and DAC underrun
                DCD     TIM7_IRQHandler                 ; TIM7
__Vectors_End

__Vectors_Size  EQU  __Vectors_End - __Vectors

                AREA    |.text|, CODE, READONLY

; Reset handler
Reset_Handler    PROC
                 EXPORT  Reset_Handler             [WEAK]	
		
;Reset & Clock Control
		LDR r0, =RCC_Base				; Load Reset and Clock2 ontrol register base address to r0
		LDR r1, [r0, #RCC_APB2ENR]		; load to r1 the APB2 peripheral clock enable register offset addres plus with whats in r0 register
		ORR r1, r1, #IOPCEN				; Set I/O port C clock enable bit
		STR r1, [r0, #RCC_APB2ENR]		; Store changes done in r1 to base address plus with offset
		LDR r1, [r0, #RCC_APB1ENR]		; Load Reset and Clock1 ontrol register base address to r0
		ORR r1, r1, #TIM3EN				; Set TIM3 enable bit
		STR r1, [r0, #RCC_APB1ENR]		; Store changes done in r1 to base address Plus with offset
;General Purpose Input Output
		LDR r0, =GPIOC_Base				; Load GPIO Port C base address to r0
;LED
		LDR r1, [r0, #GPIOC_CRH]		; Load to r1 the Load GPIO Port C base address plus with Port configuration register high offset address

		BIC r1, r1, #MODE8_0			; PC8 output mode max speed 2MHz
		ORR r1, r1, #MODE8_1
		BIC r1, r1, #MODE9_0			; PC9 output mode max speed 2MHz 
		ORR r1, r1, #MODE9_1	

		BIC r1, r1, #CNF8_0				; PC8 general purpose output push-pull
		BIC r1, r1, #CNF8_1	
		BIC r1, r1, #CNF9_0				; PC9 general purpose output push-pull
		BIC r1, r1, #CNF9_1		
		STR r1, [r0, #GPIOC_CRH]        ; Store changes done in r1 to base address Plus with offset
;NVIC
		LDR r0, =NVIC_Base				; Load Nested vectored interrupt controller base address to r0
		LDR r1, [r0, #NVIC_ISER0]		; Load to r1 Interrupt set enable register for TIM3 plus with base address
		ORR r1, r1, #SETENA29			; set bit 29 to allow TIM3 global interrupt
		STR r1, [r0, #NVIC_ISER0]		; Store changes done in r1 to base addres plus with offset
;TIM3
		LDR r0, =TIM3_Base				; Load Timer 3 base address to r0
		LDR r1, [r0, #TIM3_CR1]			; Load to r1 TIMx control register 1 offset address pluse with base address
		ORR r1, r1, #CEN				; Set the bit to enable counter
		STR r1, [r0, #TIM3_CR1]			; store changes done in r1 to base addres pluse with offset
		LDR r1, [r0, #TIM3_DIER]		; Load TIMx DMA/Interrupt enable register offset address plus with Timer 3 base address
		ORR r1, r1, #UIE				; Set the bit to enable update interrupt flag
		STR r1, [r0, #TIM3_DIER]		; Store the change in r1 to base address plus with offset 
		LDR r1, =0x00009C3F 			; Load the value prescaler = 39999
		STR r1, [r0, #TIM3_PSC]			; Store the value . See ...8000000/(39999+1)=200Hz  ;  8 000 000 /39999+1 = 200 Hz equals to 0.005s or 5ms
		MOV r1, #0x12C 					; Auto reload value= 300
		STR r1, [r0, #TIM3_ARR]			; Auto Reload Register value multiplied by 5ms makes 1.5s
		
LOOP
		B LOOP							; endless loop
                 ENDP

; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler                      [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler                [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler                [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler                 [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler               [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler                      [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler                 [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler                   [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler                  [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WWDG_IRQHandler                  [WEAK]
                EXPORT  PVD_IRQHandler                   [WEAK]
                EXPORT  TAMPER_IRQHandler                [WEAK]
                EXPORT  RTC_IRQHandler                   [WEAK]
                EXPORT  FLASH_IRQHandler                 [WEAK]
                EXPORT  RCC_IRQHandler                   [WEAK]
                EXPORT  EXTI0_IRQHandler                 [WEAK]
                EXPORT  EXTI1_IRQHandler                 [WEAK]
                EXPORT  EXTI2_IRQHandler                 [WEAK]
                EXPORT  EXTI3_IRQHandler                 [WEAK]
                EXPORT  EXTI4_IRQHandler                 [WEAK]
                EXPORT  DMA1_Channel1_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel2_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel3_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel4_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel5_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel6_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel7_IRQHandler         [WEAK]
                EXPORT  ADC1_IRQHandler                  [WEAK]
                EXPORT  EXTI9_5_IRQHandler               [WEAK]
                EXPORT  TIM1_BRK_TIM15_IRQHandler        [WEAK]
                EXPORT  TIM1_UP_TIM16_IRQHandler         [WEAK]
                EXPORT  TIM1_TRG_COM_TIM17_IRQHandler    [WEAK]
                EXPORT  TIM1_CC_IRQHandler               [WEAK]
                EXPORT  TIM2_IRQHandler                  [WEAK]
                EXPORT  TIM3_IRQHandler                  [WEAK]
                EXPORT  TIM4_IRQHandler                  [WEAK]
                EXPORT  I2C1_EV_IRQHandler               [WEAK]
                EXPORT  I2C1_ER_IRQHandler               [WEAK]
                EXPORT  I2C2_EV_IRQHandler               [WEAK]
                EXPORT  I2C2_ER_IRQHandler               [WEAK]
                EXPORT  SPI1_IRQHandler                  [WEAK]
                EXPORT  SPI2_IRQHandler                  [WEAK]
                EXPORT  USART1_IRQHandler                [WEAK]
                EXPORT  USART2_IRQHandler                [WEAK]
                EXPORT  USART3_IRQHandler                [WEAK]
                EXPORT  EXTI15_10_IRQHandler             [WEAK]
                EXPORT  RTCAlarm_IRQHandler              [WEAK]
                EXPORT  CEC_IRQHandler                   [WEAK]
                EXPORT  TIM6_DAC_IRQHandler              [WEAK]
                EXPORT  TIM7_IRQHandler                  [WEAK]

WWDG_IRQHandler
PVD_IRQHandler
TAMPER_IRQHandler
RTC_IRQHandler
FLASH_IRQHandler
RCC_IRQHandler
EXTI0_IRQHandler
EXTI1_IRQHandler
EXTI2_IRQHandler
EXTI3_IRQHandler
EXTI4_IRQHandler
DMA1_Channel1_IRQHandler
DMA1_Channel2_IRQHandler
DMA1_Channel3_IRQHandler
DMA1_Channel4_IRQHandler
DMA1_Channel5_IRQHandler
DMA1_Channel6_IRQHandler
DMA1_Channel7_IRQHandler
ADC1_IRQHandler
EXTI9_5_IRQHandler
TIM1_BRK_TIM15_IRQHandler
TIM1_UP_TIM16_IRQHandler
TIM1_TRG_COM_TIM17_IRQHandler
TIM1_CC_IRQHandler
TIM2_IRQHandler
TIM3_IRQHandler		
		LDR r0, =TIM3_Base          ; Load Timer 3 base address 
		LDR r1, [r0, #TIM3_SR]		; Load to r1 the TIM3 status register offset address plus with base address
		AND r1, r1, #UIF			; Mask Update Interrupt Flag
		CMP r1,#0x001 				; Check that Update Interrupt Flag is set
		BNE TIM3_IRQHandler			; Branch if the flag not set, Continue in code when time has passed and the flag is set
		BIC r1, r1, #UIF			; Clear the Update Interrupt Flag
		STR r1, [r0, #TIM3_SR]		; Store the changes done in r1 to TIM3 status register offset address plus with base address
		LDR r0, =GPIOC_Base			; Load GPIO Port C base address to r0
		LDR r1, [r0, #GPIOC_ODR]	; Load Port output data register offset address plus base address to r1
		MVN r1, r1					; Toggle the LED - move the previous status of registar negated 
		AND r1, r1,#0x00200			; Mask bit 9 to ignore all ther output pins
		STR r1, [r0, #GPIOC_ODR]	; Store changes done in r1 to base address pluse with offset					
		BX  LR						; Return from interrupt 
TIM4_IRQHandler
I2C1_EV_IRQHandler
I2C1_ER_IRQHandler
I2C2_EV_IRQHandler
I2C2_ER_IRQHandler
SPI1_IRQHandler
SPI2_IRQHandler
USART1_IRQHandler
USART2_IRQHandler
USART3_IRQHandler
EXTI15_10_IRQHandler
RTCAlarm_IRQHandler
CEC_IRQHandler
TIM6_DAC_IRQHandler
TIM7_IRQHandler
                B       .

                ENDP

                ALIGN

;*******************************************************************************
; User Stack and Heap initialization
;*******************************************************************************
                 IF      :DEF:__MICROLIB           
                
                 EXPORT  __initial_sp
                 EXPORT  __heap_base
                 EXPORT  __heap_limit
                
                 ELSE
                
                 IMPORT  __use_two_region_memory
                 EXPORT  __user_initial_stackheap
                 
__user_initial_stackheap

                 LDR     R0, =  Heap_Mem
                 LDR     R1, =(Stack_Mem + Stack_Size)
                 LDR     R2, = (Heap_Mem +  Heap_Size)
                 LDR     R3, = Stack_Mem
                 BX      LR

                 ALIGN

                 ENDIF

                 END

;******************* (C) COPYRIGHT 2011 STMicroelectronics *****END OF FILE*****
