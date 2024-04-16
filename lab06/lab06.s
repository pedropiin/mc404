.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

.text:

main:
    # Código aqui
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read

    addi s2, x0, 0 # Contador do for da main
    li s3, 4 # Limite de iterações do for, i.e., número de bytes da entrada
    li s4, 5 # Incrementador do ponteiro s0. 5 bytes para ir para o primeiro digito do proximo numero

    for_main:
        bge s2, s3, end_for_main

        #TODO: devo somar 5 ou 40, ou seja, a soma interpreta cada unidade como byte ou bit?
        mul t3, s2, s4
        add s0, s0, t3
        add s1, s1, t3

        addi sp, sp, -4
        sw ra, 0(sp)
        jal number_from_string

        addi sp, sp, -4
        sw ra, 0(sp)
        jal my_atoi

        addi sp, sp, -4
        sw ra, 0(sp)
        jal soma_digitos

        addi sp, sp, -4
        sw ra, 0(sp)
        jal sqrt # registrador a7 guarda valor da raíz do num da iteracao

        addi sp, sp, -4
        sw ra, 0(sp)
        jal save_answer

        addi s2, s2, 1

        j for_main
    end_for_main:

    ret


read:
    li a0, 0            # file descriptor = 0 (stdin)
    la s0, input_adress # buffer
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

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

my_atoi:
    # Converte quatro dígitos em inteiros
    add a1, a1, -48
    add a2, a2, -48
    add a3, a3, -48
    add a4, a4, -48

    lw ra, 0(sp)
    addi sp, sp, 4

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

    li t0, 0
    mv a0, t0
    add a0, a0, a1
    add a0, a0, a2
    add a0, a0, a3
    add a0, a0, a4

    lw ra, 0(sp)
    addi sp, sp, 4
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

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#TODO: fazer s11 apontar para o início de result
#TODO: fazer s1 apontar para alguma posição de result
save_answer:
    # Função para escrever um inteiro de 4 dígitos no buffer de saída
    # no formato DDDD
    # Input: a7 (int): inteiro que se deseja printar
    #        s1 (ptr): ponteiro para posição atual do buffer de escrita

    # guarda dígito mais significante
    li t0, 1000
    div t1, a7, t0
    sb t1, 0(s1)
    rem a7, a7, t0

    # guarda segundo dígito mais significante
    li t0, 100
    div t1, a7, t0
    sb t1, 1(s1)
    rem a7, a7, t0

    # guarda terceiro dígito mais significante
    li t0, 10
    div t1, a7, t0
    sb t1, 2(s1)
    rem a7, a7, t0

    # guarda quarto bit mais significante
    sb a7 3(s1)

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20