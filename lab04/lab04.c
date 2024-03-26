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

int power(int base, int expoente) {
    int result = 1;
    while (expoente > 0) {
        result = result * base;
        expoente--;
    }
    return result;
}

int tamanho_string(char* str) {
    int i;
    for (i = 0; str[i] != '\n'; i++);
    return i;
}

int my_atoi(char* arr) {
    int result = 0, i = 0, tamanho = tamanho_string(arr);
    for (int i = 0; i < tamanho; i++) {
        result = result * 10 + (arr[i] - '0');
    }
    return result;
}

int count_num_bits(char* arr_num) {
    int num = my_atoi(arr_num), n = 0;
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

int dec_to_bin(char* arr_in, char* arr_out) {
    int num_bits = count_num_bits(arr_in), num = my_atoi(arr_in), i = 0;
    char temp[num_bits];
    while (num > 0) {
        temp[i] = (char)((num % 2) + '0');
        num = num / 2;
        i++;
    }

    // ajustando para reperesntação binária
    int padrao_bin = 2;
    arr_out[0] = '0';
    arr_out[1] = 'b';
    // invertendo o número binário
    for (int i = 0; i < num_bits; i++) {
        arr_out[i + padrao_bin] = temp[num_bits - i - 1];
    }
    arr_out[num_bits + padrao_bin] = '\n';
    return num_bits + 1 + padrao_bin;
}

int dec_to_hex(char* arr_in, char* arr_out) {
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

    //ajustando para reperesntação hexadecimal
    int padrao_hex = 2;
    arr_out[0] = '0';
    arr_out[1] = 'x';
    //invertendo o número hexadecimal
    for (int i = 0; i < num_digitos; i++) {
        arr_out[i + padrao_hex] = temp[num_digitos - i - 1];
    }
    arr_out[num_digitos + padrao_hex] = '\n';
    return num_digitos + 1 + padrao_hex;
}

int main(int argc, char* argv[]) {
    char in_buf[MAX_INPUT_SIZE], out_buf[MAX_OUT_SIZE];
    int n = read(STDIN_FD, (void*)in_buf, MAX_INPUT_SIZE), tamanho_out_buf;
    if (in_buf[0] == '0') {
        ;
    } else {
        tamanho_out_buf = dec_to_hex(in_buf, out_buf);
    }
    write(STDOUT_FD, (void*)out_buf, tamanho_out_buf);
}