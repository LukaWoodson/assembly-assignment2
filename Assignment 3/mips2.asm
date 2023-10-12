.data
welcome_message: .asciiz "Welcome! This program permutates an array of any size.\n \n"
input_size_message: .asciiz "Please enter the size of the array: "

.text
.globl main

main:
    # Display welcome message
    li $v0, 4
    la $a0, welcome_message
    syscall

    # Prompt the user to enter the size of the array
    li $v0, 4
    la $a0, input_size_message
    syscall

    # Read the integer (size) entered by the user
    li $v0, 5
    syscall
    
      # Store the size in $t0 (assuming $t0 is available for temporary storage)
    move $t0, $v0  # $t0 = size of the array

    # Calculate the space required for the arrays based on the size
    mul $t1, $t0, 4  # $t1 = size * 4 (4 bytes per integer)

    # Now you have the size of the array, and you can use it for further operations.

    # Exit the program
    li $v0, 10
    syscall
