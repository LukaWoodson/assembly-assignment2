 .data
 ### --- Integers and Arrays
intArray:   .space      40
permArray:  .space      40
arraySize:  .word       5
loopCounter: .word      0

### --- Instruction Strings
welcome_message: .asciiz "Welcome! The program will calculate an array given array and the provided permutation.\n"
input_array_message: .asciiz "\nPlease enter the 5 array elements (one at a time)\n"
permutation_array_message: .asciiz "\nPlease enter the 5 unique permutation elements (one at a time)\n"

### --- User Prompts
prompt:     .asciiz     "\nPlease enter an integer value: "

### --- Results
input_array_result: .asciiz "\nYour array is: "
permutation_array_result: .asciiz "\nYour permutation array is: "
output_array_message: .asciiz "\nThe permuted array is: "

.text

### $t0 = arraySize
### $t1 = loop counter
### $t2 = intArray
### $t3 = permArray
main:
    ### ----------------------------------- #0 INITIALIZE VARIABLES IN MEMORY
    la $t0 arraySize #load arraySize in $t0
    la $t1 loopCounter #load loopCounter in $t1
    la $t2, intArray #load intArray in $t2
    la $t3, permArray #load permArray in $t3

    ### ----------------------------------- #1 DISPLAY WELCOME
    li $v0, 4
    la $a0, welcome_message
    syscall

    j inputMessage


### $t0 = arraySize
### $t1 = loop counter
### $t2 = intArray
intLoop:
    ### ----------------------------------- #1 PROMPT USER FOR INPUT
    la $a0, prompt
    li $v0, 4 # 4 - print string
    syscall
	
    ### ----------------------------------- #2 GET INPUT FROM USER AND STORE IN ARRAY
    li $v0, 5 # 5 - read integer
    syscall
    sw $v0, ($t2)
    
    ### ----------------------------------- #3 INCREMENT LOOP COUNTER
    addi $t2, $t2, 4 #move to next slot in intArray
    addi $t1, $t1, 1
 
    ### ----------------------------------- #4 LOOP UNTIL ALL ELEMENTS ARE ENTERED
    blt $t1, $t0, intLoop

    ### ----------------------------------- #5 RESET LOOP COUNTER AND LOAD ARRAY INTO $t2
    li $t1, 0 # reset loop counter
    la $t2, intArray
	
    ### ----------------------------------- #6 DISPLAY INPUT ARRAY RESULT
    lw $a0, ($t2) # ---------- CURRENTLY DISPLAYING 1ST ELEMENT -----------
    li $v0, 1  # 1 - print integer
    syscall

    j permMessage

### $t0 = arraySize
### $t1 = loop counter
### $t3 = permArray
permLoop:
    ### ----------------------------------- #1 PROMPT USER FOR INPUT
    la $a0, prompt
    li $v0, 4
    syscall
	
    ### ----------------------------------- #2 GET INPUT FROM USER AND STORE IN ARRAY
    li $v0, 5
    syscall
    sw $v0, ($t3)
    
    ### ----------------------------------- #3 INCREMENT LOOP COUNTER
    addi $t3, $t3, 4 #move to next slot in intArray
    addi $t1, $t1, 1
 
    ### ----------------------------------- #4 LOOP UNTIL ALL ELEMENTS ARE ENTERED
    blt $t1, $t0, permLoop

    ### ----------------------------------- #5 RESET LOOP COUNTER AND LOAD ARRAY INTO $t3
    li $t1, 0 # reset loop counter
    la $t3, permArray
	
    ### ----------------------------------- #6 DISPLAY INPUT ARRAY RESULT
    lw $a0, ($t3) # ---------- CURRENTLY DISPLAYING 1ST ELEMENT -----------
    li $v0, 1
    syscall

    j exit

inputMessage:
    ### ----------------------------------- #2 DISPLAY INPUT ARRAY INSTRUCTIONS
    li $v0, 4
    la $a0, input_array_message
    syscall

    ### ----------------------------------- #3 LOOP TO GET INPUT ARRAY
    lw $t0, arraySize  # Load the value of arraySize into $t0
    lw $t1, loopCounter # Load the value of loopCounter into $t1
    j intLoop	

permMessage:
    ### ----------------------------------- #10 DISPLAY PERMUTATION ARRAY INSTRUCTIONS
    li $v0, 4
    la $a0, permutation_array_message
    syscall

    ### ----------------------------------- #11 LOOP TO GET PERM ARRAY
    j permLoop

exit:
    ### ----------------------------------- #12 CALCULATE / PERMUTATE ARRAY
    # calculate

    ### ----------------------------------- #13 DISPLAY PERMUTED ARRAY
    # display

    ### ----------------------------------- #14 EXIT PROGRAM
    li $v0, 10 # 10 - exit program
    syscall

