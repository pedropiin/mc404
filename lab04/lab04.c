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

int which_power(int base, int num) {
    int result = 1, i = 0;
    while (result != num) {
        result = result * base;
        i++;
    }
    return i;
}

int tamanho_string(char* str) {
    int i;
    for (i = 0; str[i] != '\n'; i++);
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

void copy_string(char* src, char* copy) {
    int tamanho = tamanho_string(src);
    for (int i = 0; i < tamanho; i++) {
        copy[i] = src[i];
    }
    copy[tamanho] = '\n';
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

int count_num_bits(char* arr_num) {
    int num = my_atoi(arr_num), n = 0;
    while (power(2, n) <= num) {
        n++;
    }
    return n;
}

int dec_to_base(char* arr_in, char* arr_out, int base) {
    if (arr_in[0] != '-') { //caso positivo
        int num_bits = count_num_bits(arr_in), potencia = which_power(2, base);
        int num_digitos = ((num_bits % potencia) == 0) ? (num_bits / potencia) : ((num_bits / potencia) + 1);
        // int num_digitos = (count_num_bits(arr_in) / which_power(2, base)) + 1;
        int num = my_atoi(arr_in), i = 0, resto;
        char temp[num_digitos];
        while (num > 0) {
            resto = num % base;
            if (resto <= 9) {
                temp[i] = (char)(resto + '0');
            } else {
                temp[i] = (char)(resto + 'a' - 10);
            }
            num = num / base;
            i++;
        }

        int num_chars_padrao= 2;
        switch (base) {
            case 2:
                arr_out[0] = '0';
                arr_out[1] = 'b';
                break;
            case 8:
                arr_out[0] = '0';
                arr_out[1] = 'o';
                break;
            case 16:
                arr_out[0] = '0';
                arr_out[1] = 'x';
                break;
        }

        for (i = 0; i < num_digitos; i++) {
            arr_out[i + num_chars_padrao] = temp[num_digitos - i - 1];
        }
        arr_out[num_digitos + num_chars_padrao] = '\n';
        return num_digitos + 1 + num_chars_padrao;
    } else { //caso negativo
        arr_in++;
        int num_bits = count_num_bits(arr_in), potencia = which_power(2, base);
        int num_digitos = ((num_bits % potencia) == 0) ? (num_bits / potencia) : ((num_bits / potencia) + 1);
        // int num_digitos = (count_num_bits(arr_in) / which_power(2, base)) + 1;
        int num = my_atoi(arr_in), i = 0, resto;
        char temp[num_digitos];
        while (num > 0)
        {
            resto = num % base;
            if (resto <= 9)
            {
                temp[i] = (char)(resto + '0');
            }
            else
            {
                temp[i] = (char)(resto + 'a' - 10);
            }
            num = num / base;
            i++;
        }

        int num_chars_padrao = 2;
        switch (base)
        {
        case 2:
            arr_out[0] = '0';
            arr_out[1] = 'b';
            break;
        case 8:
            arr_out[0] = '0';
            arr_out[1] = 'o';
            break;
        case 16:
            arr_out[0] = '0';
            arr_out[1] = 'x';
            break;
        }

        for (i = 0; i < num_digitos; i++)
        {
            arr_out[i + num_chars_padrao] = temp[num_digitos - i - 1];
        }
        arr_out[num_digitos + num_chars_padrao] = '\n';
        arr_in--;
        return num_digitos + 1 + num_chars_padrao;
    }
}

int base_to_dec(char* arr_in, char* arr_out, int base) {
    int tamanho_in = tamanho_string(arr_in), count = 0, val = 0, tamanho_out;
    for (int i = tamanho_in - 1; i > 1; i--) {
        if (arr_in[i] >= 'a' && arr_in[i] <= 'f') {
            val += (int)(arr_in[i] - 'a' + 10) * power(base, count);
        } else {
            val += (int)(arr_in[i] - '0') * power(base, count);
        }
        count++;
    }
    tamanho_out = my_itoa(arr_out, val, 10);
    return tamanho_out + 1;
}

int bin_to_comp2(char* arr) {
    int tamanho = tamanho_string(arr), padrao_bin = 2;
    char temp[MAX_OUT_SIZE];
    temp[0] = '0';
    temp[1] = 'b';
    int complemento = 32 - (tamanho - padrao_bin);
    for (int i = 0; i < complemento; i++) {
        temp[i + padrao_bin] = '1';
    }
    for (int i = 0; i < (tamanho - padrao_bin); i++) {
        if (arr[i + padrao_bin] == '1') {
            temp[i + complemento + padrao_bin] = '0';
        } else {
            temp[i + complemento + padrao_bin] = '1';
        }
    }
    for (int i = 0; i < 34; i++) {
        arr[i] = temp[i];
    }

    if (arr[33] == '0') {
        arr[33] = '1';
    } else {
        int i = 33;
        while (arr[i] == '1') {
            arr[i] = '0';
            i--;
        }
        arr[i] = '1';
    }
    arr[34] = '\n';
    return MAX_OUT_SIZE;
}

int switch_endianness(char* arr) {
    int tamanho = tamanho_string(arr), padrao_bin = 2, complemento = 32 - (tamanho - padrao_bin);
    char temp[MAX_OUT_SIZE];
    temp[0] = '0';
    temp[1] = 'b';
    for (int i = 0; i < complemento; i++) {
        temp[i + padrao_bin] = '0';
    }
    for (int i = 0; i < (tamanho - padrao_bin); i++) {
        temp[i + complemento + padrao_bin] = arr[i + padrao_bin];
    }
    int count = 0;
    for (int i = 3; i >= 0; i--) {
        for (int j = 0; j < 8; j++) {
            arr[count + padrao_bin] = temp[((i * 8) + j) + padrao_bin];
            count++;
        }
    }
    arr[34] = '\n';
    return MAX_OUT_SIZE;
}

int main(int argc, char* argv[]) {
    char in_buf[MAX_INPUT_SIZE], out_buf[MAX_OUT_SIZE];
    int n = read(STDIN_FD, (void*)in_buf, MAX_INPUT_SIZE), tamanho_out_buf;
    if (in_buf[1] == 'x') { // input em base hexadecimal
        char dec_buf[MAX_OUT_SIZE];
        tamanho_out_buf = base_to_dec(in_buf, dec_buf, 16); //convertendo para decimal
        tamanho_out_buf = dec_to_base(dec_buf, out_buf, 2); //convertendo para binário
        write(STDOUT_FD, (void*)out_buf, tamanho_out_buf); //base binária

        write(STDOUT_FD, (void*)dec_buf, tamanho_string(dec_buf) + 1); //base decimal

        tamanho_out_buf = switch_endianness(out_buf);
        char temp[MAX_OUT_SIZE];
        copy_string(out_buf, temp);
        tamanho_out_buf = base_to_dec(temp, out_buf, 2);
        write(STDOUT_FD, (void*)out_buf, tamanho_out_buf);
        
        write(STDOUT_FD, (void*)in_buf, tamanho_string(in_buf) + 1); //base hexadecimal

        tamanho_out_buf = dec_to_base(dec_buf, out_buf, 8);
        write(STDOUT_FD, (void*)out_buf, tamanho_out_buf); //base octal

    } else {
        if (in_buf[0] != '-') { // input em base decimal positivo
            tamanho_out_buf = dec_to_base(in_buf, out_buf, 2);
            write(STDOUT_FD, (void *)out_buf, tamanho_out_buf); // base binária

            write(STDOUT_FD, (void *)in_buf, n); //base decimal

            tamanho_out_buf = switch_endianness(out_buf);
            char temp[MAX_OUT_SIZE];
            copy_string(out_buf, temp);
            tamanho_out_buf = base_to_dec(temp, out_buf, 2);
            write(STDOUT_FD, (void*)out_buf, tamanho_out_buf);

            tamanho_out_buf = dec_to_base(in_buf, out_buf, 16);
            write(STDOUT_FD, (void *)out_buf, tamanho_out_buf); //base hexadecimal

            tamanho_out_buf = dec_to_base(in_buf, out_buf, 8);
            write(STDOUT_FD, (void *)out_buf, tamanho_out_buf); //base octal

        } else { // input em base decimal negativo
            tamanho_out_buf = dec_to_base(in_buf, out_buf, 2);
            tamanho_out_buf = bin_to_comp2(out_buf);
            write(STDOUT_FD, (void*) out_buf, tamanho_out_buf);

            write(STDOUT_FD, (void*)in_buf, tamanho_out_buf);

            tamanho_out_buf = switch_endianness(out_buf);
            char temp[MAX_OUT_SIZE];
            copy_string(out_buf, temp);
            tamanho_out_buf = base_to_dec(temp, out_buf, 2);
            write(STDOUT_FD, (void*)out_buf, tamanho_out_buf);

            tamanho_out_buf = dec_to_base(in_buf, out_buf, 2);
            tamanho_out_buf = bin_to_comp2(out_buf);
            tamanho_out_buf = base_to_dec(out_buf, temp, 2);
            tamanho_out_buf = dec_to_base(temp, out_buf, 16);
            write(STDOUT_FD, (void*)out_buf, tamanho_out_buf);

            tamanho_out_buf = dec_to_base(in_buf, out_buf, 8);
            write(STDOUT_FD, (void*) out_buf, tamanho_out_buf);
        }
    }

    return 0;
}



//10010000 10101100 11110111 11111111
//                          '24'-'31'