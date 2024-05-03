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
    # Converte quatro dígitos de um número inteiro 
    # para o número que eles foramem em conjunto
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
    # Realiza a aproximação da raíz quadrada de um inteiro
    li t2, 2 # divisão frequente padrão no método de aproximação
    div t0, a0, t2
    li a1, 0 # variável de iteração e contagem 'i'
    li a2, 21 # variável de limite do for

    for_sqrt:
        bge a1, a2, end_for_sqrt

        div t1, a0, t0
        add t0, t0, t1
        div t0, t0, t2
        addi, a1, a1, 1
        
        j for_sqrt
    end_for_sqrt:

    mv a7, t0
    
    ret


.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20