.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

.text

# s0 = &input_adress
# s1 = num linhas
# s2 = num colunas
# s3 = índice do primeiro pixel


# 1º Ler informações da imagem
    # cabeçalho PGM é da forma:
        # P2
        # NN YY
        # AAA
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

    la s0, input_address
    jal open
    jal read

    jal get_info_header
    
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

read:
    la a1, input_address # buffer
    li a7, 63           # syscall read (63)
    ecall


set_canvas_size:
    mv a0, s1
    mv a1, s1
    li a7, 2201
    ecall


get_info_header:
    # --- Lê número de linhas ---
    lbu a0, 3(s0) 
    lbu a1, 4(s0)

    # --- Converte número de linhas em inteiro
    li t0, 32
    bne a1, t0, not_white_space 
    # Se segundo dígito for um espaço
    addi a0, a0, -48
    mv s1, a0
    j cont_white_space
not_white_space: 
    # a1 != ' '
    lbu a2, 5(s0)
    bne a2, t0, second_not_white_space: 
    # Se terceiro dígito for um espaço
    addi a0, a0, -48
    addi a1, a1, -48
    li t0, 10
    mul a1, a1, t0
    add s1, a1, a0
    j cont_white_space
second_not_white_space:
    # a2 != ' '
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


process_image:
    addi sp, sp, -4
    sw ra, 0(sp)

    # s0 = &input_adress == array com todos os pixels
    # s1 = n_linhas = n_colunas

    #                   ---------
    # Checa qual posição de s0 guarda o primeiro pixel,
    # pois caso tenhamos uma imagem de, e.g. tamanho 8x8,
    # o primeiro pixel está em posição diferente da 
    # imagem de tamanho 12x12. Isso se deve ao espaço ocupado
    # pelo header 
    #                   ----------
    li s3, 13
    li t0, 10
    bge s1, t0, cont_process
    li s3, 11
cont_process:
    li t2, 255 # Valor constante do alpha
    li t3, 0 # variável de iteração e contagem 'i'
    li t4, 0 # variável de iteração e contagem 'j'
    mv t5, s1 # variável de limite do for, isto é, num_linhas

    for_num_linhas:
        bge t3, t5, end_for_num_linhas
        
        for_num_colunas:
            bge t4, t5, end_for_num_colunas

            # Posição do pixel atual é do formato ((s1 * i) + j) + s3
            mul t0, s1, t3
            add t0, t0, t4
            add t0, t0, s3
            lbu t1, t0(s0) # Valor do pixel da iteração

            # --- Guardando valores do pixel em a2 para chamar setPixel
            sb t1, 0(a2) # Valor de R
            sb t1, 1(a2) # Valor de G
            sb t1, 2(a2) # Valor de B
            sb t2, 3(a2) # Valor de alpha

            mv a0, t3 # Posição da coordenada x do pixel
            mv a1, t4 # Posição da coordenada y do pixel
            jal set_pixel

            addi t4, t4, 1
            j for_num_colunas
        end_for_num_colunas:

        addi t3, t3, 1
        j for_num_linhas
    end_for_num_linhas:

    lw ra, 0(sp)
    addi sp, sp, 4
    ret


set_pixel:
    # Valores de a0, a1 e a2 são definidos antes da chamada da função
    li a7, 2200
    ecall


.bss
input_file: .asciz "image.pgm"
input_address: .skip 0x4000f