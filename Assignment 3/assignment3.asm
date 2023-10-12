.data
welcome_message: .asciiz "Welcome! This program permutates an array of any size.\n"
input_size_message: .asciiz "Please enter the size of the array: "
input_array_message: .asciiz "Please enter the elements of your array (separated by spaces): "
input_permutation_message: .asciiz "Please enter the permutation (separated by spaces): "
result_message: .asciiz "The array after permutation is: "

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

    # Allocate space for the array and permutation in memory
    # Size * 4 bytes for each array
    sll $t1, $t0, 2
    li $v0, 9
    move $a0, $t1
    syscall
    move $t2, $v0  # Store the address of the array in $t2

    # Read the elements of the array
    la $a0, input_array_message
    move $a1, $t2  # Pass the address of the array
    move $a2, $t0  # Pass the size of the array
    jal readArray

    # Read the permutation
    la $a0, input_permutation_message
    move $a1, $t2  # Pass the address of the permutation array
    move $a2, $t0  # Pass the size of the permutation array
    jal permuteArray

    # Display the result message
    li $v0, 4
    la $a0, result_message
    syscall

    # Display the permuted array
    move $a0, $t2  # Pass the address of the array
    move $a1, $t0  # Pass the size of the array
    jal printArray

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

# Permute the array based on the input permutation
permuteArray:
    # $a0 - prompt message
    # $a1 - permutation address
    # $a2 - size
    li $v0, 4
    syscall
    li $v0, 8
    move $a1, $a0
    move $a0, $a2  # Size
    syscall
    move $t6, $a1  # Save the address of the input permutation
    li $t7, 0
    li $t8, 0

permuteArrayLoop:
    lb $t9, ($t6)  # Load a character from the input permutation
    beqz $t9, permuteArrayEnd  # End of input permutation
    beq $t9, 32, skipSpacePerm  # Skip spaces
    mul $t8, $t8, 10
    subi $t9, $t9, 48
    add $t8, $t8, $t9  # Update the integer value
    j continueLoopPerm

skipSpacePerm:
    beqz $t8, continueLoopPerm
    sw $t8, ($a1)  # Store the integer in the permutation array
    addi $a1, $a1, 4
    li $t8, 0

continueLoopPerm:
    addi $t6, $t6, 1
    j permuteArrayLoop

permuteArrayEnd:
    sw $t8, ($a1)  # Store the last integer in the permutation array
    jr $ra

# Print the permuted array
printArray:
    # $a0 - array address
    # $a1 - size
    li $t3, 0
    lw $t4, ($a1)  # Load the size of the array

printArrayLoop:
    beq $t3, $t4, printArrayEnd
    lw $t5, ($a0)
    li $v0, 1
    move $a0, $t5
    syscall
    addi $a0, $a0, 4
    addi $t3, $t3, 1

    # Check if $t3 is within the bounds of the array
    blt $t3, $t4, printArrayLoop

printArrayEnd:
    jr $ra
