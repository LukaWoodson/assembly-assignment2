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
    healingString: .asciiz "Healing..."
    attackingString: .asciiz "Attacking..."

    # Define a buffer to store player's action
    playerAction: .space 2  # Reserve 8 bytes for player's input

    ###### ------------- ACTION MESSAGES ------------- ######
    # Define the action prompt message
    actionPrompt: .asciiz "\nChoose your action (attack/heal): "


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
		
		j generate_monster_stats
		monster_continue:

        # display character stats
        jal display_stats

    game_loop:
        # display prompt message for user action
        li $v0, 4
        la $a0, actionPrompt
        syscall
        # get user choice
        li $v0, 5
        syscall
    
        li $t0, 1
        li $t1, 2
        beq	$v0, $t0, attack
        beq $v0, $t1, heal

        j game_loop
        check_game_over:
        # display character stats
        jal display_stats

        # TODO: check if player is dead or if all monsters are dead

    # Exit the program
    li $v0, 10
    syscall		

    ############################## SUBROUTINES ##############################

    attack:
        li $v0, 4
        la $a0, attackingString
        syscall
        j check_game_over

    heal:
        li $v0, 4
        la $a0, healingString
        syscall
        j check_game_over

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

        li $t0, 0   # monster loop index

        monster_loop:
            # Generate random stat for the current monster
            li $a1, 110 # Load monster's max stat percentage into $a1 (110%)
            li $a2, 33  # Load monster's min stat percentage into $a2 (30%)

            addi $t5, $zero, 0
            lw $a3, characterStats($t5)  # Player's strength

            jal calculate_monster_stats  # Generate random strength stat for the current monster

            addi $t5, $t5, 4    
            lw $a3, characterStats($t5)  # Player's health     
            jal calculate_monster_stats  # Generate random health stat for the current monster

            addi $t0, $t0, 1 # Increment the loop counter
            
            # Check if the current monster is the last monster
            li $t3, 3
            beq $t0, $t3, monster_continue  # If we've filled all slots, exit the loop
            j monster_loop  # Otherwise, continue generating stats for the next character

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
        
        li $t0, 0  # Initialize counter
        li $t1, 0  # index for stats array
        li $t2, 4  # We use 4 to loop one more time for the player's stats
        
        character_loop:
            # print new line, 10 is ASCII code for new line
            li $a0, 10
            li $v0, 11
            syscall
            
            beq $t0, 0, name_1
            beq $t0, 1, name_2
            beq $t0, 2, name_3
            beq $t0, 3, name_4
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
            li $v0, 4  # Print string syscall
            syscall

            ### display character's strength ###
            la $a0, characterStrengthString # Load the string
            li $v0, 4
            syscall

            lw $a0, characterStats($t1) # character's strength
            addi $t1, $t1, 4

            li $v0, 1
            syscall

            # print new line, 10 is ASCII code for new line
            li $a0, 10
            li $v0, 11
            syscall

            ### display character's health ###
            la $a0, characterHealthString # Load the string
            li $v0, 4
            syscall
            

            lw $a0, characterStats($t1) # player's health
            addi $t1, $t1, 4

            li $v0, 1
            syscall

            # print new line, 10 is ASCII code for new line
            li $a0, 10
            li $v0, 11
            syscall


            # Increment the counter
            addi $t0, $t0, 1
        	
            # Check if we've displayed stats for all characters (4 in total)
            blt $t0, $t2, character_loop # If we haven't displayed all characters, continue with the next character

        jr $ra  # Return from the subroutine
        
    
    
    
    
    
