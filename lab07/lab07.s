.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

.text

main:

    # TODO
    # ler primeiro input relacionado a coordenadas dos satelites
    # fazer conversão e inverter sinal de bytes 0 ou 6 forem negativos ou positivos
    # ler input dos tempos
    # fazer conversão dos tempos e armazena-los
    # calcular distancias conforme dx = Tx * 3e8
    # utilizar formulas apresentadas

    # Plano de estrutura de memória:
        # s2 = Xc
        # s3 = Yb
        # s4 = Tr
        # s5 = Ta
        # s6 = Tb
        # s7 = Tc

    # Guarda return adress na stack
    addi sp, sp, -4
    sw ra, 0(sp)

    # Seta ponteiros para início de 'input_adress' e 'result'
    la s0, input_address
    la s1, result
    la s11, result

    jal le_tempos

    #
    mv a7, s3
    jal save_answer
    li t0, 10
    sb t0, 5(s11)
    jal write
    #

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

# Converte quatro dígitos de um número inteiro 
# para o número que eles foramem em conjunto
# Input: a1 (int) digito mais significante do input
#        a2 (int) segundo digito mais significante do input
#        a3 (int) terceiro digito mais significante do input
#        a4 (int) quarto digito mais significante do input
# Output: a0 (int) decimal de quadro dígitos
# Ex: 1(int)-2(int)-3(int)-4(int) ==> 1234 (int)
soma_digitos:

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

# Realiza a aproximação da raíz quadrada de um inteiro
sqrt:

    li t2, 2 # divisão frequente padrão no método de aproximação
    div t0, a0, t2
    li a1, 0 # variável de iteração e contagem 'i'
    li a2, 21 # variável de limite do for

    for_sqrt:
        bge a1, a2, end_for_sqrt

        div t1, a0, t0
        add t0, t0, t1
        div t0, t0, t2
        addi a1, a1, 1
        
        j for_sqrt
    end_for_sqrt:

    mv a7, t0
    
    ret

# Função para escrever um inteiro de 4 dígitos no buffer de saída
# no formato DDDD
# Input: a7 (int): inteiro que se deseja printar
#        s1 (ptr): ponteiro para posição atual do buffer de escrita
save_answer:

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

# Função que le os dois primeiros inputs (Xc e Yb) e 
# guarda seus valores convertidos para inteiros em 
# s2 e s3, respectivamente
le_tempos:
    addi sp, sp, -4
    sw ra, 0(sp)

    jal read

    # guarda sinal do primeiro num
    lbu t6, 0(s0)
    addi s0, s0, 1 

    jal number_from_string
    jal my_atoi
    jal soma_digitos
    
    # s2 guarda Xc
    mv s2, a0 

    # checa e converte conforme o sinal
    li t0, 43
    beq t6, t0, e_positivo1
    li t0, -2
    mul s2, s2, t0
e_positivo1:

    # ajusta s0 para próximo sinal e guarda sinal do segundo num
    addi s0, s0, 5 
    lbu t6, 0(s0)
    addi s0, s0, 1

    jal number_from_string
    jal my_atoi
    jal soma_digitos

    # s3 guarda Yb
    mv s3, a0

    # checa e converte conforme o sinal
    li t0, 43
    beq t6, t0, e_positivo2
    li t0, -2
    mul s2, s2, t0
e_positivo2:

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20