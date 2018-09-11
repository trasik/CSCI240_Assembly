#Project 2: Fibonacci Sequence
#Note: Any number greater than 46 will cause an overflow
#Torendra Rasik
#Section: 6:30 - 7:45 P.M
#Karanvir Singh
#Section 8:00 - 9:15 P.M

#Based on C++ code 
#		int fib(int n) {  //Procedure
#    		if (n == 0) return 0;  
#    		if (n <= 2) return 1;
#   		return fib(n - 1) + fib(n - 2);
#		}

		.data
Enter:		.asciiz "\nPlease enter a integer above 0 to represent the corresponding Fibonacci Sequence: "
Result: 	.asciiz "\nThe corresponding Nth Fibonacci number is: "
GThan46_1:	.asciiz "\nThe sequence number you've entered is greater than 46 which will cause the program to run slower"
GThan46_2:	.asciiz "\nTo ensure efficiency, the program will now close."
		.globl main 
		.text
main:		
		li $v0, 4 #Load in a string
		la $a0, Enter #Load in the prompt Enter
		syscall #Perform a system call
			
		li $v0, 5 #Load in a integer
		syscall #Perform a system call
		
		#Special case for when any number greater than 46 is entered
		#This will generate an overflow so branch to stop this
		bgt $v0, 46, greaterthan46 #Branch to the lavel greaterthan46
		
		move $a0, $v0 #Move the entered number into $a0 in order to be used
		jal fib #Call procedure to calculate the fibonacci of the number
		move $s0, $v0 #Move the returning value of $v0 into a saved register
		
		li $v0, 4 #Load in a string
		la $a0, Result #Load in the prompt Enter
		syscall #Perform a system call
		li $v0,1 #Load in a print int
		move $a0, $s0 #Move $s0 into $a0 in order to be printed
		syscall #Perform a system call
		
		b finished #Branch to finished label after printing the result
fib:
		li $t0, 0 #Load 0 into $t0 in order to use for check
		beq $a0, $t0, rzero #Branch to the special case of 0
else1:
		#If $v0 is less than or equal to 2 which is the base case
		li $t0,2 #Load 2 into $t0 in order to use for check
		ble $a0, $t0, basecase #Branch to the basecase'
else2:
		addi $sp,$sp,-4 #Pop back the stack in order to make space for two registers
		sw $ra,0($sp) #Save the address of ra on the stack
		addi $a0,$a0,-1 #($a0 - 1) == (n - 1) decrement the counter
		jal fib #Call fib again to reach the base case 
		addi $a0,$a0,1 #Add back 1 to $a0 for the number of times it takes to reach the base case
		lw $ra,0($sp) #Restore ra
		addi $sp,$sp,4 #Restore sp
		addi $sp,$sp,-4 #Pop back the stack in order to make space for the new $v0 - 1
		sw $v0,0,($sp) #Save the fib(n-l) in $v0
		
		addi $sp, $sp, -4 #Pop back the stack in order to make space for two registers
		sw $ra, 0($sp) #Save the address of ra on the stack
		addi $a0, $a0, -2 #($a0 - 2) == (n - 2) decrement the counter
		jal fib #Call fib to reach the base case
		addi $a0, $a0, 2 #Add back 2 for the number of times it takes to hit the base case
		lw $ra, 0($sp) #Restore ra
		addi $sp, $sp, 4 #Restore sp
		lw $t0, 0($sp) #Save fib(n-2) in $t0
		
		addi $sp,$sp, 4 #Restore the sp back to 0
		add $v0,$v0,$t0  #Add fib(n-1) + fib(n-2) stored in $v0 and $t0
		
		jr $ra #Return back to main and the answer back into $v0
		
basecase:
		li $v0, 1 #Return 1 if $v0 is either 1 or 2
		jr $ra #Retrace back to fib procedure to the jal instruction
rzero:
		li $v0, 0 #Special case where 0 is entered 
		jr $ra  #Return back to main
greaterthan46:
		li $v0, 4 #Load in a string
		la $a0, GThan46_1 #Load in the prompt GThan46_1
		syscall #Perform a system call
		li $v0, 4#Load in a string
		la $a0, GThan46_2 #Load in the prompt GThan46_1
		syscall #Perform a system call
finished:
