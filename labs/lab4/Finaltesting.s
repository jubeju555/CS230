.globl compute_average
compute_average:
    # Prologue
    addi sp, sp, -16
    fsw fa0, 12(sp)          # Save fa0 (data pointer)
    sw a1, 8(sp)             # Save a1 (length)

    # Initialize total = 0.0
    fmv.s.x ft0, zero        # ft0 = total
    li t0, 0                 # t0 = index

loop_start:
    bge t0, a1, loop_end     # Exit loop if index >= length

    # Calculate address of data[i].value
    slli t1, t0, 2           # struct size = 4 bytes, index * 4
    add t2, a0, t1           # Address of data[i]
    flw ft1, 0(t2)           # Load data[i].value

    fadd.s ft0, ft0, ft1     # total += data[i].value
    addi t0, t0, 1           # index++

    j loop_start             # Jump to start of loop

loop_end:
    bnez a1, division        # If length > 0, perform division
    fmv.s.x fa0, zero        # Else, return 0.0
    j epilogue

division:
    fcvt.s.w ft1, a1         # Convert length to float
    fdiv.s fa0, ft0, ft1     # total / length

epilogue:
    # Epilogue
    flw fa0, 12(sp)          # Restore fa0 (return value)
    lw a1, 8(sp)             # Restore a1 (length)
    addi sp, sp, 16
    ret

