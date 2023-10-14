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
    	la $t0, characterStats # Load the address of characterStats into $t0
        jal generate_player_stats # Generate a random stats for the player
    	player_continue:
        # Initialize monsters' stats
        la $t1, characterNames # Load the base address of characterNames
        jal generate_monster_stats # Generate random stats for monsters
    	monster_continue:
    	
        ### ------------- GAME LOOP -------------
        game_loop:
            # Call the display_stats subroutine to show character stats
            jal display_stats

            # Prompt for player's action (attack or heal)
            # Call the handle_player_action subroutine to handle the player's action
            jal handle_player_action

            # Process player's action
            # You can use a subroutine to handle player's actions

            # Check if the game is over (player or all monsters defeated)
            # You can use a subroutine to check the game state

            # If the game is not over, loop back to game_loop
            j game_loop

    	
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
        # $a0: result value
        # $a1: max value
        # $a2: min value
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
            li $a1, 11 # Load monster's max stat percentage into $a1 (110%)
            li $a2, 3  # Load monster's min stat percentage into $a2 (30%)

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

            ##### Example: 11 / 10 = 1.1 * 12 = 13.2 (110%) #####
            ##### Example: 3 / 10 = 0.3 * 12 = 3.6 (30%) #####

            # Calculate the current monster's strength 
            lw $s0, 0($t0) # copy the player's strength into $s0

            li $s1, 0 # Initialize the counter to 0
            calculate:
            # Calculate the monster's strength

            # - $f1: random percentage         --- 3
            l.s $f1, ($s3) # Convert the random percentage to a float

            # - $f2: 10.0
            # - $f3: random percentage / 10.0    --- 0.3
            l.s $f2, 10
            div.s $f3, $f1, $f2 # Divide the random percentage by 10

            # - $f4: player's stat              --- 12
            l.s $f4, ($s0) # Convert the player's stat to a float
            
            # - $f5: random percentage * player's stat   --- 3.6
            mul.s $f5, $f1, $f4 # Multiply the random percentage by the player's strength

            cvt.w.s $f0, $f5 # Convert the float to an integer
            mfc1 $a0, $f0 # Move the integer to $a0
            
            # Store the current monster's strength
            add $t0, $t0, 4 # Increment the characterStats array index
            sw $a0, ($t0)
            addi $s1, $s1, 1 # Increment the counter
            lw $s0, 1($t0) # Copy the current monster's health into $s0
            
            blt $s1, 2, calculate # Check if the counter is less than 2

            # Check if the current monster is the last monster
            li $t2, 4  # Total characters (including player)
            bne $t0, $t2, generate_monster_stats # Continue generating stats for the next character

            j monster_continue # Return to main program

        # Calculate monster stat
        # calculate_monster_stat:
        #     # Load the current monster's strength into $t0
        #     lw $t0, ($t0)
        #     # Load the current monster's health into $t1
        #     lw $t1, ($t1)

        #     # Calculate the monster's stat
        #     mul $t0, $t0, $t1

        #     jr $ra # Return to main program

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
        



 