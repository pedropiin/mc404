.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93
    ecall

.text

main:
    # Convert input into int
        # s1 = input
    
    # t5 = 0 == count
    # while la node != 0
        # t0 = lw 0
        # t1 = lw 4
        # t2 = lw 8
        # t3 = la 12

        # t4 = t0 + t1 + t2
        # if t4 == s1
            # break
            # write t5
        # else
            # continue

    addi sp, sp, -4
    sw ra, 0(sp)

    la s0, input_address
    la s11, result

    jal read

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

solve:

my_atoi:

read:
    li a0, 0
    la a1, input_address
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