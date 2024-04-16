.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

.text

main:
    # Código aqui
    addi sp, sp, -4
    sw ra, 0(sp)

    la s0, input_address
    la s1, result
    la s11, result

    jal read

    li s2, 0 # Contador do for da main
    li s3, 4 # Limite de iterações do for, i.e., número de bytes da entrada
    li s4, 5 # Incrementador do ponteiro s0. 5 bytes para ir para o primeiro digito do proximo numero

    for_main:
        bge s2, s3, end_for_main


        jal number_from_string

        jal my_atoi

        jal soma_digitos

        jal sqrt # registrador a7 guarda valor da raíz do num da iteracao

        jal save_answer

        li t0, 32 # valor na tabela ascii de espaço em branco
        sb t0, 4(s1) # adicionando espaço em branco no buffer de saída

        addi s2, s2, 1
        # mul t3, s2, s4 # t3 = i * 5
        addi s0, s0, 5 # s0 += t3
        addi s1, s1, 5 # s1 += t3

        j for_main
    end_for_main:

    li t0, 10 # valor na tabela ascii de newline
    sb t0, 19(s11) # adicionando newline no buffer de saída

    jal write

    lw ra, 0(sp)
    addi sp, sp, 4
    ret


read:
    li a0, 0            # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 20           # size - Reads 20 bytes.
    li a7, 63           # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 20           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

number_from_string:
    # Guarda quatro dígitos de uma string em registradores
    lbu a1, 0(s0)
    lbu a2, 1(s0)
    lbu a3, 2(s0)
    lbu a4, 3(s0)

    ret

my_atoi:
    # Converte quatro dígitos em inteiros
    add a1, a1, -48
    add a2, a2, -48
    add a3, a3, -48
    add a4, a4, -48

    ret

soma_digitos:
    # Converte quadro dígitos de um número inteiro
    # para o número que eles formam em conjunto
    # Input: a1 (int) digito mais significante do input
    #        a2 (int) segundo digito mais significante do input
    #        a3 (int) terceiro digito mais significante do input
    #        a4 (int) quarto digito mais significante do input
    # Output: a0 (int) decimal de quadro dígitos
    # Ex: 1(int)-2(int)-3(int)-4(int) ==> 1234 (int)
    li t0, 1000
    mul a1, a1, t0
    li t0, 100
    mul a2, a2, t0
    li t0, 10
    mul a3, a3, t0

    li a0, 0
    add a0, a0, a1
    add a0, a0, a2
    add a0, a0, a3
    add a0, a0, a4

    ret

sqrt:
    # Realiza aproximação da raíz quadrada de um inteiro
    # de quatro dígitos 
    # Input: a0 (int): valor que se deseja calcular a raíz
    # Output: a7 (int): aproximação da raíz de a0

    # a0 = y 
    # t0 = k
    li t2, 2 # divisão frequente no método de aproximação
    div t0, a0, t2
    
    li a1, 0 # variável de iteração e contagem 'i'
    li a2, 10 # variável de limite do for

    for_sqrt:
        bge a1, a2, end_for_sqrt

        div t1, a0, t0 # t1 = a0 / t0 ==> t1 = y / k
        add t0, t0, t1 # t0 = t0 + t1 ==> t0 = k + t1 = k + y / k
        div t0, t0, t2 # t0 = t0 / t2 ==> t0 = (k + y / k) / 2

        addi a1, a1, 1

        j for_sqrt
    end_for_sqrt:

    mv a7, t0

    ret



save_answer:
    # Função para escrever um inteiro de 4 dígitos no buffer de saída
    # no formato DDDD
    # Input: a7 (int): inteiro que se deseja printar
    #        s1 (ptr): ponteiro para posição atual do buffer de escrita

    # guarda dígito mais significante
    li t0, 1000
    div t1, a7, t0
    addi t1, t1, 48
    sb t1, 0(s1)
    rem a7, a7, t0

    # guarda segundo dígito mais significante
    li t0, 100
    div t1, a7, t0
    addi t1, t1, 48
    sb t1, 1(s1)
    rem a7, a7, t0

    # guarda terceiro dígito mais significante
    li t0, 10
    div t1, a7, t0
    addi t1, t1, 48
    sb t1, 2(s1)
    rem a7, a7, t0

    # guarda quarto bit mais significante
    addi a7, a7, 48
    sb a7, 3(s1)

    ret

.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20