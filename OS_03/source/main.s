.section .init
.global _start
_start:

b main

.section .text
main: 

mov sp,#0x8000 /* Set the stack pointer */


pinNum .req r0
pinFunc .req r1
mov pinNum,#16       /* Activate pin 16           */
mov pinFunc,#1       /* Set function              */
bl SetGpioFunction   /* Enable output to this pin */
.unreq pinNum
.unreq pinFunc

loop$:

pinNum .req r0
pinVal .req r1
mov pinNum,#16
mov pinVal,#0
bl SetGpio
.unreq pinNum
.unreq pinVal

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

pinNum .req r0
pinVal .req r1
mov pinNum,#16
mov pinVal,#1
bl SetGpio
.unreq pinNum
.unreq pinVal

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

