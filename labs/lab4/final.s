    .section .data
    .section .text
    .globl find
    # compile riscv-g++ -o final final.s /home/smarz1/courses/cosc230/fa2024/final.cpp
    # run ./final /home/smarz1/courses/cosc230/fa2024/test
   
    # ill be needing therapy over the break
   
    # Function arguments:
    # a0 = pointer to array
    # a1 = number of elements (num_values)
    # a2 = pointer to key (char *)
    
find:
    # stack
    addi sp, sp, -16    # Allocate stack space
    sw ra, 12(sp)       # Save return address
    sw s0, 8(sp)        # Save frame pointer

    addi s0, sp, 16  # Set frame pointer

    li t0, 0                
    li s9, 21              
loop_start:

    bge t0, a1, notfound   # If index >= num_values, key not found

    # calc address of array key
    slli t1, t0, 5   #  32 bytes 8 long 24 char
    add t2, a0, t1   
    add t3, t2, 8   

    # Compare array key with key
    mv t4, a2   
    li t5, 0    # character index

compareloop:
 # cannot figure out where the seg fault is for the love of god
    lbu t6, 0(t3)  # byte

    lbu t0, 0(t4)   # byte key

    beq t6, t0, next # If characters match, continue 

    bne t6, zero, notequal # If characters differ, not a match

    bne t0, zero, notequal # If key ends but array key doesn't, not a match
    j match                 # If both end, it's a match

next:
# move everything one, moving to the next index
    addi t3, t3, 1   
    addi t4, t4, 1  
    addi t5, t5, 1   
    blt t5, t3, compareloop # go back into compare loop

notequal:
    # not equal move one down and keep going
    addi t0, t0, 1  
    j loop_start   
notfound:
    mv a0, a1  # Return num_values 
match:
    mv a0, t0 # Return index in a0 (matched key)
    j exit
exit:
    # deallocate stack
    lw ra, 12(sp) # return address
    lw s0, 8(sp)  # frame pointer
    addi sp, sp, 16 
    ret                     
