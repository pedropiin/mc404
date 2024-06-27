.globl recursive_tree_search
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl exit

recursive_tree_search:
    # We receive the pointer to the node in a0
    # and the desired value in a1

    li s0, 0 # depth counter
    mv s2, sp # pointer to the stack originally
    sw ra, 0(sp) # stores the return address
    la ra, found # stores the address of the found label

    tree_search:
        addi s0, s0, 1

        addi sp, sp, -4
        sw ra, 0(sp) # stores the return address
        addi sp, sp, -4 
        sw a0, 0(sp) # stores the address of the current node

        lw t0, 0(a0) # value stored in the node
        beq t0, a1, found # branch if value in node == desired

        lw a0, 4(a0) # address to the left child node
        beq a0, x0, no_left_node # branch if left child node == 0

        jal tree_search
    no_left_node:
        lw t0, 0(sp)
        lw a0, 8(t0) # address to the right child node
        beq a0, x0, no_right_node # branch if right child node == 0

        jal tree_search
    no_right_node:
        addi sp, sp, 4
        lw ra, 0(sp) # restores the address of the return address
        addi sp, sp, 4
        lw a0, 0(sp) # restores the address of the parent node

        addi s0, s0, -1
        ret
    found:
        mv a0, s0 # returns the depth of the node
        mv sp, s2
        lw ra, 0(sp) # restores return address
    ret

puts:
    # We receive pointer to string in a0

    # t1 will be used to read each byte
    # t2 will hold the size of the string
    # t5 will be used as a pointer to the string

    addi sp, sp, -4
    sw ra, 0(sp)

    mv t5, a0 # pointer to string
    li t2, 0 # size counter
    lbu t1, 0(t5) # read the first byte

    # ----- Getting string size for output -----

    while_size_string:
        beq t1, x0, end_while_size_string # break if \0

        addi t2, t2, 1 # increment counter
        addi t5, t5, 1 # increment pointer
        lbu t1, 0(t5) # read next byte

        j while_size_string
    end_while_size_string:

    li t1, 10
    sb t1, 0(t5) # add newline
    addi t2, t2, 1 # increment size

    mv a1, a0
    mv a2, t2
    jal write

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

gets:
    addi sp, sp, -4
    sw ra, 0(sp)

    mv t5, a0 # pointer to buffer
    mv a1, a0 # pointer to buffer used in read
    li a2, 20 # buffer size
    
    jal read

    mv a0, t5

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

atoi:
    # We receive the desired number as a string pointed by a0

    # t0 will store the number as integer
    # t1 will be used for reading each byte
    # t2 will be used to multiply t0 by 10
    # t5 will be used as a pointer to the string
    # t6 will store the sign of the number

    mv t5, a0

    # ----- Getting the first digit -----

    lbu t1, 0(t5)
    li t6, 45 # ASCII for '-'
    beq t1, t6, negative_number # branch if negative
    li t6, 1
    addi t5, t5, 1 # t5 now points to the next digit
    j cont_atoi
negative_number:
    li t6, -1
    addi t5, t5, 1
    lbu t1, 0(t5)
    addi t5, t5, 1
cont_atoi:
    addi t1, t1, -48 # converting the byte to an integer
    mv t0, t1
    lbu t1, 0(t5) # Getting next byte
    li t2, 10 # will be used to multiply t0

    while_atoi:
        beq t1, x0, end_while_atoi # break if null
        beq t1, t2, end_while_atoi # break if newline

        mul t0, t0, t2

        addi t1, t1, -48
        add t0, t0, t1

        addi t5, t5, 1
        lbu t1, 0(t5)
        j while_atoi
    end_while_atoi:
    
    mul t0, t0, t6 # multiply the number by the sign
    mv a0, t0

    ret

itoa:
    # We receive the number as integer in a0, 
    #                pointer to string to store it in a1
    #                and the base in a2

    # t0 will store the number as integer
    # t1 will be used to store the ASCII value of the digit
    # t2 will be used to count the ammount of digits in the number
    # t3 will be used as divisor
    # t5 will be used as incremented pointer to buffer

    mv t5, a1 # new pointer to the string
    bge a0, x0, positive_number # branch if positive
    li t1, 45 # ASCII for '-'
    sb t1, 0(t5)
    addi t5, t5, 1
    li t2, -1
    mul a0, a0, t2
positive_number:
    
    # ----- Counting digits -----
    mv t0, a0 # number
    li t2, 1 # counter
    li t3, 10 # divisor

    div t0, t0, t3

    while_output_size:
        beq t0, x0, end_while_output_size # break if 0
        
        addi t2, t2, 1
        div t0, t0, t3
        j while_output_size
    end_while_output_size:

    # ----- Setting the divisor -----
    li t3, 1 # divisor
    li t4, 1 # iteration counter
    li t6, 10 # multiplier of the divisor

    for_remainder:
        beq t4, t2, end_for_remainder # branch if iterations == count

        mul t3, t3, t6 # multiply divisor by 10
        addi t4, t4, 1 # iterations++
        j for_remainder
    end_for_remainder:

    # ----- Storing the answer -----
    li t4, 0 # iteration counter
    mv t0, a0 # output as integer

    while_storing_output:
        beq t4, t2, end_while_storing_output # break if iterations == count
        
        div t1, t0, t3 # t1 = t0 / t3 => t1 = num / divisor
        addi t1, t1, 48 # convert to ASCII
        sb t1, 0(t5) # store the digit in the buffer

        rem t0, t0, t3
        li t1, 10 
        div t3, t3, t1 # t3 = t3 / 10 ==> increasing the divisor

        addi t5, t5, 1 # updating pointer to buffer
        addi t4, t4, 1 # updating counter
        j while_storing_output
    end_while_storing_output:

    mv a0, a1 # a0 is the only return value

    ret

exit:
    li a0, 0
    li a7, 93
    ecall

read:
    li a0, 0
    # a1 already is pointer to buffer
    # a2 already holds the size of the buffer
    li a7, 63 # syscall read
    ecall
    ret

write:
    li a0, 1
    # a1 already is pointer to buffer
    # a2 already holds the size of the buffer
    li a7, 64 # syscall write
    ecall
    ret