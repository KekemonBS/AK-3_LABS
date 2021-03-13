.global lab1
.syntax unified
#define A #1
#define B #1
#define C #1

lab1:
	push {lr} // (a-b)*3+(2^c) = 2
	mov r0, A
	mov r1, B
	mov r2, C
	bl test_var
	pop {pc}
	
test_var:
	push { r0, r1, r2, lr }

	sub r0, r1 //a-b
	mov r3, #3
	mul r0, r3 //*3
	
	mov r3, #2
	sub r3, #1
	lsl r2, r3, r2 //2^c
	
	add r0, r2// +

	pop { r0, r1, r2, r3, pc }
