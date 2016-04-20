.globl GetGpioAddress
GetGpioAddress: 
ldr r0,=0x20200000
mov pc,lr

.globl SetGpioFunction
SetGpioFunction:

pinNum .req r0
pinFunc .req r1

cmp pinNum,#53
cmpls pinFunc,#7
movhi pc,lr

push {lr}
mov r2,pinNum
.unreq pinNum
pinNum .req r2

bl GetGpioAddress
gpioAddr .req r0

functionLoop$:
    cmp pinNum,#9
    subhi pinNum,#10
    addhi gpioAddr,#4
    bhi functionLoop$

add pinNum, pinNum,lsl #1
lsl pinFunc,pinNum

mask .req r3
mov mask,#7
lsl mask,pinNum
.unreq pinNum

mvn mask,mask
oldFunc .req,r2
ldr oldFunc,[gpioAddr]
and oldFunc,mask
.unreq mask

orr pinFunc,oldFunc
.unreq oldFunc

str pinFunc,[gpioAddr]
.unreq pinFunc
.unreq gpioAddr
pop {pc}

.globl SetGpio
SetGpio:
pinNum .req r0
pinVal .req r1
cmp pinNum,#53
movhi pc,lr
push {lr}
mov r2,pinNum
.unreq pinNum
pinNum .req r2
bl GetGpioAddress
gpioAddr .req r0
pinbank .req r3
lsr pinbank,pinNum,#5
lsl pinbank,#2
add gpioAddr, pinbank
.unreq pinbank
and pinNum,#31
setBit .req r3
mov setBit,#1
lsl setBit,pinNum
.unreq pinNum
teq pinVal,#0
.unreq pinVal
streq setBit,[gpioAddr,#40]
streq setBit,[gpioAddr,#28]
.unreq setBit
.unreq gpioAddr
pop {pc}
