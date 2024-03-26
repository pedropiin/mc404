#define STDIN_FD 0
#define STDOUT_FD 1
#define MAX_INPUT_SIZE 11
#define MAX_OUT_SIZE 35


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

int power(int num, int n) {
    int result = num;
    for (int i = 0; i < (n - 1); i++) {
        result *= num;
    }
    return result;
}

int my_atoi(char* arr) {
    int result = 0;
    for (int i = 0; arr[i] != '\n'; i++) {
        result = (result * 10) + arr[i] - '0';
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
    int num_bits = count_num_bits(arr_in);
    int num = my_atoi(arr_in);
    int resto, i = 1, quociente = (num / 2);

    while (quociente != 0) {
        resto = quociente % 2;
        quociente = quociente / 2;
        arr_out[num_bits - i] = (char)(resto + '0');
        i++;
    }
}

void dec_to_hex(char *arr_out, char* arr_in) {
    int num_bits = count_num_bits(arr_in);
    num_bits = num_bits / 4;
    int num = my_atoi(arr_in);
    int resto, i = 1, quociente = (num / 16);

    while (quociente != 0) {
        resto = quociente % 16;
        quociente = quociente / 16;
        arr_out[num_bits - i] = (char)(resto + '0');
        i++;
    }
}

int main(int argc, char* argv[]) {
    char in_buf[MAX_INPUT_SIZE];
    char out_buf[MAX_OUT_SIZE];

    int n = read(STDIN_FD, (void*)in_buf, MAX_INPUT_SIZE);
    if (in_buf[0] == '0') {
        ;
    } else {
        dec_to_bin(out_buf, in_buf);
    }
    write(STDOUT_FD, (void*)out_buf, MAX_OUT_SIZE);
}