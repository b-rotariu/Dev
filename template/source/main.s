.section .init
.global _start
_start:
.section .text
main:
mov sp,#0x8000
ldr r0, =0x20200000

pinNum .req r0
pinFunc .req r1

mov pinNum,#16
mov pinFunc,#1

bl SetGpioFunction

.unreq pinNum
.unreq pinFunc

loop$:

pinNum .req r0
pinVal .req r1

mov pinNum,#16

mov pinVal,#0
bl SetGpio

mov pinVal,#1
bl SetGpio

.unreq pinNum
.unreq pinVal

str r1,[r0,#28]

b loop$
