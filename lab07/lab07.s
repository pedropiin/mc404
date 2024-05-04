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
        # s8 = da
        # s9 = db
        # s10 = dc

        # a0 = x
        # a1 = y

    # Guarda return adress na stack
    addi sp, sp, -4
    sw ra, 0(sp)

    # Seta ponteiros para início de 'input_adress' e 'result'
    la s0, input_address
    la s1, result
    la s11, result

    jal le_distancias

    la s0, input_address

    jal le_tempos

    jal calcula_distancias

    jal calcula_posicoes

    jal salva_resposta

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
    li t3, 0 # variável de iteração e contagem 'i'
    li t4, 21 # variável de limite do for

    for_sqrt:
        bge t3, t4, end_for_sqrt

        div t1, a0, t0
        add t0, t0, t1
        div t0, t0, t2
        addi t3, t3, 1
        
        j for_sqrt
    end_for_sqrt:

    mv a0, t0
    
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
le_distancias:
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
    mul s3, s3, t0
e_positivo2:

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

le_tempos:
    addi sp, sp, -4
    sw ra, 0(sp)

    jal read

    # Seção a seguir de recebimento de número poderia ser 
    # feita em um for, porém, por guardar cada número em
    # uma variável diferente, mais fácil assim

    # --- Início da seção ineficiente ---

    # Opera sobre primeiro número do input
    jal number_from_string
    jal my_atoi
    jal soma_digitos

    # s4 guarda Tr
    mv s4, a0

    addi s0, s0, 5 # ajustando ponteiro para próximo número

    # Opera sobre segundo número do input
    jal number_from_string
    jal my_atoi
    jal soma_digitos

    # s5 guarda Ta
    mv s5, a0

    addi s0, s0, 5 # ajustando ponteiro para próximo número

    # Opera sobre terceiro número do input
    jal number_from_string
    jal my_atoi
    jal soma_digitos

    # s6 guarda Tb
    mv s6, a0

    addi s0, s0, 5 # ajustando ponteiro para próximo número

    # Opera sobre último número do input
    jal number_from_string
    jal my_atoi
    jal soma_digitos

    # s7 guarda Tc
    mv s7, a0

    # --- Fim da seção ineficiente ---

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

calcula_distancias:

    # Cálculo de da
    li t3, 3
    sub t0, s4, s5 # Tr - Ta
    mul s8, t0, t3 # (Tr - Ta) * 3
    li t0, 10
    div s8, s8, t0 # s8 / 10 para ajustar as unidades

    # Cálculo de db
    sub t0, s4, s6 # Tr - Tb
    mul s9, t0, t3 # (Tr - Tb) * 3
    li t0, 10
    div s9, s9, t0 # s9 / 10 para ajustar as unidades

    # Cálculo de dc
    sub t0, s4, s7 # Tr - Tc
    mul s10, t0, t3 # (Tr - Tc) * 3
    li t0, 10
    div s10, s10, t0 # s10 / 10 para ajustar as unidades

    ret

testa_valor_x:

    # Caso 1: x > 0
    mv t0, a0 
    sub t0, t0, s2
    mul t0, t0, t0
    add t0, t0, a1

    # Caso 2: x < 0
    mv t1, a0
    li t2, -2
    mul t1, t1, t2
    sub t1, t1, s2
    mul t1, t1, t1
    add t1, t1, a1

    mul t2, s10, s10 # t2 = dc^2

    # Comparação
    sub t0, t0, t2 # t0 = x > 0 - dc^2
    sub t1, t1, t2 # t1 = x < 0 - dc^2

    blt t0, t1, x_positivo
    li t2, -2
    mul a0, a0, t2
x_positivo:
    ret

calcula_posicoes:
    addi sp, sp, -4
    sw ra, 0(sp)

    # --- Cálculo de y --- 
    mul t0, s8, s8 # t0 = da^2
    mul t1, s3, s3 # t1 = Yb^2
    mul t2, s9, s9 # t2 = db^2
    
    add t0, t0, t1 # t0 = da^2 + yb^2
    sub t0, t0, t2 # t0 = da^2 + yb^2 - db^2

    li t2, 2
    mul t2, s3, t2 # t2 = 2 * yb
    div a1, t0, t2 # a1 = (da^2 + yb^2 - db^2) / 2 * yb

    # --- Cálculo de x ---
    mul t0, s8, s8 # t0 = da^2
    mul t1, a1, a1 # t1 = y^2
    sub a0, t0, t1 # a0 = da^2 - y^2

    jal sqrt # a0 guarda o valor da raíz de a0, isto é, sqrt(da^2 - y^2)
    
    jal testa_valor_x

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

salva_resposta:

    # --- Valor de x ---
    bge a0, x0, else_x
    li t0, 45
    sb t0, 0(s1)
    j cont_x
else_x: # x > 0
    li t0, 43
    sb t0, 0(s1)
cont_x:
    # guarda dígito mais significante
    li t0, 1000
    div t1, a0, t0
    addi t1, t1, 48
    sb t1, 1(s1)
    rem a0, a0, t0

    # guarda segundo dítigo mais significante
    li t0, 100
    div t1, a0, t0
    addi t1, t1, 48
    sb t1, 2(s1)
    rem a0, a0, t0
    
    # guarda terceiro dítigo mais significante
    li t0, 10
    div t1, a0, t0
    addi t1, t1, 48
    sb t1, 3(s1)
    rem a0, a0, t0

    # guarda quarto dítigo mais significante
    addi a0, a0, 48
    sb a0, 4(s1)

    li t0, 32
    sb t0, 5(s1)
    addi s1, s1, 6


    # --- Valor de y ---
    bge a1, x0, else_y
    li t0, 45
    sb t0, 0(s1)
    j cont_y
else_y: # y > 0
    li t0, 43
    sb t0, 0(s1)
cont_y:
    # guarda dígito mais significante
    li t0, 1000
    div t1, a1, t0
    addi t1, t1, 48
    sb t1, 1(s1)
    rem a1, a1, t0

    # guarda segundo dígito mais significante
    li t0, 100
    div t1, a1, t0
    addi t1, t1, 48
    sb t1, 2(s1)
    rem a1, a1, t0

    # guarda terceiro dígito mais significante
    li t0, 10
    div t1, a1, t0
    addi t1, t1, 48
    sb t1, 3(s1)
    rem a1, a1, t0

    # guarda quarto dígito mais significante
    addi a1, a1, 48
    sb a1, 4(s1)

    li t0, 10
    sb t0, 5(s1)

    ret

.bss

input_address: .skip 0x20  # buffer
result: .skip 0x20