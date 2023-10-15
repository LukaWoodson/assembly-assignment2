.data
    # Define an array to store character stats: 8 elements (4 characters)
    characterStats: .space 32
    characterStatsLength: .word 8
    slotSize: .word 4

    # Define a buffer to store player's action
    playerAction: .space 8  # Reserve 8 bytes for player's input

    # Define the action prompt message
    actionPrompt: .asciiz "\nChoose your action (attack/heal): "
    testMsg: .asciiz "Print ran \n"
    doneMsg: .asciiz "Print done \n"


.text
    
    ############################## MAIN PROGRAM ##############################
    main:

        la $s0, characterStats
        la $s1, characterStatsLength
        lw $s1, ($s1)
        la $s2, slotSize 
        lw $s2, ($s2)

        # load player data
        
        

        

        # display prompt message
        li $v0, 4
        la $a0, actionPrompt
        syscall
        # get user choice
        li $v0, 5
        syscall
        # TODO: handle user choice

        j generate_player_stats

        player_continue:
		
        li $s3, 0 # Loop Counter
		j generate_monster_stats
		
		monster_continue:


   j main


    ############################## SUBROUTINES ##############################

    generate_player_stats:
            li $a1, 12  # Load player's max strength into $a1
            li $a2, 5   # Load player's min strength into $a2
            jal generate_random_value  # Generate random strength
            
            li $a2, 25  # Load player's min health into $a2
            li $a1, 50  # Load player's max health into $a1            
            #add $s0, $s0, 4 # Store the valid random health value in the array -------------------------------------------------------------------------------------
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

            sw $a0, ($s0)  # Store the current character's stat
			add $s0, $s0, 4 #----------------------------------------------------------------------------------------------------------------------------------------------------------
						
            jr $ra # Return to main program

        generate_monster_stats:
            # Generate random stat for the current monster
            li $a1, 110 # Load monster's max stat percentage into $a1 (110%)
            li $a2, 33  # Load monster's min stat percentage into $a2 (30%)

            la $t5, characterStats
            lw $a3, ($t5) # Player's strength
            jal calculate_monster_stats  # Generate random strength stat for the current monster

            add $t5, $t5, 4
            lw $a3, ($t5) # Player's health
            # Increment characterStats offset by 4
           
            jal calculate_monster_stats  # Generate random health stat for the current monster
            
            # display prompt message
            li $v0, 4
            la $a0, testMsg
            syscall

            addi $s3, $s3, 1 # Increment the loop counter
            
            # Check if the current monster is the last monster
           li $t3, 3
           beq $s3, $t3, monster_continue  # If we've filled all slots, exit the loop
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

            # Store the current monster's stat percentage
            #la $t3, ($a0)
        
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
            
            sw $a0, ($s0)  # Store the current character's stat
            add $s0, $s0, 4 #----------------------------------------------------------------------------------------------------------------------------------
            jr $ra # Return to main program
    
    
    
    
    
    
