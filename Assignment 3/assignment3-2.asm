 .data
 ### --- Integers and Arrays
intArray:   .space      40
permArray:  .space      40
arraySize:  .word       10
loopCounter: .word      1

### --- Instruction Strings
welcome_message: .asciiz "Welcome! The program will permutate a given array using the provided permutation.\n"
input_array_message: .asciiz "\nPlease enter the 10 array elements (one at a time)\n"
permutation_array_message: .asciiz "\nPlease enter the 10 unique permutation elements (one at a time)\n"

### --- User Prompts
prompt_p1:     .asciiz     "Please enter an integer "
prompt_p2:     .asciiz     " value: "

### --- Results
input_array_result: .asciiz "\nYour array is: "
permutation_array_result: .asciiz "\nYour permutation array is: "
output_array_message: .asciiz "\nThe permuted array is: "

.text

main:
    ### ----------------------------------- #0 INITIALIZE VARIABLES IN MEMORY
    ################################################# --------- $t0 = arraySize
    la $t0 arraySize #load arraySize in $t0
    ################################################# --------- $t1 = loop counter
    la $t1 loopCounter #load loopCounter in $t1
    ################################################# --------- $t2 = intArray
    la $t2, intArray #load intArray in $t2

    ### ----------------------------------- #1 DISPLAY WELCOME
    li $v0, 4
    la $a0, welcome_message
    syscall

    ### ----------------------------------- #2 DISPLAY INPUT ARRAY INSTRUCTIONS
    li $v0, 4
    la $a0, input_array_message
    syscall

    ### ----------------------------------- #3 LOOP TO GET INPUT ARRAY
    lw $t0, arraySize  # Load the value of arraySize into $t0
    lw $t1, loopCounter # Load the value of loopCounter into $t1
    j intLoop

    ### ----------------------------------- #6 DISPLAY PERMUTATION ARRAY INSTRUCTIONS

    # 

    ### ----------------------------------- #7 PROMPT USER FOR INPUT
    
    #

    ### ----------------------------------- #8 POPULATE ARRAY
 
    #

    ### ----------------------------------- #9 DISPLAY PERMUTATION ARRAY RESULT
 
    #

    ### ----------------------------------- #10 PERMUTATE ARRAY
 
    #

    ### ----------------------------------- #11 DISPLAY PERMUTED ARRAY
     
    #

    ### ----------------------------------- #12 EXIT PROGRAM
    li $v0, 10 # 10 - exit program
    syscall

### ------------------------------------------------------------------------	
### ------------------------------------------------------------------------	
### ------------------------------------------------------------------------	

intLoop:
    ### ----------------------------------- #4 PROMPT USER FOR INPUT
    la $a0, prompt_p1
    li $v0, 4 # 4 - print string
    syscall
    lw $a0, loopCounter
    li $v0, 1 # 1 - print integer
    syscall
    la $a0, prompt_p2
    li $v0, 4
    syscall
	
    ### ----------------------------------- #5 GET INPUT FROM USER AND STORE IN ARRAY
    li $v0, 5 # 5 - read integer
    syscall
    sw $v0, ($t2)
    
    ### ----------------------------------- #6 INCREMENT LOOP COUNTER
    addi $t2, $t2, 4 #move to next slot
    addi $t1, $t1, 1
	
    ### ----------------------------------- #7 LOOP UNTIL ALL ELEMENTS ARE ENTERED
    blt $t1, $t0, intLoop

    ### ----------------------------------- #8 RESET LOOP COUNTER AND LOAD ARRAY INTO $t2
    li $t2, 0 #reset loop counter
    la $t2, intArray
	
    ### ----------------------------------- #9 DISPLAY INPUT ARRAY RESULT
    lw $a0, $t2 # ---------- CURRENTLY DISPLAYING 1ST ELEMENT -----------
    li $v0, 1
    syscall


