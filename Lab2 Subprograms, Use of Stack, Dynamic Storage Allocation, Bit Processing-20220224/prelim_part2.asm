.text
  
main:	

	jal createArray
	move $a0 ,$v0
	move $a1 ,$v1
	jal arrayOperations
	li $v0, 10	
	syscall

createArray:
	addi $sp, $sp, -24
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	# Take Input
	la $a0, sizePrompt 
	li $v0, 4
	syscall
     
     	#Read Input
     	li $v0, 5
     	syscall
     	
     	#find size in amount of bytes
     	mul $s0,$v0, 0x00000004 
     	move $a0, $s1
	li $v0, 9
        syscall   
        move $s2, $v0  #save array address beginning
	move $s5, $s2  #copy of array address        
loop:
	move $s3, $s0
     	beq $s4, $s3, ret
     	la $a0, elementValIn 
	li $v0, 4
        syscall
	   
	#Read Input
     	li $v0, 5
     	syscall
       
     	sw $v0, 0($s5)
 	addi $s5, $s5, 4
 	addi $s4, $s4, 1
 	j loop
	
ret:         
	move $v0, $s2
        move $v1, $s0
        lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $s4, 4($sp)
	lw $s5, 0($sp)
	addi $sp, $sp, 24
        jr $ra
                
arrayOperations: 
	addi $sp, $sp, -32
	sw $s7, 28($sp)
	sw $s6, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	palCheck:
	
	lw $s3, 0($a0)		#s3 is min
	move $s4,$s3		#s4 is max
	addi $s5, $s5, 0        #s5 is sum
	
	arraypass:
		lw $s6, 0($s0)
		blt $s6, $s3, setMin
		j maxCheck
		setMin:
			move $s3, $s6
		maxCheck:
			bgt $s6, $s4, setMax
			j iterate
		setMax:
			move $s4, $s6
		iterate:
			add $s5, $s5, $s6 
			addi $s0, $s0,4
			subi $s1, $s1, 1
			bgt $s1, 0, arraypass
		
		move $a2, $a0		
menu:
	li $v0, 4
	la $a0, menuMsg
	syscall
	
	#load input characters
	li $s0, 'a'
	li $s1, 'b'
	li $s2, 'c'
	li $s6, 'd'
	li $s7, 'x'
	
	# read character input
	li $v0, 12 
	syscall
	
	#call choosen option
	beq $v0, $s0, minresult
	beq $v0, $s1, maxresult
	beq $v0, $s2, sumresult
	beq $v0, $s6, palindromeresult
	beq $v0, $s7, quitToMainProgram
	
	# check if invalid input
	li $v0, 4
	la $a0, wrongInput
	syscall
	j menu
	

minresult:
	#print result
	la $a0, minPrompt 
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	j menu
     	
maxresult:
	#print result
	la $a0, maxPrompt 
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $s4
	syscall
	j menu
	
sumresult:
	#print result
	la $a0, sumPrompt 
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $s5
	syscall
	j menu

palindromeresult:
	move $s0, $a2
	move $s1, $a1
	addi $s1, $s1, -1
	mul $s1, $s1, 4
	add $s1, $s1, $a2
	 palPass:
		lw $s6, 0($s1)       #end of array
		lw $s7, 0($s0)	     #start of array
		bne $s6, $s7, printFalse
 		bgt $s0, $s1, printTrue
 		addi $s1, $s1, -4
		addi $s0, $s0, 4
		j palPass
		
	printTrue:
		la $a0, isPalindrome 
		li $v0, 4
		syscall
		j menu
		
	printFalse:
		la $a0, notPalindrome 
		li $v0, 4
		syscall
		j menu
 	

quitToMainProgram:
	lw $s7, 28($sp)
	lw $s6, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $s4, 4($sp)
	lw $s5, 0($sp)
	addi $sp, $sp, 32
	j $ra
 
.data 
	sizePrompt: .asciiz "Enter Size of Array in Words:   "
	prompt:	.asciiz "Enter Number of Elements: "
	elementValIn: .asciiz "\n Enter Value: " 
	menuMsg: .asciiz "\n Main Menu \n Press (a) to display minimum value  \n Press (b) to display maximum value.  \n Press (c) to display sum of inputs.\n Press (d) to check palindrome. \n Press (x) to quit \n "
	sumPrompt: .asciiz "\n The Sum is: "	
	minPrompt: .asciiz "\n The Min is: "
	maxPrompt: .asciiz "\n The Max is: "
	wrongInput: .asciiz "Please enter valid input"
	notPalindrome: .asciiz "\n The array is not palndrome"
	isPalindrome: .asciiz "\n The array is  palndrome"