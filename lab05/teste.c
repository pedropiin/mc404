#define STDIN_FD 0
#define STDOUT_FD 1
#define MAX_IN_SIZE 30
#define MAX_OUT_SIZE 11
#define MAX_SIZE_INT_STRING 4
#define NUM_INTS 5
#define MAX_UNSIGNED_INT 4294967295
#define MASK(j) (1 << j)

#include <stdio.h>


int get_bit(int num, int i_bit) {
    return ((num & MASK(i_bit)) == 0) ? 0 : 1;
}

unsigned int power(int base, int expoente) {
    unsigned int result = 1;
    while (expoente > 0) {
        result = result * base;
        expoente--;
    }
    if ((result - 1) >= MAX_UNSIGNED_INT) {
        return MAX_UNSIGNED_INT;
    }
    return result;
}

int my_atoi(char* num_str) {
    int result = 0;
    int i = 0, tamanho = 4;
    for (int i = 0; i < tamanho; i++) {
        result = result * 10 + (num_str[i] - '0');
    }
    return result;
}

void string_to_int(int* arr_nums, char* in) {
    char temp[MAX_SIZE_INT_STRING];
    int num_it, count_nums = 0;
    for (int i = 0; i < NUM_INTS; i++) {
        for (int j = 0; j < MAX_SIZE_INT_STRING; j++) {
            temp[j] = in[i * (1 + NUM_INTS) + 1 + j];
        }
        num_it = my_atoi(temp);
        if (in[i * (1 + NUM_INTS)] == '-') {
            num_it += num_it * (-2);
        }
        arr_nums[count_nums] = num_it;
        count_nums++;
    }
}

int solve(int* arr_nums) {
    for (int i = 0; i < 5; i++) {
        printf("o num de indice %d é %d\n", i, arr_nums[i]);
    }
    unsigned int val = 0;
    int quant_bits_num[] = {5, 7, 9, 4, 7}, num_bits_i, count = 31;
    for (int i = 4; i >= 0; i--) {
        num_bits_i = quant_bits_num[i];
        for (int j = num_bits_i - 1; j >= 0; j--) {
            val += get_bit(arr_nums[i], j) * power(2, count);
            count--;
        }
    }
    return val;
}

int main(int argc, char* argv[]) {
    char in[MAX_IN_SIZE], out[MAX_OUT_SIZE + 1];
    fgets(in, 30, stdin);
    int nums[5];
    string_to_int(nums, in);
    unsigned int val = solve(nums);
    printf("%u\n", val);

    /*
    int arr_indices[] = {5, 7, 9, 4, 7}
    do último ao primeiro num
        num_bits = arr_indices[num_atual]
        for in num_bits
            pegar bit 32 - num_bits + j
            colocar na pos i_string
    */
    return 0;
}

// -0001 -0001 -0001 -0001 -0001
// 0   4 6  10 12 16 18 22 24 28