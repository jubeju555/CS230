    .data
format_string: .asciz "Count: %d\n"

    .text
    .globl count_greater_than

count_greater_than:

li t0, 0
li t1, 0

beginloop:

