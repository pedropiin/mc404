#define STDIN_FD 0
#define STDOUT_FD 1
#define MAX_IN_SIZE 30
#define MAX_OUT_SIZE 11
#define MAX_SIZE_INT_STRING 4
#define NUM_INTS 5
#define MAX_UNSIGNED_INT 4294967295
#define MASK(j) (1 << j)


void exit(int code) {
    __asm__ __volatile__(
        "mv a0, %0           # return code\n"
        "li a7, 93           # syscall exit (64) \n"
        "ecall"
        :             // Output list
        :"r"(code)    // Input list
        : "a0", "a7");
}

void _start() {
    int ret_code = main();
    exit(ret_code);
}

/* read
 * Parâmetros:
 *  __fd:  file descriptor do arquivo a ser lido.
 *  __buf: buffer para armazenar o dado lido.
 *  __n:   quantidade máxima de bytes a serem lidos.
 * Retorno:
 *  Número de bytes lidos.
 */
int read(int __fd, const void *__buf, int __n) {
    int ret_val;
    __asm__ __volatile__(
        "mv a0, %1           # file descriptor\n"
        "mv a1, %2           # buffer \n"
        "mv a2, %3           # size \n"
        "li a7, 63           # syscall read code (63) \n"
        "ecall               # invoke syscall \n"
        "mv %0, a0           # move return value to ret_val\n"
        : "=r"(ret_val)                   // Output list
        : "r"(__fd), "r"(__buf), "r"(__n) // Input list
        : "a0", "a1", "a2", "a7");
    return ret_val;
}

/* write
 * Parâmetros:
 *  __fd:  files descriptor para escrita dos dados.
 *  __buf: buffer com dados a serem escritos.
 *  __n:   quantidade de bytes a serem escritos.
 * Retorno:
 *  Número de bytes efetivamente escritos.
 */
void write(int __fd, const void *__buf, int __n) {
    __asm__ __volatile__(
        "mv a0, %0           # file descriptor\n"
        "mv a1, %1           # buffer \n"
        "mv a2, %2           # size \n"
        "li a7, 64           # syscall write (64) \n"
        "ecall"
        :                                 // Output list
        : "r"(__fd), "r"(__buf), "r"(__n) // Input list
        : "a0", "a1", "a2", "a7");
}

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

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

unsigned int to_dec(int* arr_nums) {
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
    char in[MAX_IN_SIZE], out[MAX_OUT_SIZE];
    int n = read(STDIN_FD, (void*)in, MAX_IN_SIZE);
    int nums[5];
    string_to_int(nums, in);
    unsigned int val = to_dec(nums);
    hex_code(val);

    /*
    converter num para inteiro
    se sinal = +
        continuar
    se sinal = -
        inverter sinal do numero
    
    pegar bits buscados de cada um
    */
    return 0;
}

// -0001 -0001 -0001 -0001 -0001
// 0   4 6  10 12 16 18 22 24 28