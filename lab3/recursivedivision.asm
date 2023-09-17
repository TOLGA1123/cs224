.text
	la $a0, message1
	li $v0, 4
	syscall 
	li $v0, 5
	syscall			#getting dividend
	move $a2 ,$v0		#save it to $a2
	la $a0, message2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a1, $v0		#getting divisor
	move $a0, $a2		#dividend in $a0, divisor in $a1
	li $v0, 0
	jal recursiveDivision
	move $a3, $v0		#copy the result in $a3
	move $a2, $a0		# copy remainder in $a0 to $a2
	la $a0, message3
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $a3		#print result
	syscall
	la $a0, message4
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $a2
	syscall
	li $v0, 10
	syscall
#a recursive MIPS subprogram that performs integer division of two positive numbers by successive subtractions
#arguments $a0 = dividend, $a1 = divisor   #return $v0 integer division result		 $a0 = remainder 
recursiveDivision:
	addi $sp, $sp, -12	#allocate store
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	addi $s0, $a0, 0	#$s0 = dividend
	addi $s1, $a1, 0	#$s1 = divisor
	bge $s0, $s1, continue	#if dividend >= divisor continue
	addi $sp, $sp, 12
	jr $ra
	continue:
	addi $v0, $v0, 1
	sub $a0, $a0, $a1	#subtract		#$a0, $a1 changed dont use $s0 and $s1 here	# $a0 is remainder in the last recursion
	jal recursiveDivision
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12 
	jr $ra
	


.data
message1: .asciiz "\n Enter dividend (positive integer) : "
message2: .asciiz "\n Enter divisor (positive integer) : "
message3: .asciiz "\n The result of the division: "
message4: .asciiz "\n Remainder: "
