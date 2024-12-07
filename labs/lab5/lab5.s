.section .rodata 
exit_string: .asciz "%s\n%s\nExits: "
new_line: .asciz "\n"
north: .asciz "n "
south: .asciz "s "
east: .asciz "e "
west: .asciz "w "
.section .text
.global look_at_room
.global look_at_all_rooms
.global move_to
# judah benjamin
# mud lab
# jbenjam7
# room based dungeon crawler
# compile: riscv64-unknown-linux-gnu-g++ -o lab5 lab5.s mud.cpp
# run ./lab5 mud.rooms

# display room details
look_at_room:
    addi sp, sp, -16         
    sd ra, 0(sp)             # Save return address on the stack
    sd s0, 8(sp)             # Save s0 on the stack
    mv s0, a0                # Save a0 to s0

    ld a1, 0(s0)             # Load the room title
    ld a2, 8(s0)             # Load the room description

    la a0, exit_string       # Load format string for printf
    call printf              # Print title and description

    lw a2, 16(s0)            
    li a1, -1                
    beq a1, a2, n
    la a0, north             
    call printf              
n:
    lw a2, 20(s0)            # Load the exits
    li a1, -1                # Initialize exit index
    beq a1, a2, e            # Check if exits are available
    la a0, east              # Load exit string for direction 
    call printf              # Print exit string for direction
e:
    lw a2, 24(s0)            
    li a1, -1                
    beq a1, a2, s            
    la a0, south             
    call printf              
s:


    lw a2, 28(s0)            
    li a1, -1                
    beq a1, a2, w            
    la a0, west              
    call printf              
w:

    la a0, new_line          # Load newline string
    call printf              

    ld ra, 0(sp)             # Restore return address
    ld s0, 8(sp)             
    addi sp, sp, 16          
    ret                     

#  iterate over all rooms and display each one
look_at_all_rooms:
    li s2, 0                # Initialize room counter
    mv s1, a1               # Total number of rooms in t1
    mv s0, a0               # Save the base address of rooms in s0


loop_rooms:
    bge s2, s1, loop_end    # Exit loop if all rooms displayed
    slli t2, s2, 5          # offset for the current room
    add t3, s0, t2          # address of the current room

    mv a0, t3               # Set a0 to point to the current room
    jal look_at_room        # display the room

    la a0, new_line         # Load newline address
    call printf             # Print newline after each room

    addi s2, s2, 1          # Increment room counter
    j loop_rooms            # Repeat loop for the next room

loop_end:
    ret                     

# navigate to a specified exit
move_to:
    slli t0, a2, 2          # index by 4 (size of int) to get the offset
    addi t1, a1, 16          # address of the exit's room ID
    add t0, t1, t0          # Add the exit index offset to the base address of exits
    lw t1, 0(t0)            # Load room from the calculated address
    
    
    li t2, -1               
    beq t1, t2, return_null 

    slli t1, t1, 5          # address for the target room
    add a0, a0, t1          # Update sa0 with room address

     ret                   

return_null:
    li a0, 0                # Set return to null (0) if no exit is found
    ret                     
