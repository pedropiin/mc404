#define STDIN_FD 0
#define STDOUT_FD 1

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

int main() {
    char in_buf[6];
    char out_buf[6];
    for (int i = 0; i < 5; i++) {
        out_buf[i] = ' ';
    }
    out_buf[5] = '\n';

    int n = read(STDIN_FD, (void*) in_buf, 6);

    switch (in_buf[2]) {
        case '+':
            out_buf[2] = ((in_buf[0] - '0') + (in_buf[4] - '0')) + '0';
            break;
        case '-':
            out_buf[2] = ((in_buf[0] - '0') - (in_buf[4] - '0')) + '0';
            break;
        case '*':
            out_buf[2] = ((in_buf[0] - '0') * (in_buf[4] - '0')) + '0';
            break;
    }

    write(STDOUT_FD, (void*) out_buf, n);
}