# compile: riscv64-unknown-linux-gnu-g++ -o lab4 lab4.s triangle.cpp -lm
# run: ./lab4



fdiv.s      fa0, fa0, fs1       # fa0 = fa0 / fs1
call        asinf               # fa0 = asinf(fa0)
fsw         fa0, 12(s0)         # rt.theta0 = asinf(fa0)