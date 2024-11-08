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
# compile: riscv64-unknown-linux-gnu-g++ -o lab5 lab5.s mud.cpp
# run ./lab5 mud.rooms

# look_at_room function to display room details
look_at_room:
    addi sp, sp, -16         # Allocate space on the stack
    sd ra, 0(sp)             # Save return address on the stack
    sd s0, 8(sp)             # Save s0 on the stack
    mv s0, a0                # Save a0 to s0

    ld a1, 0(s0)             # Load the room title
    ld a2, 8(s0)             # Load the room description

    la a0, exit_string       # Load format string for printf
    call printf              # Print title and description

    lw a2, 16(s0)            # Load the exits
    li a1, -1                # Initialize exit index
    beq a1, a2, n
    la a0, north             # Load exit string for north
    call printf              # Print exit string for north
n:

    lw a2, 20(s0)            # Load the exits
    li a1, -1                # Initialize exit index
    beq a1, a2, s            # Check if exits are available
    la a0, south             # Load exit string for south
    call printf              # Print exit string for south
s:

    lw a2, 24(s0)            # Load the exits
    li a1, -1                # Initialize exit index
    beq a1, a2, e            # Check if exits are available
    la a0, east              # Load exit string for east
    call printf              # Print exit string for east
e:

    lw a2, 28(s0)            # Load the exits
    li a1, -1                # Initialize exit index
    beq a1, a2, w            # Check if exits are available
    la a0, west              # Load exit string for west
    call printf              # Print exit string for west
w:

    la a0, new_line          # Load newline string
    call printf              # Print newline

    ld ra, 0(sp)             # Restore return address
    ld s0, 8(sp)             # Restore s0
    addi sp, sp, 16          # Deallocate stack space
    ret                      # Return from function

# look_at_all_rooms function to iterate over all rooms and display each one
look_at_all_rooms:
    li t0, 0                # Initialize room counter
    mv t1, a1               # Total number of rooms in t1

loop_rooms:
    bge t0, t1, loop_end    # Exit loop if all rooms displayed
    slli t2, t0, 3          # Calculate offset for the current room
    add t3, a0, t2          # Get address of the current room

    mv a0, t3               # Set a0 to point to the current room
    jal look_at_room        # Call look_at_room to display the room

    la a0, new_line         # Load newline address
    call printf             # Print newline after each room

    addi t0, t0, 1          # Increment room counter
    j loop_rooms            # Repeat loop for the next room

loop_end:
    ret                     # Return from function

# move_to function to navigate to a specified exit
move_to:
    slli t0, a2, 2          # Multiply exit index by 4 (size of int)
    add t0, a1, t0          # Calculate address of the exit's room ID
    lw t1, 0(t0)            # Load room ID from the calculated address

    li t2, -1               # Indicator for no exit
    beq t1, t2, return_null # If no exit, return null (0)

    slli t1, t1, 3          # Calculate address for the target room
    add a0, a0, t1          # Update sa0 with the room address
    # ret                     # Return target room address

return_null:
    li a0, 0                # Set return to null (0) if no exit is found
    ret                     # Return from function
