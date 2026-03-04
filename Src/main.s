
// RCC has the configuration for the bus, we need to enable clock access to GPIOC

.equ RCC_BASE, 				0x40023800
.equ AHB1ENR_OFFSET,			0x30

.equ RCC_AHB1ENR,			(RCC_BASE + AHB1ENR_OFFSET)
.equ GPIOC_BASE, 			0x40020800

.equ MODER_OFFSET, 			0x00
.equ GPIOC_MODER,			(GPIOC_BASE + MODER_OFFSET)


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

		/* 	LED user 	--> PC13
			Push botton --> PA0 (connected push button in pull up configuration)
		*/
__main:
				bl 	gpio_init

loop:
				bl get_input
				cmp r0, #BTN_PRESSED
				beq turn_led_on
				cmp r0, #BTN_NO_PRESSED
				beq turn_led_off
				b 	loop


turn_led_on:

				mov r1, #0
				ldr r2, =GPIOC_BSRR
				mov r1, #BSRR_13_RESET
				str r1, [r2]
				b 	loop

turn_led_off:
				mov r1, #0
				ldr r2, =GPIOC_BSRR
				mov r1, #BSRR_13_SET
				str r1, [r2]
				b loop


get_input:
				ldr r1, =GPIOA_IDR
				ldr r0, [r1]
				and r0, r0, #BTN_PIN
				bx lr

gpio_init:
						//PC13 configuration

				/* Enable clock access to GPIO_C */

				ldr r0, =RCC_AHB1ENR		//Load address of RCC_AHB1ENR into r0
				ldr r1, [r0]				// Load value at address found in r0 int r1
				orr r1, #GPIOC_EN
				str r1, [r0]				// store content in r1 at address found in r0

				/* set PC13 as output */
				ldr r0, = GPIOC_MODER
				ldr r1,[r0]
				orr r1, MODER13_OUTPUT
				str r1, [r0]

				/* Enable clock access to GPIO_A */
				ldr r0, =RCC_AHB1ENR		//Load address of RCC_AHB1ENR into r0
				ldr r1, [r0]				// Load value at address found in r0 int r1
				orr r1, #GPIOA_EN
				str r1, [r0]				// store content in r1 at address found in r0


				ldr r0, =GPIOA_MODER
				ldr r1, [r0]
				bic r1, r1, #(3 << 0)
				str r1, [r0]
				bx lr

stop:
				b	stop


				.align
				.end
