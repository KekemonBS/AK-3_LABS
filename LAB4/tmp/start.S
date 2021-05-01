.syntax unified
.cpu cortex-m4
.thumb

.global vtable
.global __hard_reset__
.extern printf

.type vtable, %object
.type __hard_reset__, %function

.section .interrupt_vector
vtable:
	.word __stack_start
	.word __hard_reset__+1
	.size vtable, .-vtable

.section .rodata
	data: .asciz "lab4_P1 started!\n"
	endofprogram: .asciz "Done."
	
	X1: .quad 0x0000000080000000
	X2: .quad 0x0000000080000000
	X3: .quad 0x0000000080000000 //для ДК змінить знаки, додать 1
	X4: .quad 0x0000000080000000 //<-- (-24) ДК (доповняльний код)
	RS: .quad 0x0000000000000000
	
.section .text

__hard_reset__:
	bl part1
	ldr r0, =endofprogram
 	bl dbgput_line
	end: 
		b end
	;.size __hard_reset__, .-__hard_reset__

	
part1:
	push {lr}
	ldr r0, =data
	bl dbgput_line

	ldr r0, =X1
	ldm r0, {r2, r3} //r2 - молодші, r3 - старші
	
	ldr r0, =X2
	ldm r0, {r4, r5} //аналогічно
	
	ldr r0, =X3
	ldm r0, {r6, r7}
	
	ldr r0, =X4
	ldm r0, {r8, r9} 
	
	
	
	adds r2, r4 // X1+X2
	adc r3,	r5
	
	adds r2, r6 //(X1+X2)+X3
	adc r3, r7
	
	lsls r2, #1  // 2*(X1+X2+X3)
	lsl r3, #1
	IT CS
	addcs r3, #1 //if carry than add 1 to shifted reg
	
	
	
	adds r8, #1 // X4+1
	adc r9,	#0
	
	asrs r9, #1
	lsr r8, #1  // (X4+1)/2
	ldr r0, =0x80000000
	IT CS
	orrcs r8, r0 //if carry than shift in 1 from other side
	
	asrs r9, #1
	lsr r8, #1  // (X4+1)/4
	ldr r0, =0x80000000
	IT CS
	orrcs r8, r0 
	
	
		
	subs r2, r8 // P1-P2 = 2*(X1+X2+X3) - (X4+1)/4
	sbc r3,	r9
	
	ITT VS
	nopvs
	blvs check
	
	ITT VC
	nopvc
	blvc branch
	
	pop {pc}


check:
	asrs r3, #1
	lsr r2, #1
	ldr r0, =0x80000000
	IT CS
	orrcs r2, r0
	
	orr r3, r0

branch:
	cmp r2, #0
	
	ITT EQ
	nopeq
	beq sethigher
	
	ITT NE
	nopne
	bne addtohigher
	
sethigher:
	ldr r0, =0xFD500000 //8106 in hex shifted
	mov r2, r0 			

addtohigher:
	ldr r0, =8106
	add r3, r0

part5:
part6:
	asrs r3, #1
	lsr r2, #1
	ldr r0, =0x80000000
	IT CS
	orrcs r2, r0
	
save:
	//ITT VS
	ldr r0, =RS
	stm r0, {r2, r3}
	str r2, [r0]
	
			
	bx lr
	
//---------------Підпрограма 1------------------
part21:
	push {lr}	
	ldr r0, =0x2A
	lsl r0, #2

strange_return1:	
	add r0, #1
	
	IT CS
	bcs branch1
	
	IT CC
	bcc branch2

branch1:
	add r0, #1
	b block2
	

branch2:
	add r0, #2
	lsl r0, #1
	b block2
	
block2:
	
	IT VS
	bvc strange_return1
	
	bl part22_tochka //Перейти якщо треба тільки навіщо ?
	add r0, #1
	pop {pc}
//---------------------------------------------	

//---------------Підпрограма 2------------------
part22:
	push {lr}	
	add r0, #1
	
	IT VC 
	bvc branch13
	
	IT VS 
	bvs branch22

branch12:
	add r0, #1
	IT VC 
	bvc part22
	
branch22:	
	mov r0, r2
	add r0, #1
	pop {pc}
	
//---------------------------------------------

//---------------Підпрограма 3------------------
part23:
	push {lr}	
	add r0, #1
	add r0, #1
	pop {pc}
	
//---------------------------------------------	
	
	
	
	
