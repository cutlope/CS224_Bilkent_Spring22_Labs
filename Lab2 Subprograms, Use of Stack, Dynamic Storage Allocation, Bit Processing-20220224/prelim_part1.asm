.text

	# Take Input
	la $a0, valuPrompt 
	li $v0, 4
	syscall
	
	#Read Input
     	li $v0, 5
     	syscall
	
	# storing in memory
	sw $v0, intVal
	
	# Take Input
	la $a0, shiftValuPrompt
	li $v0, 4
	syscall
	
	#Read Input
     	li $v0, 5
     	syscall
	# storing in memory
	sw $v0, shiftVal
		
menu: 
	li $v0, 4
	la $a0, shiftDirection
	syscall
	
	#load input characters
	li $t0, 'a'
	li $t1, 'b'
	li $t2, 'x'
	
	# read character input
	li $v0, 12 
	syscall
	
	
	#call choosen option
	lw $a0, intVal
	lw $a1, shiftVal
	beq $v0, $t0, shiftLeft
	beq $v0, $t1, shiftRight
	beq $v0, $t2, quit

	# check if invalid input
	li $v0, 4
	la $a0, wrongInput
	syscall
	j menu
		
shiftLeft:
	jal shiftLeftCircular
	move $t0 , $v0			#returned answer from v0 stored in t0 
	la $a0, valueAnswerPromt
	li $v0, 4
	syscall
	li $v0, 1
	lw $a0, intVal
	syscall
	la $a0, shiftAnswerPromt
	li $v0, 4
	syscall
	li $v0, 1
	lw $a0, shiftVal
	syscall
	la $a0, answerPromt
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 34
	syscall
	j menu
		
shiftRight:
	jal shiftRightCircular
	move $t0 , $v0			#returned answer from v0 stored in t0 
	la $a0, valueAnswerPromt
	li $v0, 4
	syscall
	li $v0, 1
	lw $a0, intVal
	syscall
	la $a0, shiftAnswerPromt
	li $v0, 4
	syscall
	li $v0, 1
	lw $a0, shiftVal
	syscall
	la $a0, answerPromt
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 34
	syscall
	j menu
shiftLeftCircular:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	rol $s3, $s0, $s1
	move $v0, $s3
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
shiftRightCircular:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	ror $s3, $s0, $s1
	move $v0, $s3
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
quit:
	li $v0, 10	
	syscall
					
.data
	intVal: .word
	shiftVal: .word
	answer: .word
	nextLine: .asciiz "\n"
	valuPrompt : .asciiz "Enter Value in decimal: " 
	shiftValuPrompt : .asciiz "Enter Shift Amount: " 
	answerPromt: .asciiz "\n The Answer is : "
	shiftAnswerPromt: .asciiz "\n The Shift Amount is : "
	valueAnswerPromt: .asciiz "\n The Value Amount is : "
	shiftDirection: .asciiz "\n Main Menu \n Press (a) for Left Shift(SLC) \n Press (b) for Right Shift(SRC) \n Press (x) to quit \n " 
	wrongInput: .asciiz "Please enter valid input"