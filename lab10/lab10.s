.globl recursive_tree_search
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl exit

puts:

gets:

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

    lbu t1, 0(t5) # Getting next byte
    li t2, 10 # will be used to multiply t0

    while_atoi:
        beq t1, x0, end_while_atoi # break if null

        mul t0, t0, t2

        addi t1, t1, -48
        add t0, t0, t1

        addi t5, t5, 1
        lbu t1, 0(t5)
        j_while_input
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
        div t3, t3, t1 # t3 = t3 / 10

        addi t5, t5, 1
        addi t4, t4, 1
        j while_storing_output
    end_while_storing_output:
    


    ret

exit:
    li a0, 0
    li a7, 93
    ecall