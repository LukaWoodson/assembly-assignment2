.data
    # Initialize an array to store character stats: 8 elements (4 characters)
    characterStats:
        .word 0, 0  # Player's health and strength
        .word 0, 0  # Monster 1's health and strength
        .word 0, 0  # Monster 2's health and strength
        .word 0, 0  # Monster 3's health and strength

    # Initialize an array to store character names: 4 elements (4 characters)
    characterNames:
        .asciiz "Player"
        .asciiz "Monster 1"
        .asciiz "Monster 2"
        .asciiz "Monster 3"

    # Initialize min/max variables
    # Player's min/max strength
    playerMinStrength:  .word 5
    playerMaxStrength:  .word 12
    # Monster's min/max strength
    monsterMinStrength: .word 0  # Adjust these values according to requirements
    monsterMaxStrength: .word 0  # Adjust these values according to requirements
    # Player's min/max health
    playerMinHealth:    .word 25
    playerMaxHealth:    .word 50
    # Monster's min/max health
    monsterMinHealth:   .word 0  # Adjust these values according to requirements
    monsterMaxHealth:   .word 0  # Adjust these values according to requirements

.text
    main:
        ### ------------- GENERATE RANDOM PLAYER STATS -------------
        li $v0, 42 # Load syscall 42 (generate random number)
        la $a1, playerMinStrength # Minimum value for random number (player's min strength)
        la $a2, playerMaxStrength # Maximum value for random number (player's max strength)
        syscall # Execute the syscall

        sw $v0, characterStats # Store the random strength value in the array

        li $v0, 42     
        la $a1, playerMinHealth # Minimum value for random number (player's min health)
        la $a2, playerMaxHealth # Maximum value for random number (player's max health)
        syscall        

        sw $v0, characterStats + 4 # Store the random health value in the array

        ### ------------- GENERATE RANDOM MONSTER STAT MIN AND MAX -------------

        # Set the initial values for the monsters' min/max strength and health
        li $v0, 0  # Load constant 0
        li $t0, 3  # Load 3 (to represent 1/3 of player's stats)
        li $t1, 10  # Load 10 (to represent 110% of player's stats)
        
        # Calculate the values for monsters' strength
        lw $t2, playerMinStrength  # Load player's min strength
        lw $t3, playerMaxStrength  # Load player's max strength
        divu $t2, $t2, $t0  # Calculate 1/3 of player's min strength
        divu $t3, $t3, $t1  # Calculate 110% of player's max strength
        sw $t2, monsterMinStrength  # Set monster's min strength
        sw $t3, monsterMaxStrength  # Set monster's max strength

        # Calculate the values for monsters' health
        lw $t2, playerMinHealth 
        lw $t3, playerMaxHealth 
        divu $t2, $t2, $t0  # Calculate 1/3 of player's min health
        divu $t3, $t3, $t1  # Calculate 110% of player's max health
        sw $t2, monsterMinHealth 
        sw $t3, monsterMaxHealth  

        ### ------------- GENERATE RANDOM MONSTER STATS -------------
        # Initialize a counter for the monster index (0 for the first monster)
        li $t0, 0  

        # Loop to generate random values for all monsters
        generate_monster_stats:
            # Calculate the offset in the characterStats array
            # Each character occupies 8 words in the array (4 for strength, 4 for health)
            mul $t1, $t0, 8  

            # Generating random values for the current monster's strength
            li $v0, 42
            la $a1, monsterMinStrength
            la $a2, monsterMaxStrength
            syscall

            # Store the random strength value for the current monster
            sw $v0, characterStats($t1)  

            # Generating random values for the current monster's health
            li $v0, 42
            la $a1, monsterMinHealth
            la $a2, monsterMaxHealth
            syscall

            # Store the random health value for the current monster
            sw $v0, characterStats($t1)  

            # Increment the counter
            addi $t0, $t0, 1

            # Check if we've generated stats for all monsters (3 in total)
            li $t2, 3
            beq $t0, $t2, end_generate_stats  # Exit the loop if all monsters have stats

            # Otherwise, continue generating stats for the next monster
            j generate_monster_stats

        end_generate_stats:

        ### ------------- GAME LOOP -------------
        game_loop:
        # Display character stats (player and living monsters)
        # You can use a subroutine to display character stats

        # Prompt for player's action (attack or heal)
        # You can use a subroutine to get player's input

        # Process player's action
        # You can use a subroutine to handle player's actions

        # Check if the game is over (player or all monsters defeated)
        # You can use a subroutine to check the game state

        # If the game is not over, loop back to game_loop
        j game_loop


        ### ------------- SUBROUTINES ------------- 
        # Subroutine to display character stats
        display_stats:
            # Display the player's stats (strength and health)
            lw $t0, characterStats  # Load player's health
            lw $t1, characterStats + 4  # Load player's strength
            li $v0, 4  # Print string syscall
            la $a0, characterNames  # Load character names
            syscall

            # Display monster stats (if their health > 0)
            li $t2, 1  # Initialize monster counter (starting from Monster 1)

            monster_loop:
                # Calculate the offset for the current monster
                mul $t3, $t2, 8  # Each character occupies 8 words in the array

                # Load the current monster's health and strength
                lw $t4, characterStats($t3)
                addi $t3, $t3, 4  # Increment the offset by 4 to access the next word
                lw $t5, characterStats($t3)


                # Check if the monster is alive (health > 0)
                bgtz $t4, display_monster_stats

                # If the monster is defeated, increment the counter
                addi $t2, $t2, 1

                # Check if we've displayed stats for all monsters (3 in total)
                li $t6, 4  # We use 4 to loop one more time for the player's stats
                beq $t2, $t6, end_display_stats

                # Otherwise, continue with the next monster
                j monster_loop

            display_monster_stats:
                # Display the current monster's stats (strength and health)
                li $v0, 4  # Print string syscall
                la $a0, characterNames($t2)  # Load the current monster's name
                syscall

                # Display monster's stats (health and strength)
                # You can use $t4 and $t5

                # Increment the counter
                addi $t2, $t2, 1

                # Check if we've displayed stats for all monsters (3 in total)
                li $t6, 4  # We use 4 to loop one more time for the player's stats
                beq $t2, $t6, end_display_stats

                # Continue with the next monster
                j monster_loop

        end_display_stats:
            jr $ra  # Return from the subroutine

        




        # Exit Program
        li $v0, 10
        syscall





