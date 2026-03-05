
// RCC has the configuration for the bus, we need to enable clock access to GPIOC

.equ RCC_BASE, 				0x40023800
.equ AHB1ENR_OFFSET,			0x30

.equ RCC_AHB1ENR,			(RCC_BASE + AHB1ENR_OFFSET)
.equ GPIOC_BASE, 			0x40020800

.equ APB2ENR_OFFSET,		0x44
.equ RCC_APB2ENR,			(RCC_BASE + APB2ENR_OFFSET)

.equ MODER_OFFSET, 			0x00
.equ GPIOC_MODER,			(GPIOC_BASE + MODER_OFFSET)

.equ ADC1_EN,				(1<<8)
.equ GPIOC_ODR_OFFSET,		0x14
.equ GPIOC_ODR, 			(GPIOC_BASE + GPIOC_ODR_OFFSET)

.equ GPIOC_EN,				(1<<2)
.equ MODER13_OUTPUT,		(1<<26)
.equ LED_ON,				(0U<<13)
.equ LED_OFF,				(1U<<13)
.equ ONE_SECOND,			5333333

.equ GPIOC_BSRR_OFFSET,		0x18
.equ GPIOC_BSRR,			( GPIOC_BASE + GPIOC_BSRR_OFFSET )

.equ BSRR_13_SET,			(1U<<13)
.equ BSRR_13_RESET,			(1U<<29)


.equ GPIOA_EN,				(1<<0)
.equ GPIOA_BASE, 			0x40020000
.equ GPIOA_MODER,			(GPIOA_BASE + MODER_OFFSET)

.equ IDR_OFFSET, 			0x10
.equ GPIOA_IDR,				(GPIOA_BASE + IDR_OFFSET)


.equ MODER1_ANLG_SLT		0xC
// Active low switch
.equ BTN_PRESSED,			0x0000
.equ BTN_NO_PRESSED,		0x0001
.equ BTN_PIN,				0x0001


				.syntax unified
				.cpu	cortex-m4
				.fpu	softvfp
				.thumb

				.section 	 .text
				.global __main


__main:
						/* */
					/* 1.- Enable clock access to ADC pin's GPIO port*/

				ldr r0, =RCC_AHB1ENR		//Load address of RCC_AHB1ENR into r0
				ldr r1, [r0]				// Load value at address found in r0 int r1
				orr r1, #GPIOA_EN
				str r1, [r0]				// store content in r1 at address found in r0

				/* 2.- Set ADC pin PA1 as analog pin  --> PA1 --> ADC1*/
				ldr r0, = GPIOA_MODER
				ldr r1, [r0]
				orr r1, #MODER1_ANLG_SLT
				str r1, [r0]

				* 3.- Enable clock access to the ADC */
				ldr r0, =RCC_APB2ENR
				ldr r1, [r0]
				orr r1, #ADC1_EN
				st r1, [r0]

