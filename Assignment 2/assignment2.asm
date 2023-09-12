.data
prompt_x: .asciiz "Enter the value of x: "  # Prompt for x
prompt_y: .asciiz "Enter the value of y: "  # Prompt for y
prompt_z: .asciiz "Enter the value of z: "  # Prompt for z
result_msg: .asciiz "Result (x - y - z): "  # Message for the result
welcome_msg: .asciiz "Welcome to the integer subtraction program!\n"
input_msg: .asciiz "Please enter 3 integers for x, y, and z to be subtracted from each other.\n"

.text

main:
    # Display welcome message
    # This is load instructions to the system.
    # 4 is the code for print string.
    li $v0, 4
    # This loads the address of the string 'welcome_msg' into register $a0.
    la $a0, welcome_msg
    # This tells the system to execute the syscall, which prints the provided string.
    syscall
    
    # Display input message
    li $v0, 4
    la $a0, input_msg
    syscall

    # Display input prompts and take in the value given.
    
    # Input x
    li $v0, 4
    la $a0, prompt_x
    syscall
    # 5 is the code for read integer
    li $v0, 5
    syscall
    # This moves the value in register $v0 into register $t0.
    move $t0, $v0  # Store x in $t0

    # Input y
    li $v0, 4
    la $a0, prompt_y
    syscall
    li $v0, 5
    syscall
    move $t1, $v0  # Store y in $t1

    # Input z
    li $v0, 4
    la $a0, prompt_z
    syscall
    li $v0, 5
    syscall
    move $t2, $v0  # Store z in $t2

    # Calculate x - y - z
    # This subtracts the value in register $t1 from the value in register $t0 and stores the result 
    # in register $t3.
    # subu is used instead of sub because the inputs are unsigned integers instead of signed integers.
    subu $t3, $t0, $t1   # $t3 = x - y
    # This subtracts the value in register $t2 from the value in register $t3 and stores the result in 
    # register $t3.
    subu $t3, $t3, $t2   # $t3 = (x - y) - z

    # Display the result in decimal
    li $v0, 4
    la $a0, result_msg
    syscall

    # 1 is the code for print integer
    li $v0, 1
    # This moves the value in register $t3 into register $a0.
    move $a0, $t3 # Store difference value in $a0
    syscall

    # Exit the program
    # 10 is the code for exit
    li $v0, 10
    syscall
