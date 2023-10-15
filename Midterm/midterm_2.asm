.data
    ###### ------------- CHARACTER ARRAY INFO ------------- ######
    # Define an array to store character stats: 8 elements (4 characters)
    characterStats: .space 32
    player: .asciiz "\nPlayer\n"
    monster1: .asciiz "\nMonster1\n"
    monster2:.asciiz "\nMonster2\n"
    monster3: .asciiz "\nMonster3\n"
    characterHealthString: .asciiz "Health:  "
    characterStrengthString: .asciiz "Strength:  "
    characterStatsLength: .word 8
    slotSize: .word 4

    # Define a buffer to store player's action
    playerAction: .space 2  # Reserve 8 bytes for player's input

    ###### ------------- ACTION MESSAGES ------------- ######
    # Define the action prompt message
    actionPrompt: .asciiz "\nChoose your action (attack/heal): "

    ###### ------------- DEBUGGING MESSAGES ------------- ######
    testMsg: .asciiz "Print ran \n"


.text
    
    ############################## MAIN PROGRAM ##############################
    main:

        addi $s0, $zero, 0
        la $s1, characterStatsLength
        lw $s1, ($s1)
        la $s2, slotSize 
        lw $s2, ($s2)

        # load player data
        j generate_player_stats
        player_continue:
		
        li $t7, 0 # Initialize Loop Counter
		j generate_monster_stats
		monster_continue:
        li $t7, 0 # Reset Loop Counter

        # display prompt message for user action
        li $v0, 4
        la $a0, actionPrompt
        syscall
        # get user choice
        li $v0, 5
        syscall
        # TODO: handle user choice
        # look into syscall 8 for reading strings

		# display character stats
        jal display_stats

   j main

    debug:
    # display prompt message
        li $v0, 4
        la $a0, testMsg
        syscall
        jr $ra

    ############################## SUBROUTINES ##############################

    generate_player_stats:
            li $a1, 12  # Load player's max strength into $a1
            li $a2, 5   # Load player's min strength into $a2
            jal generate_random_value  # Generate random strength
            
            li $a2, 25  # Load player's min health into $a2
            li $a1, 50  # Load player's max health into $a1            
            jal generate_random_value  # Generate random health
			
            j player_continue # Return to main program

        # ------------- GENERATE RANDOM VALUE -------------
    generate_random_value:
        li $v0, 42 # Load syscall 42 (generate random number)
        syscall # Execute the syscall
        add $a0, $a0, $a2 # Adjust range to be within original range

        # Check if the generated value is less than the min value
        blt $a0, $a2, generate_random_value
        # Check if the generated value is greater than the max value
        bgt $a0, $a1, generate_random_value

        sw $a0, characterStats($s0)
        addi $s0, $s0, 4 #----------------------------------------------------------------------------------------------------------------------------------------------------------
                    
        jr $ra # Return to main program

    generate_monster_stats:
        # Generate random stat for the current monster
        li $a1, 110 # Load monster's max stat percentage into $a1 (110%)
        li $a2, 33  # Load monster's min stat percentage into $a2 (30%)

        addi $t5, $zero, 0
        lw $a3, characterStats($t5)  # Player's strength

        jal calculate_monster_stats  # Generate random strength stat for the current monster

        addi $t5, $t5, 4    
        lw $a3, characterStats($t5)  # Player's health     
        jal calculate_monster_stats  # Generate random health stat for the current monster

        addi $t7, $t7, 1 # Increment the loop counter
        
        # Check if the current monster is the last monster
        li $t3, 3
        beq $t7, $t3, monster_continue  # If we've filled all slots, exit the loop
        j generate_monster_stats  # Otherwise, continue generating stats for the next character

    calculate_monster_stats:
        # Randomize the stat percentage
        li $v0, 42 # Load syscall 42 (generate random number)
        syscall # Execute the syscall
        add $a0, $a0, $a2 # Adjust range to be within original range

        # Check if the generated value is less than the min value
        blt $a0, $a2, calculate_monster_stats
        # Check if the generated value is greater than the max value
        bgt $a0, $a1, calculate_monster_stats
    
        ##### Example: (110 * 120) = 13200 / 1000 = 13.2 (110%) #####
        ##### Example: (33 * 120) = 3960 / 1000 = 3.96 (33%) #####
        
        # Calculate the current monster's strength
        li $t2, 1000 # Load the divider into $s2
        
        # Calculate: Multiply the % by player's stat
        mul $a3, $a3, 10
        mul $t4, $a0, $a3    
        
        # Calculate: Divide % by 1000      
        div $t4, $t2 
        mfhi $t6 # Store the remainder in $t6
        mflo $a0 # Store the quotient in $a0
        
        # Check if the current monster's stat remainder is less than 500 to see if it should be rounded up
        blt $t6, 500, less_than
            addi $a0, $a0, 1

        less_than:
        # Store the final result
        
        sw $a0, characterStats($s0)
        # Increment characterStats offset by 4
        addi $s0, $s0, 4 #----------------------------------------------------------------------------------------------------------------------------------
        jr $ra # Return to main program

    # ------------- DISPLAY CHARACTER STATS -------------
    # Subroutine to display character stats
    display_stats:
        # LOAD CHARACTER STATS ARRAY
        la $t2, characterStats
        #lw $a3, ($t2) # Player's strength

        li $t0, 0  # Initialize counter
        character_loop:
            # print new line, 10 is ASCII code for new line
            li $a0, 10
            li $v0, 11
            syscall
            
            beq $t7, 0, name_1
            beq $t7, 1, name_2
            beq $t7, 2, name_3
            beq $t7, 3, name_4
        	name_1:
                la $a0, player
                j end_name_branch
            name_2: 
            	la $a0, monster1 
                j end_name_branch
            name_3:
                la $a0, monster2
                j end_name_branch
            name_4:
                la $a0, monster3
            end_name_branch:
            # Display character's name
           # move $a0, $a2
            li $v0, 4  # Print string syscall
            syscall

            # Load the current character's strength
            lw $a3, ($t2)

            # display character's strength
            la $a0, characterStrengthString # Load the string
            li $v0, 4
            syscall
            la $a0, ($a3) # Move character's strength into $a0
            li $v0, 1
            #move $a2, $a3 # Move character's strength into $a0
            syscall

            # print new line, 10 is ASCII code for new line
            li $a0, 10
            li $v0, 11
            syscall

            add $t2, $t2, 4 # Increment the characterStats offset by 4
            lw $a3, ($t2)
            #add $a3, $a3, 4 # Increment the characterStats offset by 4

            # display character's health
            la $a0, characterHealthString # Load the string
            li $v0, 4
            syscall
            la $a0, ($a3) # Move character's health into $a0
            li $v0, 1
            syscall

            # print new line, 10 is ASCII code for new line
            li $a0, 10
            li $v0, 11
            syscall

            # Increment $t1 to point to the next character name and $a3 to point to the next character's strength
            add $t1, $t1, 4
            add $a3, $a3, 4

            # Increment the counter
            addi $t7, $t7, 1
        	
            # Check if we've displayed stats for all characters (4 in total)
            li $t4, 4  # We use 4 to loop one more time for the player's stats
            blt $t7, $t4, character_loop # If we haven't displayed all characters, continue with the next character

        jr $ra  # Return from the subroutine

        #------------- HANDLE PLAYER ACTION -------------
        handle_player_action:
            # Prompt the player for their action (attack or heal)
            li $v0, 4  # Print string syscall
            la $a0, actionPrompt  # Load the action prompt message
            syscall

            # Get player input
            li $v0, 8  # Read string syscall
            la $a0, playerAction  # Load a buffer to store player's action
            li $a1, 1  # Maximum number of characters to read
            syscall

            # Check player's action
            # You can use conditional branches to determine the action
            # Update character stats based on the chosen action

            # Return from the subroutine
            jr $ra
        
    
    
    
    
    
