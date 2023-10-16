.data
    welcomeMessage: .asciiz "\nWelcome to the Monster Text Battle Game!\n\n"

    ###### ------------- CHARACTER ARRAY INFO ------------- ######
    # Define an array to store character stats: 8 elements (4 characters)
    characterStats: .space 32
    player: .asciiz "\nPlayer\n"
    monster1: .asciiz "\nMonster 1\n"
    monster2:.asciiz "\nMonster 2\n"
    monster3: .asciiz "\nMonster 3\n"
    characterHealthString: .asciiz "Health:  "
    characterStrengthString: .asciiz "Strength:  "
    maxHealth: .word 0

    ###### ------------- ACTION PROMPT INFO ------------- ######
    # Define a buffer to store player's action
    playerAction: .space 2  # Reserve 8 bytes for player's input
    # Define the action prompt message
    actionPrompt1: .asciiz "\nBe careful! You are about to enter a battle round!"
    actionPrompt2: .asciiz "\nChoose your action (1) for Attack or (2) for Heal: "
    attackingString1: .asciiz "\nAttacking... \nMonster "
    attackingString2: .asciiz " has taken damage!\n"
    attackingString3: .asciiz " points of health lost!\n"
    healingString1: .asciiz "\nHealing...\nYou have gained "
    healingString2: .asciiz " points of health!\n"
    noHealingString: .asciiz "\nYou are already at max health!\n"
    monsterAttackString: .asciiz "\nMonster is attacking..."
    monsterAttackString2: .asciiz "You managed to evade damage!\n"
    gameOverMessage: .asciiz "\n\n\nGame Over!\n\n\n"


.text
    
    ############################## MAIN PROGRAM ##############################
    main:

        addi $s0, $zero, 0
        la $s1, maxHealth
        sw $s1, ($s1)
        li $s2, 3

        # load player data
        j generate_player_stats
        player_continue:
		
		j generate_monster_stats
		monster_continue:

        # display welcome message
        li $v0, 4
        la $a0, welcomeMessage
        syscall

        # display character stats
        jal display_stats

        game_loop:
            prompt:
                # display prompt message for user action
                li $v0, 4
                la $a0, actionPrompt1
                syscall
                la $a0, actionPrompt2
                syscall
                # get user choice
                li $v0, 5
                syscall
            
                li $t0, 1
                li $t1, 2
                beq	$v0, $t0, playerAttack
                beq $v0, $t1, heal

                j prompt
            check_game_over:

                li $t0, 4 # index for player's health
                lw $t1, characterStats($t0) # load player's health
                ble	$t1, $zero, game_over	# if player's health is 0 or less end the game

                li $t0, 12 # index for first monster's health
                li $t1, 0 # number of dead monsters
                li $t2, 3 # number of monsters
                li $t5, 0 # loop counter
                
                check_game_over_loop:
                    # end game if all monsters are dead
                    bge	$t1, $t2, game_over	
                    # continue game once all monsters' health is checked
                    # div $t4, $t0, 4
                    # sub $t4, $t4, 3
                    bge	$t5, $t2, continue_game	
                    
                    # get moster's health
                    lw $t3, characterStats($t0)
                    # increment to next health
                    addi $t0, $t0, 8
                    # increment loop
                    addi $t5, $t5, 1
                    # if monster's health is above 0 then don't increment death count
                    bgt $t3, $zero, check_game_over_loop
                    addi $t1, $t1, 1
                    
                    j check_game_over_loop
                
            continue_game:

            # display character stats
            jal display_stats

            j game_loop

        # Exit the program
        li $v0, 10
        syscall		

    playerAttack:
        # Load the indexes of the player and monster1 in the array
        addi $t2, $zero, 0 # player index
        addi $t3, $t2, 4  # monster1 index - 8 for looping
        li $t7, 0

        playerAttackLoop:
            # Load the player's attack stat and the monster's health
            addi $t3, $t3, 8
            lw $t4, characterStats($t2)  # player's strength
            lw $t5, characterStats($t3)  # monster1's health

            addi $t7, $t7, 1
            bgt $t7, $s2, monsterAttack
            
            # Check if the monster is alive (health > 0)
            blez $t5, playerAttackLoop  # If monster's health is 0 or less, then skip to the next monster

            # Subtract the player's strength from the monster's health
            sub $t5, $t5, $t4

            # Store the updated monster's health back in the array
            sw $t5, characterStats($t3)

            # Display the attacking message 1
            li $v0, 4
            la $a0, attackingString1
            syscall

            # Display the monster's index
            div $t6, $t3, 4
            sub $t6, $t6, 3
            li $v0, 1
            la $a0, ($t6)
            syscall
            # Display the attacking message 2
            li $v0, 4
            la $a0, attackingString2
            syscall
            # Display number of health points lost
            li $v0, 1
            la $a0, ($t4)
            syscall
            # Display the attacking message 3
            li $v0, 4
            la $a0, attackingString3
            syscall

            j monsterAttack


    heal:
        # Load the index of the player in the array
        addi $t2, $zero, 0 # player index
        # Load the player's strength
        lw $t3, characterStats($t2)  # player's strength
        addi $t2, $t2, 4 # Increment index by 4 to get to player's health
        # Load the player's health
        lw $t4, characterStats($t2)  # player's health

        # Add the player's strength to the player's health
        add $t5, $t4, $t3

		# la $t6, maxHealth
        lw $t6, ($s1)
        # Check if the player's health is greater than the max health
        bgt $t5, $t6, make_max_health  # Branch to make_max_health if health is greater than max health 
        beq $t5, $t6, no_heal_message  # Branch to no_heal_message if health is equal to max health

        health_calculated:
        # Store the updated player's health back in the array
        sw $t5, characterStats($t2)

        sub $t3, $t5, $t4 # Calculate the amount of health points gained
        
        # Display the healing message 1
        li $v0, 4
        la $a0, healingString1
        syscall

        # Display the amount of health points gained
        li $v0, 1
        la $a0, ($t3)
        syscall
        # Display the healing message 2
        li $v0, 4
        la $a0, healingString2
        syscall

        j monsterAttack
        
        make_max_health:
            la $t5, ($t6)
            j health_calculated

        no_heal_message:
            li $v0, 4
            la $a0, noHealingString
            syscall
            j monsterAttack

    monsterAttack:
        addi $t7, $zero, 0 # monster index

        li $v0, 4
        la $a0, monsterAttackString
        syscall

        addi $t2, $zero, 8 # monster stength index
        addi $t3, $zero, 4 # player health index
        
        attack_player:    

            # exit loop if all monster had the chance to attack
            li $a3, 3
            bge $t7, $a3, check_game_over
            
            lw $t4, characterStats($t3)  # player's health
            lw $t5, characterStats($t2)  # monster's strength
            addi $t2, $t2, 4 # Increment index by 4 to get to monster's health
            lw $t6, characterStats($t2)  # monster's health

            addi $t2, $t2, 4 # Increment index by 4 to get to monster's health
            addi $t7, $t7, 1

            ble $t6, $zero, attack_player # If monster's health is 0 or less, then skip to the next monster

            li $a1, 1
            # Randomize the stat percentage
            li $v0, 42 # Load syscall 42 (generate random number)
            syscall 
            # if should attach, then keep going
            bne $a0, $a1, attack_player
            
            # Subtract the monster's strength from the player's health
            sub $t4, $t4, $t5

            # Store the updated player's health back in the array
            sw $t4, characterStats($t3)

            # Display the attacking message 1
            li $v0, 1
            la $a0, ($t4)
            syscall

            # Display the damage message 2
            li $v0, 4
            la $a0, attackingString3
            syscall

            j attack_player

    game_over:
        # Display the game over message
        li $v0, 4
        la $a0, gameOverMessage
        syscall

        # Exit the program
        li $v0, 10
        syscall
    
    ############################## SUBROUTINES ##############################
    generate_player_stats:
            li $t0, 0   # player loop index
            li $a1, 12  # Load player's max strength into $a1
            li $a2, 5   # Load player's min strength into $a2
            jal generate_random_value  # Generate random strength
            
            li $a2, 25  # Load player's min health into $a2
            li $a1, 50  # Load player's max health into $a1            
            jal generate_random_value  # Generate random health
			
            j player_continue # Return to main program

        # ------------- GENERATE RANDOM VALUE -------------
    generate_random_value:
        # Randomize the stat percentage
        li $v0, 42 # Load syscall 42 (generate random number)
        syscall # Execute the syscall
        add $a0, $a0, $a2 # Adjust range to be within original range

        # Check if the generated value is less than the min value
        blt $a0, $a2, generate_random_value
        # Check if the generated value is greater than the max value
        bgt $a0, $a1, generate_random_value

        sw $a0, characterStats($s0)
        addi $t0, $t0, 1 # Increment the loop counter

        bgt $t0, 1, set_max_health
        increment_array:
        addi $s0, $s0, 4 
                    
        jr $ra # Return to main program

        set_max_health:
            addi $t0, $zero, 4
            lw $t1, characterStats($t0)
            sw $t1, ($s1) 
            j increment_array

    generate_monster_stats:

        li $t0, 0   # monster loop index

        monster_loop:
            # Generate random stat for the current monster
            li $a1, 110 # Load monster's max stat percentage into $a1 (110%)
            li $a2, 33  # Load monster's min stat percentage into $a2 (30%)

            addi $t5, $zero, 0 # Load the index for the current monster
            lw $a3, characterStats($t5)  # Player's strength

            jal calculate_monster_stats  # Generate random strength stat for the current monster

            addi $t5, $t5, 4     # Increment the index for the next monster
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
    display_stats:
        
        li $t0, 0  # Initialize counter
        li $t1, 0  # index for stats array
        li $t2, 4 # We use 4 to loop one more time for the player's stats
        
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
        
 