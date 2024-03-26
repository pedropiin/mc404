#include <stdio.h>

int power(int num, int n) {
    int result = num;
    for (int i = 0; i < (n - 1); i++) {
        result *= num;
    }
    return result;
}

int tamanho_string(char* arr) {
    int i;
    for (i = 0; arr[i] != '\0'; i++);
    return i;
}

int my_atoi(char* arr) {
    int result = 0, i = 0;
    for (int i = 0; i < tamanho_string(arr); i++) {
        result = result * 10 + (arr[i] - '0');
    }

    return result;
}

int count_num_bits(char* arr_num) {
    int num = my_atoi(arr_num);
    int n = 0;
    while (power(2, n) < num) {
        n++;
    } 
    return n;
}

char hex_converter(int num) {
    switch (num) {
        case 10:
            return 'A';
            break;
        case 11:
            return 'B';
            break;
        case 12:
            return 'C';
            break;
        case 13:
            return 'D';
            break;
        case 14:
            return 'E';
            break;
        case 15:
            return 'F';
            break;
    }
}

void dec_to_bin(char* arr_out, char* arr_in) {
    int num_bits = count_num_bits(arr_in), num = my_atoi(arr_in), i = 0;
    char temp[num_bits];
    printf("%c\n", (char)(num_bits + '0'));
    while (num > 0) {
        temp[i] = (char)((num % 2) + '0');
        num = num / 2;
        i++;
    }

    //ajustando para representação binaria
    int padrao_bin = 2;
    arr_out[0] = '0';
    arr_out[1] = 'b';
    // invertendo o número binário
    for (int i = 0; i < num_bits; i++) {
        arr_out[i + padrao_bin] = temp[num_bits - i - 1];
    }
    arr_out[num_bits + padrao_bin] = '\n';
}

int dec_to_hex(char *arr_out, char* arr_in) {
    int num_digitos = (count_num_bits(arr_in) / 4) + 1, num = my_atoi(arr_in), i = 0, resto;
    char temp[num_digitos];
    while (num > 0) {
        resto = num % 16;
        if (resto <= 9) {
            temp[i] = (char)(resto + '0');
        } else {
            temp[i] = hex_converter(resto);
        }
        num = num / 16;
        i++;
    }

    //ajustando para representação hexadecimal
    int padrao_hex = 2;
    arr_out[0] = '0';
    arr_out[1] = 'x';
    //invertendo o número hexadecimal
    for (int i = 0; i < num_digitos; i++) {
        arr_out[i + padrao_hex] = temp[num_digitos - i - 1];
    }
    arr_out[num_digitos + padrao_hex] = '\n';
}

int main(int argc, char* argv[]) {
    char out_buf[32], num[1000];
    scanf("%s", num);
    if (num[0] == '0') {
        ;
    } else {
        dec_to_bin(out_buf, num);
    }
    printf("%s\n", out_buf);
}