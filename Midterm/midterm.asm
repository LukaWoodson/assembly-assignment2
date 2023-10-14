.data
    # Define an array to store character stats: 8 elements (4 characters)
    characterStats:
        .word 0, 0  # Player's health and strength
        .word 0, 0  # Monster 1's health and strength
        .word 0, 0  # Monster 2's health and strength
        .word 0, 0  # Monster 3's health and strength

    # Define an array to store character names: 4 elements (4 characters)
    characterNames:
        .asciiz "Player"
        .asciiz "Monster 1"
        .asciiz "Monster 2"
        .asciiz "Monster 3"

    # Define a buffer to store player's action
    playerAction: .space 8  # Reserve 8 bytes for player's input

    # Define the action prompt message
    actionPrompt: .asciiz "\nChoose your action (attack/heal): "


.text
    
    ############################## MAIN PROGRAM ##############################
    main:
    	la $t0, characterStats
    	
    	jal generate_strength
    	
    	jal generate_health
    	
    	
    	
    	
    	# Exit Program
        li $v0, 10
        syscall
    	
    	


        ############################## SUBROUTINES ##############################
    
        # ------------- GENERATE RANDOM PLAYER STATS -------------
        generate_strength:
        li $a1, 12  # Load player's max strength into $a1
        li $a2, 5   # Load player's min strength into $a2
        li $v0, 42             # Load syscall 42 (generate random number)
        syscall                 # Execute the syscall
        add $a0, $a0, $a2        # Adjust range to be within original range

        # Check if the generated strength is less than the min strength
        blt $a0, $a2, generate_strength
        # Check if the generated strength is greater than the max strength
        bgt $a0, $a1, generate_strength

        sw $a0, ($t0) # Store the valid random strength value in the array
        
        jr $ra # Return to main program

        # Generate a random number for player health
        generate_health:
        li $a2, 25  # Load player's min health into $a2
        li $a1, 50  # Load player's max health into $a1
        li $v0, 42              # Load syscall 42 (generate random number)
        syscall                  # Execute the syscall
        add $a0, $a0, $a2 # Adjust range to be within original range

        # Check if the generated health is less than the min health
        blt $a0, $a2, generate_health
        # Check if the generated health is greater than the max health
        bgt $a0, $a1, generate_health
        
        add $t0, $t0, 4 # Store the valid random health value in the array
        sw $a0, ($t0) # Store the random health value in the array 

        jr $ra # Return to main program



 