.data
prompt_x: .asciiz "Enter the value of x: "  # Prompt for x
prompt_y: .asciiz "Enter the value of y: "  # Prompt for y
prompt_z: .asciiz "Enter the value of z: "  # Prompt for z
result_msg: .asciiz "Result (x - y - z): "  # Message for the result

.text
.globl main

main:
    # Display welcome message
    li $v0, 4
    la $a0, welcome_msg
    syscall

    # Input x
    li $v0, 4
    la $a0, prompt_x
    syscall
    li $v0, 5
    syscall
    move $t0, $v0  # Store x in $t0

    # Input y
    li $v0, 4
    la $a0, prompt_y
    syscall
    li $v0, 5
    syscall
    move $t1, $v0  # Store y in $t1

    # Input z
    li $v0, 4
    la $a0, prompt_z
    syscall
    li $v0, 5
    syscall
    move $t2, $v0  # Store z in $t2

    # Calculate x - y - z
    subu $t3, $t0, $t1   # $t3 = x - y
    subu $t3, $t3, $t2   # $t3 = (x - y) - z

    # Display the result in decimal
    li $v0, 4
    la $a0, result_msg
    syscall

    li $v0, 1
    move $a0, $t3
    syscall

    # Exit the program
    li $v0, 10
    syscall

.data
welcome_msg: .asciiz "Welcome to the integer subtraction program! Please enter 3 integers for x, y, and z to be subtracted from each other.\n"