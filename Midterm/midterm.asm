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
    monsterMinStrength: .word 1  # Adjust these values according to requirements
    monsterMaxStrength: .word 110  # Adjust these values according to requirements
    # Player's min/max health
    playerMinHealth:    .word 25
    playerMaxHealth:    .word 50
    # Monster's min/max health
    monsterMinHealth:   .word 30  # Adjust these values according to requirements
    monsterMaxHealth:   .word 55  # Adjust these values according to requirements

.text
    main:
       # Generating random values for player's strength and health
        li $v0, 42     # Load syscall 42 (generate random number)
        la $a1, playerMinStrength      # Minimum value for random number (player's min strength)
        la $a2, playerMaxStrength     # Maximum value for random number (player's max strength)
        syscall        # Execute the syscall

        sw $v0, characterStats  # Store the random strength value in the array

        li $v0, 42     
        la $a1, playerMinHealth     # Minimum value for random number (player's min health)
        la $a2, playerMaxHealth     # Maximum value for random number (player's max health)
        syscall        

        sw $v0, characterStats + 4  # Store the random health value in the array

        
        






        # exit program
        li $v0, 10
        syscall





