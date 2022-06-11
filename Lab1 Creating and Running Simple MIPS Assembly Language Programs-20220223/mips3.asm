.text
	# Take Input
	la $a0, prompt 
	li $v0, 4
	syscall
     
     	#Read Input
     	li $v0, 5
     	syscall
     	
     	#size stored at s0
     	sw $v0, size
     	
     	#check count of inputs
     	addi $t0, $0, 0
     	
     	#manage array address
     	addi $t1, $0, 0
	
loop:
	lw $t2, size
     	beq $t0, $t2, menu
     	la $a0, elementValIn 
	li $v0, 4
        syscall
	   
	#Read Input
     	li $v0, 5
     	syscall
     	
     	   
     	sw $v0, array($t1)
 	addi $t1, $t1, 4
 	addi $t0, $t0, 1
	j loop
	

menu: 
	li $v0, 4
	la $a0, menuMsg
	syscall
	
	#load input characters
	li $t0, 'a'
	li $t1, 'b'
	li $t2, 'c'
	li $t3, 'x'
	
	# read character input
	li $v0, 12 
	syscall
	
	
	#call choosen option
	beq $v0, $t0, optA
	beq $v0, $t1, optB
	beq $v0, $t2, optC
	beq $v0, $t3, quit
	
	# check if invalid input
	li $v0, 4
	la $a0, wrongInput
	syscall
	j menu
	
	
optA:
    	li $v0, 4
	la $a0, elementValIn
	syscall
	li $v0, 5
	syscall
	sw $v0, inputOption
	li $v0, 4
	la $a0, newline
	syscall
	jal sumLessThanInput
	j menu

optB:
	jal sumOfEvenOdd
	j menu
optC:
    	li $v0, 4
	la $a0, elementValIn
	syscall
	li $v0, 5
	syscall
	sw $v0, inputOption
	li $v0, 4
	la $a0, newline
	syscall
	jal notDivByInput
	j menu

quit:
	li $v0, 10	
	syscall

sumLessThanInput:
	la $s0, array
	addi $s1, $0, 0 #loop counter
	sw $0, sum #sum = 0 
	lw $t2, size
	lw $t3, inputOption
	
	loopSum:
		slt $t0, $s1, $t2
		beq $t0, $0, done
		sll $t0, $s1, 2
		add $t0, $t0, $s0
		lw $t1, 0($t0)
		blt $t1, $t3, sumLessThan
		addi $s1, $s1, 1
		j loopSum
		
	sumLessThan:
		lw $t4, sum
		add $t4, $t4, $t1
		sw $t4, sum
		addi $s1, $s1, 1
		j loopSum	
	done:
		la $a0, result
		li $v0, 4
		syscall
		li $v0, 1
		lw $a0, sum
		syscall
	jr $ra
	
sumOfEvenOdd:
	la $s0, array
	lw $t2, size 
	sw $0, evensum 
	sw $0, oddsum 
	addi $s1, $0, 0 # reset
	
	loopAll:
		slt $t0, $s1, $t2
		beq $t0, $0, finalResult
		sll $t0, $s1, 2
		add $t0, $t0, $s0
		lw $t1, 0($t0)
		rem $t5, $t1, 2
		beq $t5, 0, AddToEvenTotal
		j AddToOddTotal
		addi $s1, $s1, 1
		j loopAll
		
	AddToEvenTotal:
		lw $t4, evensum
		addi $t4, $t4, 1
		sw $t4, evensum
		addi $s1, $s1, 1
		j loopAll
			
	AddToOddTotal:
		lw $t4, oddsum
		addi $t4, $t4, 1
		sw $t4, oddsum
		addi $s1, $s1, 1
		j loopAll
		
	finalResult:
		la $a0, evenPromt
		li $v0, 4
		syscall
		li $v0, 1
		lw $a0, evensum
		syscall
		la $a0, oddPromt
		li $v0, 4
		syscall
		li $v0, 1
		lw $a0, oddsum
		syscall
	jr $ra

notDivByInput:
		sw $0, totalNotDiv
		addi $s1, $0, 0
		la $s0, array	
		lw $t2, size
		lw $t3, inputOption
	
	loopNotDiv:
		slt $t0, $s1, $t2
		beq $t0, $0, doneNotDiv
		sll $t0, $s1, 2
		add $t0, $t0, $s0
		lw $t1, 0($t0)
		rem $t5, $t1, $t3
		bne $t5, 0, AddToNotDivSum
		addi $s1, $s1, 1
		j loopNotDiv
		
		
	AddToNotDivSum:
		lw $t4, totalNotDiv
		addi $t4, $t4, 1
		sw $t4, totalNotDiv
		addi $s1, $s1, 1
		j loopNotDiv
		
	doneNotDiv:
		la $a0, notDivPromt
		li $v0, 4
		syscall
		li $v0, 1
		lw $a0, totalNotDiv
		syscall
	jr $ra
			
.data
	array: .space 400
	inputOption: .word 0
	size: .word 0
	sum: .word 0
	evensum: .word 0
	oddsum: .word 0
	totalNotDiv: .word 0
	prompt:	.asciiz "\n Enter Number of Elements: "
	result: .asciiz "The result is :"
	elementValIn: .ascii "\n Enter Value: " 
	newline: .asciiz "\n" 
	wrongInput: .asciiz "Please enter valid input"
	menuMsg: .asciiz "\n Main Menu \n Press (a) for Sum of Numbers less than your input  \n Press (b) for to display number of even and odd numbers.  \n Press (c) to display nummber of array elements not divisible by your input \n Press (x) to quit \n "
	evenPromt: .asciiz "\n Total Even: "
	oddPromt: .asciiz "\n Total Odd: "
	notDivPromt: .asciiz "\n Total Not Divisible: "
