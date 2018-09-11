# Torendra Rasik 4/15/17
# CS240 6:30pm - &:45pm Section
# Note: This program will not run if the input is between 0 and 1 as there is no integer,
# Input must be greater than 1.

			.data 
prompt: 	.asciiz "\n Please Input a value for N greater than or equal to 1: "
result:  	.asciiz "\n The sum of the integers from 1 to N is: "
FPN:		.asciiz "\n You've entered a Floating Point Number. The fractional part was truncated and the integer value will be used: "
bye:  		.asciiz "\n  **** Adios Amigo - Have a good day ****"
			.globl main 
			.text 
main:  
			li $v0, 4  # system call code for Print String 
			la $a0, prompt  # load address of prompt into $a0 
			syscall   # print the prompt message 
			
			li $v0, 6  # system call code for Read Integer 
			syscall   # reads the value of N into $v0 
			
			blez $v0,  end  # branch to end if  $v0  < =   0  
			li $t0, 0  # clear register $t0 to zero 
			
			mfc1 $t1, $f0  # move the floating point into register t1 (integer)
			srl $t2, $t1, 23 # shift the integer value by 23 and store it into t2
			add $s3, $t2, -127 # add 127 (bias) to the number of shifts done in order to get the exponent
		
			sll $t4, $t1, 9 # shift the integer by 9 left in order and
			srl $t5, $t4, 9 # shift it back by 9 right in order to zero out the integer
			add $t6, $t5, 8388608 # add 2^23 in order to add the implied bit back to the integer
		
			add $t7, $s3, 9 #add 9 to the exponent in order to determine how much to shift to get the fractional part
			sllv $s4, $t6, $t7 # shift the integer with the implied bit in order to get the fractional part 
			
			rol $t4, $t6, $t7 #rotate to the left in order to get the integer.
			
			li $t5, 31 # load 31 into temporary register
			sub $t2, $t5, $s3 # subtract t5 from s3 and store it into t2
			sllv $t5, $t4, $t2 # shift left logical variable by t2
			srlv $s5, $t5, $t2 # shift right logical variable and store into s5 which now holds the integer
			
			move $v0, $s5 #move the integer into $v0 so it can be used in the loop
			
			li $t0, 0 # reset t0 to 0 after the loop resets for a new input
			blez $t1, end #branch if t1 is less than zero
			beqz $s4, loop # go to the loop if the fractional part is equal to zero
			
			li $v0, 4 #load string value into v0
			la $a0, FPN #load tbe FPN message into a0
			syscall #print the message to the console
			
			li $v0, 1 # load in the integer input to v0
			move $a0, $s5 # move the integer value to a0
			syscall # print out the integer thats being used after truncating
			
			move $v0, $s5 #move the integer value into v0 after truncating the fraction
loop:   
			add  $t0, $t0, $v0  # sum of integers in register $t0 
			addi $v0, $v0, -1  # summing integers in reverse order 
			bnez $v0,  loop  # branch to loop if $v0 is != zero 

			li $v0, 4  # system call code for Print String 
			la $a0, result  # load address of message into $a0 
			syscall   # print the string 

			li $v0, 1  # system call code for Print Integer 
			move $a0,  $t0  # move value to be printed to $a0  
			syscall   # print sum of integers 
			b main  # branch to main 
			
end:  
			li $v0, 4  # system call code for Print String 
			la $a0, bye  # load address of msg. into $a0 
			syscall   # print the string 

			li $v0, 10  # terminate program run and 
			syscall   # return control to  system 
