#CS224
#Lab No. 3
#Section No. 6
#Abdullah Riaz
#22001296
#10/03/2022

.text

main:
	la $a0, main  #000000 000000  000000 01100  = opcode
	la $a1, mainEnd
	jal instructionCount	#run count for main 
	
	move $t0, $a0		#saving returned answer in temp registers
	move $t1, $a1
	move $t2, $a2
	
	la $a0, mainPrompt	#prompt 
	li $v0, 4
	syscall
	
	la $a0, addPrompt	
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	
	la $a0, oriPrompt
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	
	la $a0, lwPrompt
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	
	la $a0, insCountPrompt
	li $v0, 4
	syscall
	
	la $a0, instructionCount
	la $a1, instrFinal
	jal instructionCount		#run count for instructionCount 
	
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2

	la $a0, addPrompt
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	
	la $a0, oriPrompt
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	
	la $a0, lwPrompt
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 10
mainEnd:
	syscall			#last instruction in main prog

instructionCount:
	addi $sp, $sp, -28	#making space for varibles in stack
	sw $s0, 0($sp)
	sw $s1, 4($sp) 
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s7, 24($sp)
	
	move $s0, $a0
	move $s1, $a1
	addi $s2, $s2, 0	#counter for add
	addi $s3, $s3, 0	#counter for ori
	addi $s7, $s7, 0	#counter for lw
	
	move $s4, $s0 		#Make a copy of start address to be able to modify
	
	checkLoop:
		bgt $s4, $s1, done
		lw $s0, 0($s4)
		#add check
		li $s5,0	#opcode of add in decimal
		srl $s6, $s0, 26
		beq $s5, $s6, incrementAddFuncCheck	
		
		#ori check
		li $s5, 13	#opcode of ori in decimal
		beq $s5, $s6, incrementOri	
		
		#lw check
		li $s5, 35	#opcode of lw in decimal
		beq $s5, $s6, incrementLw	
		addi $s4, $s4, 4
		j checkLoop
		
	incrementAddFuncCheck:
		andi $s6,$s0, 63	#using masking to get function code 
		li $s5, 32		#function code of add is 32 in decimal
		beq $s5, $s6, incrementAdd
		addi $s4, $s4, 4
		j checkLoop

	incrementAdd:
		addi $s2, $s2, 1
		addi $s4, $s4, 4
		j checkLoop
	
	incrementOri:
		addi $s3, $s3, 1
		addi $s4, $s4, 4
		j checkLoop
	
	incrementLw:
		addi $s7, $s7, 1
		addi $s4, $s4, 4
		j checkLoop
	done:
		move $a0, $s2		#saving answers
		move $a1, $s3
		move $a2, $s7
		
		lw $s0, 0($sp)		#deallocating space in stack 
		lw $s1, 4($sp) 
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s7, 24($sp)
		addi $sp, $sp, 28
instrFinal:	
		jr $ra


.data
	mainPrompt: .asciiz "\n Passing Main "
	insCountPrompt: .asciiz "\n Passing instructionCount"
	addPrompt: .asciiz "\n The number of add instructions : "
	oriPrompt: .asciiz "\n The number of ori instructions : "
	lwPrompt: .asciiz "\n The number of lw instructions : "
