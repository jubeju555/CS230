# floatingpoint lab 
# judah benjamin 
# compiling: riscv64-unknown-linux-gnu-g++ -o floatingpoint floatingpoint.s lab3.cpp
# run: ./floatingpoint
.section .text
.global map

map:
    addi sp, sp, -32     #allocating stack    
    sd ra, 24(sp)        # saving return address     
    sd a0, 16(sp)        # saving value pointer      
    sd a1, 8(sp)              
    sd a2, 0(sp)              

    mv s3, a2                 
    mv s4, a1                 
    li s5, 1            # index starts at 1      

    fmv.d fs0, fa0            

1:
    bge s5, s4, 1f           # if statment  
    slli t0, s5, 3            # 2^3 = 8 (offset)
    ld t1, 16(sp)             # loading value pointer
    fld fa0, 0(t1)            

    fmv.d fa1, fs0            
    jalr s3                   

    fsd fa0, 0(t1)            

    addi s5, s5, 1            # index at 1
    j 1b                      # repeating loop

1:
    ld ra, 24(sp)            # restore return address 
    ld a0, 16(sp)            #restore value pointer 
    ld a1, 8(sp)              
    ld a2, 0(sp)              
    addi sp, sp, 32          # deallocate stack pointer 

    ret                        

.global map_add
map_add:
    flw f0, 0(a0)             
    flw f1, 0(a1)             
    fadd.s f0, f0, f1         
    fsw f0, 0(a2)             
    ret

.global map_sub
map_sub:
    flw f0, 0(a0)             
    flw f1, 0(a1)             
    fsub.s f0, f0, f1         
    fsw f0, 0(a2)             
    ret

.global map_min
map_min:
    flw f0, 0(a0)             
    flw f1, 0(a1)             
    fmin.s f0, f0, f1         
    fsw f0, 0(a2)             
    ret

.global map_max
map_max:
    flw f0, 0(a0)             
    flw f1, 0(a1)             
    fmax.s f0, f0, f1         
    fsw f0, 0(a2)             
    ret