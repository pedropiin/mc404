#include <stdio.h>

int power(int num, int n) {
    int result = num;
    for (int i = 0; i < (n - 1); i++) {
        result *= num;
    }
    return result;
}

int my_atoi(char* arr) {
    int result = 0, i = 0;
    for (int i = 0; i < 4; i++) {
        result = result * 10 + (arr[i] - '0');
    }

    printf("meu resultado de myatoi é %d\n", result);
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

void dec_to_bin(char arr_out[], char arr_in[]) {
    int num_bits = count_num_bits(arr_in);
    int num = my_atoi(arr_in);
    printf("O meu número é %d\n", num);
    int resto, i = 1, quociente = (num / 2);
    while (quociente != 0) {
        resto = quociente % 2;
        printf("O quociente é %d e o resto é %d\n", quociente, resto);
        quociente = quociente / 2;
        arr_out[num_bits - i] = (char)(resto + '0');
        i++;
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
    printf("%s", out_buf);
}