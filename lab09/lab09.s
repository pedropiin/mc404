.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93
    ecall

.text

main:
    addi sp, sp, -4
    sw ra, 0(sp)

    la s0, input_adress
    la s11, result

    jal read

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

read:
    li a0, 0
    la a1, input_adress
    li a2, 7
    li a7, 63
    ecall
    ret

write:
    li a0, 1
    la a1, result
    li a2, 20
    li a7, 64
    ecall
    ret


.bss

input_address: .skip 0x7
result: .skip 0x05