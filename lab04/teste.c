#include <stdio.h>

int power(int base, int expoente) {
    int result = 1;
    while (expoente > 0) {
        result = result * base;
        expoente--;
    }
    return result;
}

int tamanho_string(char* arr) {
    int i;
    for (i = 0; arr[i] != '\0'; i++);
    return i;
}

void reverse_string(char* str, int tamanho) {
    int i = 0, j = tamanho - 1;
    char temp;
    while (i < j) {
        temp = str[i];
        str[i] = str[j];
        str[j] = temp;
        i++;
        j--;
    }
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

int my_atoi(char* arr) {
    int result = 0, i = 0, tamanho = tamanho_string(arr);
    for (int i = 0; i < tamanho; i++) {
        result = result * 10 + (arr[i] - '0');
    }
    return result;
}

int my_itoa(char* str, int num, int base) {
    int i = 0, resto;
    if (num == 0) {
        str[i] = '0';
        i++;
        str[i] = '\n';
    } else {
        while (num != 0) {
            resto = num % base;
            if (base == 16 && resto > 9) {
                str[i++] = (char)(resto + 'a' - 10);
            } else {
                str[i++] = (char)(resto + '0');
            }
            num = num / base;
        }
        str[i] = '\n';
    }
    reverse_string(str, i);
    return i;
}


int base_to_dec(char* arr_in, char* arr_out, int base) {
    int tamanho_in = tamanho_string(arr_in), count = 0, tamanho_out;
    unsigned long long val = 0;
    for (int i = tamanho_in - 1; i > 1; i--) {
        if (arr_in[i] >= 'a' && arr_in[i] <= 'f') {
            val += (unsigned long long)(arr_in[i] - 'a' + 10) * power(base, count);
        } else {
            val += (unsigned long long)(arr_in[i] - '0') * power(base, count);
            printf("soma %lld\n", (unsigned long long)(arr_in[i] - '0') * power(base, count));
        }
        printf("val esta como %lld\n", val);
        count++;
    }
    printf("O valor de val é %lld e o de count é %d\n", val, count);
    tamanho_out = my_itoa(arr_out, val, 10);
    return tamanho_out + 1;
}


int count_num_bits(char* arr_num) {
    int num = my_atoi(arr_num);
    int n = 0;
    while (power(2, n) < num) {
        n++;
    } 
    return n;
}

void dec_to_bin(char* arr_in, char* arr_out) {
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

void dec_to_hex(char* arr_in, char* arr_out) {
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


void dec_to_oct(char* arr_in, char* arr_out) {
    int num_digitos = (count_num_bits(arr_in) / 2) + 1, num = my_atoi(arr_in), i = 0;
    char temp[num_digitos];
    while (num > 0) {
        temp[i] = (char)((num % 2) + '0');
        num = num / 2;
        i++;
    }

    //ajustando para representação octal
    int padrao_oct = 2;
    arr_out[0] = '0';
    arr_out[1] = 'x';
    //invertendo o número octal
    for (int i = 0; i < num_digitos; i++) {
        arr_out[i + padrao_oct] = temp[num_digitos - i - 1];
    }
    arr_out[num_digitos + padrao_oct] = '\n';
}

void bin_to_dec(char* arr_in, char* arr_out) {
    int tamanho_in = tamanho_string(arr_in), count = 0, val = 0;
    for (int i = tamanho_in - 1; i > 1; i--) {
        val += (int)(arr_in[i] - '0') * power(2, count);
        count++;
    }
    my_itoa(arr_out, val, 10);
}

void hex_to_dec(char* arr_in, char* arr_out) {
    int tamanho_in = tamanho_string(arr_in), count = 0, val = 0;
    for (int i = tamanho_in - 1; i > 1; i--) {
        if (arr_in[i] >= 'a' && arr_in[i] <= 'f') {
            val += (int)(arr_in[i] - 'a' + 10) * power(16, count);
        } else {
            val += (int)(arr_in[i] - '0') * power(16, count);
        }
        count++;
    }
    my_itoa(arr_out, val, 10);
}

void oct_to_dec(char* arr_in, char* arr_out) {
    int tamanho_in = tamanho_string(arr_in), count = 0, val = 0;
    for (int i = tamanho_in - 1; i > 1; i--) {
        val += (int)(arr_in[i] - '0') * power(8, count);
        count++;
    }
    my_itoa(arr_out, val, 10);
}


int main(int argc, char* argv[]) {
    char out_buf[35], num[35];
    scanf("%s", num);
    base_to_dec(num, out_buf, 2);
    printf("%s\n", out_buf);
}