 .data
welcome_message: .asciiz "Welcome! This program permutates an array of any size.\n\n"
input_size_message: .asciiz "Please enter the size of the array: "
input_array_message: .asciiz "Please enter the elements of your array (separated by spaces): "

.text
.globl main

main:
    # Display welcome message
    li $v0, 4
    la $a0, welcome_message
    syscall

    # Prompt for the size of the array and read it
    li $v0, 4
    la $a0, input_size_message
    syscall
    li $v0, 5
    syscall
    move $t0, $v0

    # Allocate space for the array in memory (4 bytes per integer)
    sll $t1, $t0, 2  # Calculate the space required
    li $v0, 9
    move $a0, $t1
    syscall
    move $t2, $v0  # Store the address of the array in $t2

    # Read the elements of the array
    la $a0, input_array_message
    move $a1, $t2  # Pass the address of the array
    move $a2, $t0  # Pass the size of the array
    jal readArray

    # Exit the program
    li $v0, 10
    syscall

# Read and store integers from input string
readArray:
    # $a0 - prompt message
    # $a1 - array address
    # $a2 - size
    li $v0, 4
    syscall
    li $v0, 8
    move $a1, $a0
    move $a0, $a2  # Size
    syscall
    move $t3, $a1  # Save the address of the input string
    li $t4, 0
    li $t5, 0

readArrayLoop:
    lb $t6, ($t3)  # Load a character from the input string
    beqz $t6, readArrayEnd  # End of input string
    beq $t6, 32, skipSpace  # Skip spaces
    mul $t5, $t5, 10
    subi $t6, $t6, 48
    add $t5, $t5, $t6  # Update the integer value
    j continueLoop

skipSpace:
    beqz $t5, continueLoop
    sw $t5, ($a1)  # Store the integer in the array
    addi $a1, $a1, 4
    li $t5, 0

continueLoop:
    addi $t3, $t3, 1
    j readArrayLoop

readArrayEnd:
    sw $t5, ($a1)  # Store the last integer in the array
    jr $ra