#CS224
#Lab No. 6
#Section No. 6
#Abdullah Riaz
#22001296
#24/04/2022


.text

main:	
	li $v0, 4
	la $a0, menuOption
	syscall
	
	#load input characters
	li $t0, 'a'
	li $t1, 'b'
	li $t2, 'c'
	li $t3, 'd'
	li $t4, 'e'
	li $t5, 'x'

	# read character input
	li $v0, 12 
	syscall
	move $v1, $v0
	
	la $a0, nextLine
	li $v0, 4
	syscall	
	
	move $v0, $v1
	
	#call choosen option
	beq $v0, $t0, createUserMatrix
	beq $v0, $t1, createSelfMatrix
	beq $v0, $t2, displaySpecific
	beq $v0, $t3, displayFull
	beq $v0, $t4, unav
	beq $v0, $t5, quit
	
	# check if invalid input
	li $v0, 4
	la $a0, wrongInput
	syscall
	j main	
	
	
createUserMatrix:
	# Take Input 
	la $a0, sizePrompt 
	li $v0, 4
	syscall
     	#Read Input
     	li $v0, 5
     	syscall
     	#find size in amount of bytes
     	mul $s0,$v0, $v0
     	move $s3, $s0    #keep number of total elements for loop
     	move $s1, $s3    #keep size for global usage
     	move $s7, $v0    #keep N for global usage
     	mul $s0, $s0, 4
     	move $a0, $s0
	li $v0, 9
        syscall   
        move $s2, $v0  #save array address beginning
	move $s5, $s2  #copy of array address
	move $s4, $0   #initialize
	
loopUser:
     	beq $s4, $s3, main # size > i
     	la $a0, elementValIn    
	li $v0, 4
        syscall
	   
	#Read Input
     	li $v0, 5
     	syscall
       
     	sw $v0, 0($s5)
 	addi $s5, $s5, 4
 	addi $s4, $s4, 1
 	j loopUser	

createSelfMatrix:
	# Take Input 
	la $a0, sizePrompt 
	li $v0, 4
	syscall
     	#Read Input
     	li $v0, 5
     	syscall
     	#find size in amount of bytes
     	mul $s0,$v0, $v0
     	move $s3, $s0    #keep number of total elements for loop
     	move $s1, $s3    #keep size for global usage
     	move $s7, $v0    #keep N for global usage
     	mul $s0, $s0, 4
     	move $a0, $s0
	li $v0, 9
        syscall   
        move $s2, $v0  #save array address beginning
	move $s5, $s2  #copy of array address
	li $s4, 1   #initialize
	
loopSelf:
     	bgt $s4, $s3, main # size > i
     	sw $s4, 0($s5)
 	addi $s5, $s5, 4
 	addi $s4, $s4, 1
 	j loopSelf		

displayFull:
	move $s5, $s2  #get address start
	move $t1, $s1  #get no of elements
	li $s4, 0
	j printLoop

printLoop:
	beq $s4, $t1, main # size > i
     	lw $a0, 0($s5)
     	li $v0, 1
	syscall
	la $a0, sumSpace
	li $v0, 4
	syscall	
 	addi $s5, $s5, 4
 	addi $s4, $s4, 1
 	div $s4, $s7
 	mfhi $t6
 	bne $t6, 0, norm
 	jal Rowspace
 	norm:
 	j printLoop	
 	
displaySpecific:
	blt $s7, 1, invalidInp
	# Take Input 
	la $a0, rowInput 
	li $v0, 4
	syscall
     	#Read Input
     	li $v0, 5
     	syscall
     	
     	move $t0, $v0  #save column
     	blt $t0, 1, invalidInp
     	bgt $t0, $s7, invalidInp
     	
     	# Take Input 
	la $a0, colInput 
	li $v0, 4
	syscall
     	#Read Input
     	li $v0, 5
     	syscall
     	
     	move $t1, $v0  #save row
     	blt $t1, 1, invalidInp
     	bgt $t1, $s7, invalidInp
     	
     	addi $t0, $t0, -1
	addi $t1, $t1, -1  
	mul $t3, $t0, $s7
	mul $t3, $t3, 4
	mul $t4, $t1, 4
	add $t3, $t3, $t4
	
	move $t0, $s2
	add $t3, $t3, $t0
	lw $a0, ($t3)
	li $v0, 1
	syscall
	j main
	 
     	
invalidInp:
	la $a0, wrongInput
	li $v0, 4
	syscall	
	j main
	
Rowspace:
	la $a0, nextLine
	li $v0, 4
	syscall	
	jr $ra

unav:
	la $a0, unavailable
	li $v0, 4
	syscall
	j main

quit:
	li $v0, 10	
	syscall
			
					
.data	
	sizePrompt: .asciiz "\n Enter Size of Matrix(N): "
	elementValIn: .asciiz "\n Enter Value: " 
	wrongInput: .asciiz "\n \n Please enter valid input next time. Back to menu you go \n " 
	nextLine: .asciiz "\n"
	sumSpace: .asciiz "    |   "
	unavailable: .asciiz "\n This function was not able to be completed :/ .Please Try Another option in the menu "
	colInput: .asciiz "\n Enter Column Number: "
	rowInput: .asciiz "\n Enter Row Number: "
	menuOption: .asciiz "\n Main Menu \n Press (a) to manually enter Matrix Elements \n Press (b) to enter matrix size for matrix elements with incremental values(1,2,3,4)  \n Press (c) to dipslay desired matrix element using row and column number  \n Press (d) to display entire matrix row by row \n Press (e) to copy matrix to another  \n Press (x) to quit \n "