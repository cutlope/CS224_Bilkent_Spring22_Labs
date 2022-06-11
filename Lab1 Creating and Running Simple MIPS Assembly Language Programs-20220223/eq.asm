.text
	la $a0, aVal
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	addi $s0, $v0, 0	#s0 is a
	
	la $a0, bVal
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	addi $s1, $v0, 0    #s1 is b
	

	sub $t0, $s0, $s1    # a - b
	mul $t1, $s0, $s1    # a * b
	sub $t2, $t1, $s1    # ba - b
	div $t2, $s0	     # (ba - b) % a
	mfhi $t3             #t3 is mod result
	beq $0, $t3, divZero
	div $t0, $t3        
	mflo $s3              #move answer to s3


done:
	li $v0, 4
	la $a0, answer		
	syscall
    	move $a0, $s3
	li $v0, 1
	syscall
	li $v0, 10	
	syscall	

divZero: 
	li $v0, 4
	la $a0, divByZero		
	syscall
	li $v0, 10	
	syscall	
	
	
	
.data
	aVal:	.asciiz "Enter a: "
	bVal:	.asciiz "Enter b: "
	cVal:	.asciiz "Enter c: "
	answer:	.asciiz "Answer: "
	divByZero: .asciiz "Div by Zero Detected :("