.section .rodata
exit_string: .asciz "%s\n%s\nExits: "
new_line: .asciz "\n"

.section .text
.global look_at_room

# compile: riscv64-unknown-linux-gnu-g++ -o lab5 lab5.s mud.cpp
# run ./lab5 mud.rooms
look_at_room:
    #  ...
addi sp, sp, -8
sd ra, 0(sp)

ld a1, 0(a0) # Load the title
ld a2, 8(a0) # Load the description
la a0, exit_string
call printf

ret

la a0, new_line
call printf

li t0, 0

# printf:
#     la      a0, exit_string       # Load the address of exit_string into a0
#     ld      a1, 0(a0)             # Load the title (assuming title is at offset 0)
#     ld      a2, 8(a0)             # Assuming the description field is at offset 8
#     call    printf

look_at_all_rooms:
li t0, 0
mv t1, a1

  

1:
bge t0, t1, loop_end
slli t2, t0, 3
add t3, a0, t2

mv a0, t3
jal ra, look_at_room

la, a0, new_line

jal ra, printf
addi t0, t0, 1
j   1b
1:


move_to:
slli t0, a2, 2
add t0, a1, t0 # t0 = t1 + t2
lw t1, 0

li ti, -1
beq t1, t2, return_null

slli t1, t1, 3
add a0, a0, t1
jr ra


  