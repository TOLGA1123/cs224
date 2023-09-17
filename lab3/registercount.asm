.text
	la $a0, message1
	li $v0, 4
	syscall
	li $v0, 5
	syscall	
	bgt $v0, 31, exit		#if input is not in range [0-31] exit program
	blt $v0, 0, exit
	move $a0, $v0			#$a0 is register number that will be counted
	la $a1, Test_Start		#Starting address of the test 			#can be changed to different parts of the program
	la $a2, Test_Finish		#Ending address of the test			#can be changed to different parts of the program
	jal Count_Register
	move $a3, $v0			#copy count to $a3
	la $a0, message2
	li $v0, 4
	syscall
	move $a0, $a3			#print count
	li $v0, 1
	syscall
	
	exit:
	li $v0, 10
	syscall

#inputs $a0 = register that will be counted, $a1 = starting address, $a2 = ending address
#$s0, $s1, $s2 is for inputs,  $s3 = instruction in hex #$s4, $s5, $s6, $s7	
Count_Register:
	addi $sp, $sp, -32	#save $s registers in stack
	sw $s0, 28($sp) 
	sw $s1, 24($sp) 
	sw $s2, 20($sp) 
	sw $s3, 16($sp) 
	sw $s4, 12($sp) 
	sw $s5, 8($sp) 
	sw $s6, 4($sp)
	sw $s7, 0($sp)
	move $s0, $a0		#$s0 = input register
	move $s1, $a1		#$s1 = start address of testing
	move $s2, $a2		#$s2 = end address of testing
	li $v0, 0		#hold return count in $v0
loop:
	lw $s3, 0($s1)		#$s3 = instruction in hex			#must be in loop
	srl $s4, $s3, 26	#$s4 = opcode of instruction
	bgt $s1, $s2, endCount	#bgt ? beq?
	beq $s4, 0, R_type
	bgt $s4, 3, I_type
	#else J_type
	J_type:		#there is no register used in J_type		
	j continue3
	 
	R_type:
	sll $s5, $s3, 16
	srl $s5, $s5, 27		# getting rd for $s5
	beq $s5, $s0, increment1
	continue1:
	sll, $s5, $s3, 11
	srl $s5, $s5, 27		#getting rt for $s5	
	beq $s5, $s0, increment2
	continue2:
	sll $s5, $s3, 6
	srl $s5, $s5, 27		#getting rs for $s5	
	beq $s5, $s0, increment3
	j continue3			#necessary to end R_type here
	I_type:
	sll $s5, $s3, 11
	srl $s5, $s5, 27		#getting rt for $s5
	beq $s5, $s0, increment4
	continue4:
	sll $s5, $s3, 6
	srl $s5, $s5, 27		#getting rs for $s5
	beq $s5, $s0, increment5 
	
	continue3:
	addi $s1, $s1, 4	#increment pointer
	j loop
	
	increment1:
	addi $v0, $v0, 1	#increment count
	j continue1
	increment2:
	addi $v0, $v0, 1	#increment count
	j continue2
	increment3:
	addi $v0, $v0, 1	#increment count
	j continue3
	increment4:
	addi $v0, $v0, 1	#increment count
	j continue4
	increment5:
	addi $v0, $v0, 1	#increment count
	j continue3
endCount:
	lw $s0, 28($sp)		#restore s registers
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $s4, 12($sp)
	lw $s5, 8($sp)
	lw $s6, 4($sp)
	lw $s7, 0($sp)
	addi $sp, $sp, 32
	jr $ra 			#count in $v0

Test_Start:	#enter instructions here to test
	add $t2, $t2, $t1		#twice count rt
	addi $t0, $t0, 0
	addi $t2, $t2, 0
	la $t5, test
	jr $t5
	add $t4, $t5, $t6		#not executed but still counts as the pointer points all rows of the test part
	test:
	
Test_Finish:

.data
	message1: .asciiz "Enter register number 0-31 (other to exit) : "
	message2: .asciiz "\n Number of times this register is used: "
