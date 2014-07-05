.globl GetGpioAddress
GetGpioAddress:
    ldr r0,=0x20200000 /* Address for our GPIO controller */
    mov pc,lr          /* Return to caller                */

.globl SetGpioFunction
SetGpioFunction:

    /* r0 contains the GPIO pin number */
    /* r1 contains the function code   */

    cmp r0,#53  /* Valid pin numbers 0 - 53              */
    cmpls r1,#7 /* 8 functions per pin 0 - 7             */
                /* Only checked if pin was valid         */
    movhi pc,lr /* If pin or function are invalid return */

    push {lr}          /* Store the return from SetGpioFunction */
    mov r2,r0          /* Move our first argument into r2       */
                       /* GetGpioAddress will overwrite r0      */
    bl GetGpioAddress  /* Store next address in lr and branch   */

    /* r0 contains the GPIO controller address */
    /* r1 contains the function code           */ 
    /* r2 contains the GPIO pin number         */

    /* GPIO functions are stored in blocks of ten pins per 4  */
    /* bytes. Pin 16 is in the second block so we must be 4   */
    /* bytes past the GPIO controller address                 */

    functionLoop$:
        cmp r2,#9         /* See if we are in this block (Base Case) */
        subhi r2,#10      /* Make our pin number relative            */
        addhi r0,#4       /* Shift our GPIO controller address       */
        bhi functionLoop$ /* Loop again as needed                    */

    /* r0 contains the updated GPIO address base on pin location */
    /* r1 contains the function code untouched                   */ 
    /* r2 contains the GPIO pin number now relativized 0 - 9     */

    add r2, r2,lsl #1 /* r1 * 3 in disguise                             */
                      /* Shifting and adding faster than multiplication */
                      /* Multiply by 3 since pins represented by 3 bits */
    lsl r1,r2         /* Shift function code over to pin location       */
    orr r1,r0         /* Don't clobber other pins                       */
    str r1,[r0]       /* Store our function in the GPIO controller addr */
    pop {pc}          /* Return to caller                               */

    /* TODO: this writes over all over GPIO pin values in the block of 10 */
    /* May just need `orr r1,r0` after `lsl r1,r2`                        */
    
.globl SetGpio
SetGpio:
    pinNum .req r0
    pinVal .req r1

    cmp pinNum,#53
    movhi pc,lr    /* Return to caller if not a valid pin number */

    push {lr}
    mov r2,pinNum     /* Move our pin number to r2     */
    .unreq pinNum
    pinNum .req r2    /* Switch our alias              */
    bl GetGpioAddress
    gpioAddr .req r0  /* Set alias for GPIO controller */

    pinBank .req r3
    lsr pinBank,pinNum,#5 /* See if we are in first 32 bits or second       */
    lsl pinBank,#2        /* Multiply by 4 since they are chunks of 4 bytes */
    add gpioAddr,pinBank  /* Move to the controller to the correct bank     */
    .unreq pinBank

    and pinNum,#31    /* No number larger than 5 bits */
    setBit .req r3
    mov setBit,#1
    lsl setBit,pinNum /* Shift to the correct bit     */
    .unreq pinNum

    teq pinVal,#0               /* Check if pinVal equal to 0 */
    .unreq pinVal
    streq setBit,[gpioAddr,#40] /* If equal store at 40       */
    strne setBit,[gpioAddr,#28] /* Not equal store at 28      */
    .unreq setBit
    .unreq gpioAddr
    pop {pc}                    /* Return to caller           */
