.data
    # Define an array to store character stats: 8 elements (4 characters)
    characterStats: .space 64
    characterStatsLength: .word 8
    slotSize: .word 8

    # Define a buffer to store player's action
    playerAction: .space 8  # Reserve 8 bytes for player's input

    # Define the action prompt message
    actionPrompt: .asciiz "\nChoose your action (attack/heal): "


.text
    
    ############################## MAIN PROGRAM ##############################
    main:
    	la $t0, characterStats # Load the address of characterStats into $t0
        jal generate_player_stats # Generate a random stats for the player
    	player_continue:
        # Initialize monsters' stats
       	li $t2, 2  # Player's strength and health are already filled
        la $t3, 0($t0) # copy the player's strength stat into $t3
        la $t4, 4($t0) # copy the player's health stat into $t4
        jal generate_monster_stats # Generate random stats for monsters
    	monster_continue:
    	
        ### ------------- GAME LOOP -------------
        #game_loop:
            # Call the display_stats subroutine to show character stats
            # jal display_stats

            # Prompt for player's action (attack or heal)
            # Call the handle_player_action subroutine to handle the player's action
            # jal handle_player_action

            # Process player's action
            # You can use a subroutine to handle player's actions

            # Check if the game is over (player or all monsters defeated)
            # You can use a subroutine to check the game state

            # If the game is not over, loop back to game_loop
            #j game_loop

    	
    	# Exit Program
        li $v0, 10
        syscall
    	
    	


        ############################## SUBROUTINES ##############################
    
        # ------------- GENERATE RANDOM PLAYER STATS -------------
        generate_player_stats:
            li $a1, 12  # Load player's max strength into $a1
            li $a2, 5   # Load player's min strength into $a2
            jal generate_random_value  # Generate random strength
            
            li $a2, 25  # Load player's min health into $a2
            li $a1, 50  # Load player's max health into $a1            
            add $t0, $t0, 4 # Store the valid random health value in the array
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

            sw $a0, ($t0)  # Store the current character's stat

            jr $ra # Return to main program

        # ------------- GENERATE RANDOM MONSTER STATS -------------
        generate_monster_stats:
            # Generate random stat for the current monster
            li $a1, 110 # Load monster's max stat percentage into $a1 (110%)
            li $a2, 33  # Load monster's min stat percentage into $a2 (30%)

            la $a3, ($t3) # Load the player's strength into $a3
            # Increment characterStats offset by 4
            add $t0, $t0, 4
            jal calculate_monster_stats  # Generate random strength stat for the current monster

            la $a3, ($t4) # Load the player's health into $a3
            # Increment characterStats offset by 4
            add $t0, $t0, 4
            jal calculate_monster_stats  # Generate random stat for the current monster
            
            # Check if the current monster is the last monster
            li $t3, 4
            beq $t2, $t3, monster_continue  # If we've filled all slots, exit the loop
            j generate_monster_stats  # Otherwise, continue generating stats for the next character

        # ------------- CALCULATE MONSTER STATS -------------
        calculate_monster_stats:
            # Randomize the stat percentage
            li $v0, 42 # Load syscall 42 (generate random number)
            syscall # Execute the syscall
            add $a0, $a0, $a2 # Adjust range to be within original range

            # Check if the generated value is less than the min value
            blt $a0, $a2, generate_monster_stats
            # Check if the generated value is greater than the max value
            bgt $a0, $a1, generate_monster_stats

            # Store the current monster's stat percentage
            la $s3, ($a0)

            ##### Example: (110 * 120) = 13200 / 1000 = 13.2 (110%) #####
            ##### Example: (33 * 120) = 3960 / 1000 = 3.96 (33%) #####

            # Calculate the current monster's strength
            li $s2, 1000 # Load the divider into $s2
            
            # Calculate: Multiply the % by player's stat
            mul $a3, $a3, 10
            mul $s4, $s2, $a3    
            
            # Calculate: Divide % by 1000      
            div $s4, $s2 
            mfhi $s5
            mflo $s6
            
            # Check if the current monster's stat remainder is less than 500 to see if it should be rounded up
            blt $s5, 500, less_than
                addi $s6, $s6, 1

            less_than:
            # Store the final result
            
            sw $s6, ($t0)  # Store the current character's stat
            
            addi $t2, $t2, 1 # Increment the counter
            
            jr $ra # Return to main program

        # ------------- DISPLAY CHARACTER STATS -------------
        # Subroutine to display character stats
        # display_stats:
        #     # Display the player's stats (strength and health)
        #     lw $t0, characterStats  # Load player's health
        #     lw $t1, characterStats + 4  # Load player's strength
        #     li $v0, 4  # Print string syscall
        #     la $a0, characterNames  # Load character names
        #     syscall

        #     # Increment $a0 to point to the next character name
        #     addi $a0, $a0, 4

        #     # Increment $a1 to point to the next character's health
        #     addi $a1, $a1, 8

        #     # Display monster stats (if their health > 0)
        #     li $t2, 1  # Initialize monster counter (starting from Monster 1)

        #     monster_loop:
        #         # Calculate the offset for the current monster
        #         mul $t3, $t2, 8  # Each character occupies 8 words in the array

        #         # Load the current monster's health and strength
        #         lw $t4, characterStats($t3)
        #         addi $t3, $t3, 4  # Increment the offset by 4 to access the next word
        #         lw $t5, characterStats($t3)

        #         # Check if the monster is alive (health > 0)
        #         bgtz $t4, display_monster_stats

        #         # If the monster is defeated, increment the counter
        #         addi $t2, $t2, 1

        #         # Check if we've displayed stats for all monsters (3 in total)
        #         li $t6, 4  # We use 4 to loop one more time for the player's stats
        #         beq $t2, $t6, end_display_stats

        #         # Otherwise, continue with the next monster
        #         j monster_loop

        #     display_monster_stats:
        #         # Display the current monster's stats (strength and health)
        #         li $v0, 4  # Print string syscall
        #         la $a0, characterNames($t2)  # Load the current monster's name
        #         syscall

        #         # Increment $a0 to point to the next character name
        #         addi $a0, $a0, 4

        #         # Display monster's stats (health and strength)
        #         # You can use $t4 and $t5

        #         # Increment $a1 to point to the next character's health
        #         addi $a1, $a1, 8

        #         # Increment the counter
        #         addi $t2, $t2, 1

        #         # Check if we've displayed stats for all monsters (3 in total)
        #         li $t6, 4  # We use 4 to loop one more time for the player's stats
        #         beq $t2, $t6, end_display_stats

        #         # Continue with the next monster
        #         j monster_loop
            
        # end_display_stats:
        #     jr $ra  # Return from the subroutine

        # ------------- HANDLE PLAYER ACTION -------------
        # Subroutine to handle player actions
        # handle_player_action:
        #     # Prompt the player for their action (attack or heal)
        #     li $v0, 4  # Print string syscall
        #     la $a0, actionPrompt  # Load the action prompt message
        #     syscall

        #     # Get player input
        #     li $v0, 8  # Read string syscall
        #     la $a0, playerAction  # Load a buffer to store player's action
        #     li $a1, 8  # Maximum number of characters to read
        #     syscall

        #     # Check player's action
        #     # You can use conditional branches to determine the action
        #     # Update character stats based on the chosen action

        #     # Return from the subroutine
        #     jr $ra
        



 