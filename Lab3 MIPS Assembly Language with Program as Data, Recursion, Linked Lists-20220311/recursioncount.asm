#CS224
#Lab No. 3
#Section No. 6
#Abdullah Riaz
#22001296
#11/03/2022


.text

main:
	la $a0, numPrompt		
	li $v0, 4
	syscall
	
	li $v0, 5		#take input for dividend
     	syscall
     	
     	blt $v0, 0 , wrongInput 	#divide by negative numeber not allowed
   
	move $a1, $v0			#save value of input
	
	la $a0, diviPrompt	
	li $v0, 4
	syscall
	
	li $v0, 5		#take input for divisor
     	syscall
     	blt $v0, 1 , zeroInput  #divide by zero or negative number not allowed
     	
	move $a2, $v0		#save value of input
	
	jal RecursiveDivision
	
	la $a0, repPrompt
	li $v0, 4
	syscall
	
	li $t0, 'a'		#saving menu options
	li $t1, 'x'

	li $v0, 12 
	syscall
	
	beq $v0, $t0, main
	beq $v0, $t1, quit
	
RecursiveDivision:
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp) 
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s7, 24($sp)
	
	move $s1, $a1
	move $s2, $a2
	addi $s3, $s3, 0	#quotient
	
	divLoop:
		blt $s1, $s2, done
		sub $s1, $s1, $s2
		addi $s3, $s3, 1
	
		j divLoop	#recursive call
	
	done:
		la $a0, quoPrompt
		li $v0, 4
		syscall
		move $a0, $s3
		li $v0, 1
		syscall
		
		la $a0, remPrompt
		li $v0, 4
		syscall
		move $a0, $s1
		li $v0, 1
		syscall
		
		lw $s0, 0($sp)
		lw $s1, 4($sp) 
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s7, 24($sp)
		addi $sp, $sp, 28
		
		jr $ra
	
		
wrongInput: 
	la $a0, wrongInputPrompt		
	li $v0, 4
	syscall
	j main
	
zeroInput:
	la $a0, lessThanZeroInputPrompt		
	li $v0, 4
	syscall
	j main
					
quit:
	li $v0, 10	
	syscall
	
	
.data
	numPrompt: .asciiz "\n Enter Dividend:  "
	diviPrompt: .asciiz "\n Enter Divisor:  "
	quoPrompt: .asciiz "\n The Quotient is: "
	remPrompt: .asciiz "\n The Reminder is: "
	repPrompt: .asciiz "\n Do you want to repeat? Enter (a) to repeat , (x) to quit \n"
	wrongInputPrompt: .asciiz "\n Please Enter a postive number"
	lessThanZeroInputPrompt: .asciiz "\n Only postive number greater than 0 allowed as divisor. Program will be restarted "
