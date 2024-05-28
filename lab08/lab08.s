.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

.text

# s0 = endereço atual de input_adress
# s1 = num linhas
# s2 = num colunas
# s3 = índice do primeiro pixel
# s4 = endereço inicial de input_adress


# 1º Ler informações da imagem
    # cabeçalho PGM é da forma:
        # P2\n
        # NNN YYY\n
        # AAA\n
    # Então, comçear a ler do 3º byte (3(s0))
    # Ler um char, verificar se o próximo é espaço ou não
        # Caso seja espaço, converter para decimal e guardar
        # Caso não seja espaço, converter para decimal * 10 e ler o próximo

# 2º For pelo tamanho da imagem
    # Para cada pixel, ler o valor em n(s0)
    # Guardar como hexadecimal nas posições mais significativas de a2
    # Guardar as últimas 8 posições como 255
    # a0 = i
    # a1 = j
    # chamar setPixel


main:
    addi sp, sp, -4
    sw ra, 0(sp)


    la s4, input_address    # Ponteiro constante para a primeira posição do arquivo.

    jal open
    jal read

    la s0, input_address    # Vai ser atualizado a cada iteração, 
                            # apontando sempre para o pixel da iteração

    jal get_info_header
    
    jal sets_s0

    jal set_canvas_size

    jal process_image

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

open:
    la a0, input_file
    li a1, 0
    li a2, 0
    li a7, 1024
    ecall
    ret

read:
    la a1, input_address # buffer
    li a2, 262159
    li a7, 63            # syscall read (63)
    ecall
    ret


set_canvas_size:
    mv a0, s1
    mv a1, s1
    li a7, 2201
    ecall
    ret


get_info_header:
    # --- Lê número de linhas ---
    lbu a0, 3(s0) # Le primeiro dígito da dimensão
    lbu a1, 4(s0) # Le byte após primeiro dígito da dimensão. Pode ser segundo dígito ou ' '

    # Não se sabe o número de linhas. Portanto, pode
    # ser um número de 1, 2 ou 3 dígitos, implicando
    # em quantidades diferentes de bytes a serem lidos.

    # --- Converte número de linhas em inteiro
    li t0, 32
    bne a1, t0, not_white_space 
    
    # --- Se segundo dígito for um espaço ---
    # Converte o único dígito em inteiro e guarda em s1
    addi a0, a0, -48
    mv s1, a0

    j cont_white_space
not_white_space: 
    # a1 != ' '
    lbu a2, 5(s0)
    li t0, 32
    bne a2, t0, second_not_white_space

    # --- Se terceiro dígito for um espaço ---
    # Converte os dois dígitos em inteiros e guarda em s1
    addi a0, a0, -48
    addi a1, a1, -48
    li t0, 10
    mul a1, a1, t0
    add s1, a1, a0

    j cont_white_space
second_not_white_space:
    # a2 != ' '

    # --- Se terceiro dígito não for um espaço ---
    # Converte os tres dígitos em inteiros e guarda em s1
    addi a0, a0, -48
    addi a1, a1, -48
    addi a2, a2, -48
    li t0, 100
    mul a0, a0, t0
    mv s1, a0
    li t0, 10
    mul a1, a1, t0
    add s1, s1, a1
    add s1, s1, a2
cont_white_space:
    # !!! Imagens quadradas. Portanto, n_linhas = n_colunas => s1 = s2.
    # Desse modo, não é necessário guardar valor de colunas em s2, pois 
    # já se tem acesso com o próprio s1
    ret


sets_s0:
    # A dimensão de cada imagem varia, junto com o número de bytes 
    # que essa informação ocupa.
    li t1, 10
    rem t0, s1, t1

    bne t0, x0, dim_two_digits
    # Dimensão é um número menor que 10
    addi s0, s0, 7 # Aponta para o primeiro dígito do valor de alpha

    j cont_if
dim_two_digits:
    li t1, 100
    rem t0, s1, t1

    bne t0, x0, dim_three_digits
    # Dimensão é um número entre 10 e 99
    addi s0, s0, 9 # Aponta para o primeiro dígito do valor de alpha

    j cont_if
dim_three_digits:
    # Dimensão é um número entre 100 e 255

    addi s0, s0, 11 # Aponta para o primeiro dígito do valor de alpha
cont_if:
    # --- Necessário agora checar quantos dígitos no valor de alpha ---
    lbu a0, 0(s0) # Primeiro dígito de alpha
    lbu a1, 1(s0) # Supostamente segundo dígito de alpha

    li t0, 32 # Valor em ASCII de ' '
    bne a1, t0, two_digits
    addi s0, s0, 2 # Aponta para o primeiro dígito da imagem

    j end_func
two_digits:
    # --- Valor de alpha entre 10 e 99 ---
    lbu a2, 2(s0) # Recebe terceiro dígito

    li t0, 10 # Valor em ASCII de '\n'
    bne a2, t0, three_digits
    addi s0, s0, 3

    j end_func
three_digits:
    # --- Valor de alpha entre 100 e 255 ---
    addi s0, s0, 4
end_func:
    ret


process_image:
    addi sp, sp, -4
    sw ra, 0(sp)

    # s0 = ponteiro para posição do byte atual da array de pixels
    # s1 = n_linhas = n_colunas

    li t2, 255 # Valor constante do alpha
    li t3, 0 # variável de iteração e contagem 'i'
    li t4, 0 # variável de iteração e contagem 'j'
    mv t5, s1 # variável de limite do for, isto é, num_linhas

    for_num_linhas:
        bge t3, t5, end_for_num_linhas
        
        for_num_colunas:
            bge t4, t5, end_for_num_colunas

            # Posição do pixel atual é do formato ((s1 * i) + j) + s3
            lbu t1, 0(s0) # Valor do pixel da iteração

            # --- Guardando valores do pixel em a2 para chamar setPixel
            sb t2, 0(a2) # Valor de alpha
            sb t1, 1(a2) # Valor de B
            sb t1, 2(a2) # Valor de G
            sb t1, 3(a2) # Valor de R

            mv a0, t4 # Posição da coordenada x do pixel
            mv a1, t3 # Posição da coordenada y do pixel
            jal set_pixel

            addi t4, t4, 1 # Atualiza variável de iteração 'j' do for de colunas
            addi s0, s0, 1 # Atualiza ponteiro do pixel para apontar para próximo pixel

            j for_num_colunas
        end_for_num_colunas:

        addi t3, t3, 1 # Atualiza variável de iteração 'i' do for de linhas
        li t4, 0

        j for_num_linhas
    end_for_num_linhas:

    lw ra, 0(sp)
    addi sp, sp, 4
    ret


set_pixel:
    # Valores de a0, a1 e a2 são definidos antes da chamada da função
    li a7, 2200
    ecall
    ret


.bss
input_address: .skip 0x4000f

.data
input_file: .asciz "image.pgm"