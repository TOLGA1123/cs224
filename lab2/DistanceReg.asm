.text
Continue:
	bne $a3, $0, Stop	#input = 1 branch to stop
	
	jal GetValues		#$v0 = first value, $v1 = second value
	move $a1, $v0		#first register $a1	decimal
	move $a2, $v1		#second register $a2	decimal
	jal DisplayRegisters
	jal FindDistance
	move $a3, $v0		#copy hamming distance to $a3
	la $a0, message5
	li $v0, 4
	syscall
	li $v0,1 
	move $a0, $a3
	syscall
	
	la $a0, message0
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a3, $v0
	j Continue
Stop:
	li $v0, 10		#exit
	syscall
#Subprogram that get values to be assigned to the registers from the user
GetValues:
	addi $sp, $sp, -8
	sw $s0, 0($sp)		#store $s0
	sw $s1, 4($sp)		#store $s1
	la $a0, message1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s0, $v0		#copy first value to $s0
	la $a0, message2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s1, $v0		#copy second value to $s1
	move $v0, $s0		#return first value in $v0
	move $v1, $s1		#return second value in $v1
	lw $s1, 4($sp)		#restore $s1
	lw $s0, 0($sp)		#restore $s0
	addi $sp, $sp, 8	#deallocate stack space
	jr $ra
#Subprogram that displays register values in hex	#syscall 34
DisplayRegisters:
	la $a0, message3
	li $v0, 4
	syscall
	li $v0, 34		#34 = hexadecimal form, 35 = binary form
	move $a0, $a1		#first value to print
	syscall
	la $a0, message4
	li $v0, 4
	syscall
	li $v0, 34		#34 = hexadecimal form, 35 = binary form
	move $a0, $a2		#second value to print
	syscall
	jr $ra
	
#Subprogram that finds the Hamming Distance between two registers	assuming binary form to calculate differences idk?
FindDistance:
	addi $sp, $sp, -20
	sw, $s0, 0($sp)		#save $s0
	sw $s1, 4($sp)		#save $s1
	sw $s2, 8($sp)		#save $s2
	sw $s3, 12($sp)		#save $s3
	sw $s4, 16($sp)		#save $s4	
	addi $s0, $s0, 0	#$s0 = distance
	move $s1, $a1		#$s1 = first value
	move $s2, $a2		#$s2 = second value
	xor $s3, $s1, $s2	#$s3 = first value xor second value (x)
while: 				#hamming distance with integers algorithm
	ble $s3, $0, done
	andi $s4, $s3, 1	#$s4 = x & 1
	add $s0, $s0, $s4	#add distance
	srl $s3, $s3, 1		#x = >>1
	j while
done:	
	move $v0, $s0		#return distance in $v0
	lw $s0, 0($sp)		#restore $s0
	lw $s1, 4($sp)		#restore $s1
	lw $s2, 8($sp)		#restore $s2
	lw $s3, 12($sp)		#restore $s3
	lw $s4, 16($sp)		#restore $s4
	addi $sp, $sp, 20	#deallocate space
	jr $ra

.data
message0: .asciiz "\n Enter 0 to continue, Enter 1 to stop: "
message1: .asciiz "\n Enter a value to register1: "
message2: .asciiz "\n Enter a value to register2: "
message3: .asciiz "\n Register1 value in hex: "
message4: .asciiz "\n Register2 value in hex: "
message5: .asciiz "\n Hamming distance between two registers: "
