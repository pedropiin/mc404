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

    jal get_input

    jal solve # t5 now holds the answer

    jal save_answer

    jal write

    lw ra, 0(sp)
    addi sp, sp, 4
    ret


get_first_digit:
    # Get first byte
    # If a digit, that it is positive and store it in t1, with t0 = 1
    # If not a digit, then it is negative and have to get the next byte
    lbu t1, 0(s0)
    li t6, 45 # ASCII for '-'
    beq t1, t6, negative_input # branch if negative
    li t0, 1
    addi s0, s0, 1 # setting s0 to the next byte
    j cont_get_first_digit
negative_input:
    li t0, -1
    addi s0, s0, 1
    lbu t1, 0(s0)
    addi s0, s0, 1
cont_get_first_digit:
    addi t1, t1, -48

    ret


get_input:
    # Function that gets all the input and stores it in s1
    addi sp, sp, -4
    sw ra, 0(sp)

    # ----- Getting the first input digit -----
    jal get_first_digit # t1 stores the first digit as an integer 
                        # t0 stores the sign of the input
    
    # ----- Getting the rest of the input -----
    mv s1, t1 # will store the input as integer
    lbu t1, 0(s0) # stores the next byte of the input
    li t2, 10 # will be used to multiply s1 

    li t6, 10 # ASCII for newline
    while_input:
        beq t1, t6, end_while_input # break if newline

        mul s1, s1, t2 # multiply the current input by 10

        addi t1, t1, -48 # converting the byte to an integer
        add s1, s1, t1

        addi s0, s0, 1 # getting the next byte
        lbu t1, 0(s0)
    end_while_input:

    li t2, 1
    beq t0, t2, cont_input # branch if positive
    li t2, -1
    mul s1, s1, t2 # multiply the input by -1

    cont_input:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


solve:
    li t5, 0 # count_variable

    la t3, head_node

    while_not_found:
        beq t3, x0, not_found # break if address to next node == 0

        lw t0, 0(t3) # first number
        lw t1, 4(t3) # second number
        lw t2, 8(t3) # third number
        lw t3, 12(t3) # address to next node

        # ------ Adding the numbers from the node ------
        li t4, 0
        add t4, t4, t0
        add t4, t4, t1
        add t4, t4, t2

        # ------ Checking if the sum is equal to the input ------
        beq t4, s1, cont_solve # break if sum == input

        addi t5, t5, 1 # count += 1
    not_found:
        li t5, -1
cont_solve:
    ret


output_size:
    # Function that calculates the number of digits of the output
    # and stores it in t0

    li t0, 1 # count
    li t1, 10 # divisor
    rem t2, t5, t1 # remainder

    while_output_size:
        beq t2, x0, end_while_output_size # break if remainder == 0

        li t3, 10
        mul t1, t1, t3 # multiply divisor by 10
        rem t2, t5, t1 # get the remainder

        addi t0, t0, 1 # count += 1
    end_while_output_size:
    ret


save_answer:
    # t5 holds the answer, that is, the index of the node
    # with the correct sum, or -1 if there is no such node

    addi sp, sp, -4
    sw ra, 0(sp)

    li t6, -1
    beq t5, t6, no_answer
    
    jal output_size # t0 holds the number of digits of the output

    # ----- Setting the divisor -----
    li t1, 1 # divisor
    li t2, 1 # count iterations
    li t3, 10 # multiplier of the divisor

    for_remainder:
        beq t2, t0, end_for_remainder # break if count == number of digits

        mul t1, t1, t3 # multiply divisor by 10
        addi t2, t2, 1 # count += 1
    end_for_remainder:

    # ----- Storing the answer in the result buffer -----
    li t2, 0 # count iterations
    while_saving_input:
        beq t2, t0, end_while_saving_input # break if divisor == 0

        div t3, t5, t1 # t3 = t5 / t1
        addi t3, t3, 48 # convert to ASCII
        sb t3, 0(s11) # store the digit in the buffer
        
        li t3, 10
        div t1, t1, t3 # t1 = t1 / 10
        rem t5, t5, t1 # t5 = t5 % t1

        addi s11, s11, 1 # move to the next byte
        addi t2, t2, 1 # count += 1
    end_while_saving_input:
    li t2, 10
    sb t2, 0(s11) # store newline
    j end_save_answer
no_answer:
    li t0, 45
    sb t0, 0(s11) # writing the negative sign
    addi s11, s11, 1

    li t0, 49 
    sb t0, 0(s11) # storing number 1 as ASCII
    addi s11, s11, 1 
    
    li t0, 10
    sb t0, 0(s11) # storing newline
end_save_answer:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

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