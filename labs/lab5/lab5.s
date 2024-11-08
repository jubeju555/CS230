# .section .rodata 
# exit_string: .asciz "%s\n%s\nExits: "
# new_line: .asciz "\n"

# .section .text
# .global look_at_room
# .global look_at_all_rooms
# .global move_to

# # compile: riscv64-unknown-linux-gnu-g++ -o lab5 lab5.s mud.cpp
# # run ./lab5 mud.rooms

# # look_at_room function to display room details
# look_at_room:
#     addi sp, sp, -8        
#     sd ra, 0(sp)            # Save return address 

#     ld a1, 0(a0)            #  room title
#     ld a2, 8(a0)            # room description
#     la a0, exit_string      #  format string for printf
#     call printf             #  title and description

#     la a0, new_line         #  newline string
#     call printf             

#     ld ra, 0(sp)            # Restore return address
#     addi sp, sp, 8          
#     ret                     

# # look_at_all_rooms function to iterate over all rooms and display each one
# look_at_all_rooms:
#     li t0, 0                #  room counter
#     mv t1, a1               # Total number of rooms in t1

# loop_rooms:
#     bge t0, t1, loop_end    # Exit loop if all rooms displayed
#     slli t2, t0, 3          #  offset for the current room
#     add t3, a0, t2          #  address of the current room

#     mv a0, t3               # Set a0 to point to the current room
#     jal look_at_room        # Call look_at_room to display the room

#     la a0, new_line         # Load newline address
#     call printf             # Print newline after each room

#     addi t0, t0, 1          # Increment room counter
#     j loop_rooms            # Repeat loop for the next room

# loop_end:
#     ret                     # Return from function

# # move_to function to navigate to a specified exit
# move_to:
#     mv a0, a1                 # Move room base address to a0 

#     slli t0, a2, 2            # Multiply exit index by 4 (size of int)
#     add t0, a1, t0            # Add the exit index offset to the base address of exits
#     lw t1, 0(t0)              # Load the next room ID from the exit list

#     mv a0, t1                 # Move room ID to a0 for printing
#     la a1, exit_string        # Load format string for printing (optional)
#     call printf               # Print the room ID

#     li t2, -1                 # Indicator for no exit
#     beq t1, t2, return_null   # If the room ID is -1, return null (no exit)
#     mv a0, t1                 # Move room ID to a0
#     add a0, a0, t1            # Add the offset to the base address of rooms

#     # Debugging: Print the new room address calculated
#     mv a0, a0                 # Move the new room address to a0 for printing
#     la a1, exit_string        # Load format string for printing (optional)
#     call printf               # Print the new calculated room address

#     ret                       # Return with the updated address of the next room

# return_null:
#     # Calculate the new room address
#     slli t1, t1, 3            # Multiply the room ID by 8 (size of room in memory)
#     add a0, a0, t1            # Add the offset to the base address of rooms


 .section .rodata 
exit_string: .asciz "%s\n%s\nExits: "
new_line: .asciz "\n"

.section .text
.global look_at_room
.global look_at_all_rooms
.global move_to

# compile: riscv64-unknown-linux-gnu-g++ -o lab5 lab5.s mud.cpp
# run ./lab5 mud.rooms

# look_at_room function to display room details
look_at_room:
    addi sp, sp, -8         # Allocate space on the stack
    sd ra, 0(sp)            # Save return address on the stack

    ld a1, 0(a0)            # Load the room title
    ld a2, 8(a0)            # Load the room description
    la a0, exit_string      # Load format string for printf
    call printf             # Print title and description

    la a0, new_line         # Load newline string
    call printf             # Print newline

    ld ra, 0(sp)            # Restore return address
    addi sp, sp, 8          # Deallocate stack space
    ret                     # Return from function

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
    add a0, a0, t1          # Update a0 with the room address
    ret                     # Return target room address

return_null:
    li a0, 0                # Set return to null (0) if no exit is found
    ret                     # Return from function
