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

void dec_to_bin(char* arr_out, char* arr_in) {
    int num_bits = count_num_bits(arr_in), num = my_atoi(arr_in), i = 0;
    char temp[num_bits];
    while (num > 0) {
        temp[i] = (char)((num % 2) + '0');
        num = num / 2;
        i++;
    }

    // invertendo o número binário
    for (int i = 0; i < num_bits; i++) {
        arr_out[i] = temp[num_bits - i - 1];
    }
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