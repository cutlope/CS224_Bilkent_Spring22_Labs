.text

main:	
	jal createArray
	move $a0 ,$v0
	move $a1 ,$v1
	jal bubbleSort
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
     	mul $s0,$v0, 4 
     	move $a0, $v0
	li $v0, 9
        syscall   
        move $s2, $v0  #save array address beginning
	move $s5, $s2  #copy of array address

loop:
	move $s3, $s0   #s3 has size
     	beq $s4, $s3, ret # size > i
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

bubbleSort:	
	addi $sp, $sp, -24
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	
    	move $s4, $a1
	beq $s4, 1 , processSortedArray
	sort:
		move $s0 , $a0
		li $s1, 1
	swap:
		lw $s2, 0($s0)
		lw $s3, 4($s0)	
		ble $s2, $s3, skip
		sw $s2, 4($s0)
		sw $s3, 0($s0)
		skip:
			addi $s0, $s0, 4
			addi $s1, $s1, 1
			blt $s1, $a1, swap
		addi $s4, $s4, -1
		bgt $s4, 1, sort



processSortedArray:
		move $s0, $a0 #adress
		move $s1, $a1 
		li $s2, 0
	display:	
		beq $s2, $s1, done
		
		move $a0, $s2		#index display
		li $v0, 1
		syscall
		
		la $a0, spaceBw		#space
		li $v0, 4
		syscall
		
		lw $a0, 0($s0)		#display digit
		li $v0, 1
		syscall
		
		la $a0, spaceBw		#space
		li $v0, 4
		syscall
		
		lw $a0, 0($s0)
		move $s3, $ra
		jal digitSum
		move $ra, $s3
		move $a0, $s4
		li $v0, 1
		syscall
		
		la $a0, newline		#snewline
		li $v0, 4
		syscall		
		
		addi $s0, $s0, 4
		addi $s2, $s2, 1
		j display
				
digitSum:
	move $s4, $a0
	div $s4, $s4, 10
	mflo $s4 
	mfhi $s5
	add $s4, $s4, $s5
	jr $ra
	

done:
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $s4, 4($sp)
	lw $s5, 0($sp)
	addi $sp, $sp, 24
	jr $ra
	
	

.data	
	sizePrompt: .asciiz "Enter Size of Array in Words: "
	prompt:	.asciiz "Enter Number of Elements: "
	elementValIn: .asciiz "\n Enter Value: " 
	spaceBw: .asciiz "    "
	newline: .asciiz "\n"
