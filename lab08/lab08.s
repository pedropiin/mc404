set_pixel:
    li a0, temp # TODO: alterar "temp" para valor da variavel  
    li a1, temp # TODO: alterar "temp" para valor da variavel 
    li a2, temp # TODO: alterar "temp" para valor da variavel 
    li a7, 2200
    ecall

open:
    la a0, input_file
    li a1, 0
    li a2, 0
    li a7, 1024
    ecall

.bss
input_file: .asciz "image.pgm"