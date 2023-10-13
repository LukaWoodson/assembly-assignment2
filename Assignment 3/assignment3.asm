 .data
    ### --- Integers and Arrays
    intArray:   .space      40
    permArray:  .space      40
    arraySize:  .word       5
    bytes:      .word       4

    ### --- Instruction Strings
    welcome_message: .asciiz "Welcome! The program will calculate an array given array and the provided permutation.\n"
    input_array_message: .asciiz "\nPlease enter the 5 elements for the integer array\n\n"
    permutation_array_message: .asciiz "\n\nPlease enter the 5 unique elements (0-4) for permutation.\n\n"

    ### --- User Prompts
    prompt:     .asciiz     "Please enter an integer value: "

    ### --- Results
    input_array_result: .asciiz "\nYour array is: "
    permutation_array_result: .asciiz "\nYour permutation array is: "
    output_array_message: .asciiz "\nThe permuted array is: "

.text

    main:
        ### ----------------------------------- INITIALIZE VARIABLES IN MEMORY
        la $t0, intArray #load intArray in $t0

        la $t1 arraySize #load arraySize in $t1
        lw $t1, ($t1)  # Load the value of arraySize into $t1
        la $t2, bytes #load bytes in $t2
        lw $t2, ($t2) # Load the value of bytes into $t2

        ### ----------------------------------- DISPLAY WELCOME
        li $v0, 4
        la $a0, welcome_message
        syscall

        ### ----------------------------------- DISPLAY INPUT ARRAY INSTRUCTIONS
        li $v0 4
        la $a0 input_array_message
        syscall

        li $t3, 0 #loop counter
    intLoop:
        ### ----------------------------------- PROMPT USER FOR INPUT
        li $v0 4
        la $a0 prompt
        syscall
        
        ### ----------------------------------- GET INPUT FROM USER AND STORE IN ARRAY
        li $v0 5
        syscall
        sw $v0, ($t0)
        
        ### ----------------------------------- INCREMENT LOOP COUNTER
        add $t0, $t0, $t2 
        
        addi $t3, $t3, 1

        ### ----------------------------------- LOOP UNTIL ALL ELEMENTS ARE ENTERED
        bne $t1, $t3, intLoop

        #output the result message
        li $v0 4
        la $a0 input_array_result
        syscall

        ### ----------------------------------- RESET LOOP COUNTER AND LOAD ARRAY INTO $t0
        li $t3 0 
        la $t0 intArray
        
    printIntLoop:
        ### ----------------------------------- DISPLAY INPUT ARRAY RESULT
        li $v0 1
        lw $a0, ($t0)
        syscall

        ### ----------------------------------- ADD SPACE BETWEEN INTEGERS
        # print space, 32 is ASCII code for space
        li $a0, 32
        li $v0, 11 
        syscall

        ### ----------------------------------- INCREMENT LOOP COUNTER
        add $t0, $t0, $t2 
        addi $t3, $t3, 1

        ### ----------------------------------- LOOP UNTIL ALL ELEMENTS ARE ENTERED
        bne $t3, $t1, printIntLoop


    ### ----------------------------------------------------------

    li $t3 0 # loop iterator i = 0
    la $t4, permArray #load permutationArray address in $t4

    ### ----------------------------------- DISPLAY PERMUTATION ARRAY INSTRUCTIONS
    li $v0 4
    la $a0 permutation_array_message
    syscall
    permLoop:
        ### ----------------------------------- PROMPT USER FOR INPUT
        la $a0 prompt
        li $v0 4
        syscall
        
        ### ----------------------------------- GET INPUT FROM USER AND STORE IN ARRAY
        li $v0 5
        syscall
        sw $v0, ($t4)
        
        ### ----------------------------------- INCREMENT LOOP COUNTER
        add $t4, $t4, $t2 
        addi $t3, $t3, 1

        ### ----------------------------------- LOOP UNTIL ALL ELEMENTS ARE ENTERED
        bne $t3, $t1, permLoop

        #output the result message
        li $v0 4
        la $a0 permutation_array_result
        syscall

        ### ----------------------------------- RESET LOOP COUNTER AND LOAD ARRAY INTO $t4
        li $t3 0 
        la $t4 permArray

    printPermLoop:
        li $v0 1
        lw $a0, ($t4)
        syscall

        # print space, 32 is ASCII code for space
        li $a0, 32
        li $v0, 11 # printing character
        syscall

        add $t4, $t4, $t2 
        addi $t3, $t3, 1		
        bne $t3, $t1, printPermLoop	

        ### -------------------
        la $t0, intArray 
        la $t4, permArray 

        li $t3 0 
        
        move $t5, $t1	
        subi $t5, $t5, 2

    ### ----------------------------------- PERMUTATION ALGORITHM
    loop_i:
        bge $t3, $t5, loop_i_end # if $i >= arraySize - 2 then exit loop
        
        mult $t2, $t3		
        mflo $s0			

        add $t6, $s0, $t0 
        add $t7, $s0, $t4 

        lw $s1, ($t7)	
        mult $t2, $s1		
        mflo $s0			
        add $s2, $s0, $t0 

        # swap array[i] with array[permutationArray[i]]
        lw $s3, ($t6)	
        lw $s4, ($s2)	
        sw $s4, ($t6)	
        sw $s3, ($s2)	

        # j = i + 1
        move $s5, $t3 # j = i
        addi $s5, $s5, 1 # j = j + 1
        
        addi $s6, $t5, 1	
        
        loop_j:
            # if j >= arraySize - 1 then end loop
            bge $s5, $s6, loop_j_end	
            mult $t2, $s5		
            mflo $s0			
            add $s7, $t4, $s0
            lw $t8, 0($s7)	  
            
            bne	$t3, $t8, next_j # if i != permutationArray[j] then loopIncrement

            #swap permutationArray[i] with permutationArray[j]
            sw $t8, 0($t7)	
            sw $s1, 0($s7)	
            j loop_j_end

        next_j:
            addi $s5, $s5, 1 # j++
            j loop_j 

        loop_j_end:
        

        addi $t3, $t3, 1 # i++
        j loop_i
   
    loop_i_end:

    # output the result message
        li $v0 4
        la $a0 output_array_message
        syscall

    ### ----------------------------------- PRINT PERMUTED ARRAY
    li $t3 0 # loop iterator
    
    printFinalArray:
        li $v0 1
        lw $a0, ($t0)
        syscall

        # print space, 32 is ASCII code for space
        li $a0, 32
        li $v0, 11  
        syscall

        add $t0, $t0, $t2 
        addi $t3, $t3, 1	
        bne $t3, $t1, printFinalArray # if $t3 == $t1 then loop

    #exit program
    li $v0 10
    syscall

