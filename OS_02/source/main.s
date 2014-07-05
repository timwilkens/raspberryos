.section .init
.global _start
_start:

/*
* Store the value '0x20200000' in register r0.
* ldr short for 'load register'.
* 20200000 is the hex address of the GPIO controller.
* r0 is the first of 13 'General Purpose' registers.
*/
ldr r0,=0x20200000

/*
* Put 1 into register r1.
* Mov is faster than ldr because it does not interact with memory.
* This is achieved by limiting 'mov' to certain values.
*/
mov r1,#1

/*
* Logical left shift of the value in r1 by 18.
* 1 => 1000000000000000000
*/
lsl r1,#18

/*
* Store the value in r1 at the address of r0 + 4.
*/
str r1,[r0,#4]

/*
* Load up our value to set the 16th pin of the GPIO.
*/
mov r1,#1
lsl r1,#16

loop$:

/*
* Write to the GPIO controller address to turn a pin off.
* This turns the light ON.
*/
str r1,[r0,#40]

/*
* Set an arbitrary large value to subtract from to get delay.
* Adjust this value to get a longer or shorter delay.
*/
mov r2,#0x3F0000

/*
* Subtract 1 until we get to zero.
*/
wait1$:
/*
* Subtract 1 from value in r2.
*/
sub r2,#1

/*
* Compare first argument to second and remember result in special register.
*/
cmp r2,#0

/*
* Only branch back to wait1$ if the result of the last comparison was not equal.
*/
bne wait1$

/*
* Turn the light OFF.
*/
str r1,[r0,#28]

/*
* Set an arbitrary large value to subtract from to get delay.
* Adjust this value to get a longer or shorter delay.
*/
mov r2,#0x3F0000

/*
* Subtract 1 until we get to zero.
*/
wait2$:
sub r2,#1
cmp r2,#0
bne wait2$

/*
* Loop forever.
*/

b loop$

