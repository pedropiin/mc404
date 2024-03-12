arq1.s: arq1.c
	clang-17 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax arq1.c -S -o arq1.s

arq2.s: arq2.c
	clang-17 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax arq2.c -S -o arq2.s

arq1.o: arq1.s
	clang-17 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax arq1.s -c -o arq1.o

arq2.o: arq2.s
	clang-17 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax arq2.s -c -o arq2.o

prog.x: arq1.o arq2.o
	ld.lld arq1.o arq2.o -o prog.x