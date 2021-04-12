.syntax unified
.cpu cortex-m4
.thumb

#define A #1
#define B #1
#define C #1

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
	.word __stack_start
	.word __kernel_reset__+1
	.size vtable_kernel, .-vtable_kernel

.section .rodata
	data: .asciz "kernel started!\n"
	final: .asciz "Value in register #5: "
.section .text
__kernel_reset__:
	ldr r0, =data
	bl dbgput_line

	mov r0, A
	mov r1, B
	mov r2, C

 	//Calculate
	sub r0, r1 //a-b

	mov r3, #3
	mul r5, r0, r3 //*3
	
	mov r3, #2
	sub r3, #1
	lsl r2, r3, r2 //2^c
	
	add r5, r2// +
	
	
	ldr r0, =final
	bl dbgput
	
	mov r0, r5
	bl dbgput_num
	
	
end:
	b end
