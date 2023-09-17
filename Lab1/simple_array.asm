	.text
# $t0: array pointer
# $t1: array element i
# $t2: array size    max 20
	la $t0, array			# $t0: pointing to the beginning address of the array
	addi $t1, $0, 0  		#i=0
	
	li $v0, 4
	la $a0, message1		# asking user for arraysize
	syscall
	li $v0, 5
	syscall
	move $t2, $v0			# copying array size to $t2
	
for:
	beq $t1, $t2, done		# if i == arraysize branch to done
	li $v0, 4
	la $a0, message2
	syscall
	li $v0, 5
	syscall
	sw $v0, ($t0)       		# filling the array
	addi $t1, $t1, 1         	# i=i+1
	addi $t0, $t0, 4		# increment $t0 by 4
	j for
done:
	li $v0, 4
	la $a0, message3
	syscall
	li $v0, 5
	syscall
	addi $s0, $v0, 0		# store input N to $s0   
	
	la $t0, array			# $t0: pointing to the beginning of the array
	li $t1, 0
	addi $t3, $0, 0  		#$t3: number of array members equal to N
	addi $t4, $0, 0  		#$t4: number of array members less than N
	addi $t5, $0, 0  		#$t5: number of array members greater than N
	addi $t6, $0, 0  		#$t6: number of array members evenly divisible by N
loop:	
	lw $a0, 0($t0) 			# $a0 = array[i]
	beq $t1, $t2, exitloop  	# if i == arraysize exit loop
	bne $a0, $s0, notequal		# if array[i] != N branch
	addi $t3, $t3,1
	notequal:
	bgeu $a0, $s0, notless		# if array[i] >= N branch
	addi $t4, $t4, 1
	notless:
	bleu $a0, $s0, notgreater	# if array[i] <= N branch
	addi $t5, $t5, 1
	notgreater:
	div $a0, $s0			# division array[i]/N   remainder goes to $hi
	mfhi $s1			#copy remainder to $s1 register
	bne $s1, $0, notdivisible	# if remainder == 0 it is divisible
	addi $t6, $t6,1
	notdivisible:
	addi $t1, $t1, 1		#increment array index i
	addi $t0, $t0, 4		#increment array pointer by 4
	j loop
	
exitloop:  
	#print number of elements equal to N
	 li $v0, 4
	 la $a0, message4
	 syscall
	 move $a0, $t3
	 li $v0, 1
	 syscall
	 #print number of elements less than N
	 li $v0, 4
	 la $a0, message5
	 syscall
	 li $v0, 1
	 move $a0, $t4
	 syscall
	 #print number of elements greater than N
	 li $v0, 4
	 la $a0, message6
	 syscall
	 li $v0, 1
	 move $a0, $t5
	 syscall
	 #print number of elements evenly divisible by N
	 li $v0, 4
	 la $a0, message7
	 syscall
	 li $v0, 1
	 move $a0, $t6
	 syscall
	 li $v0, 10 	#exit
	 syscall
	 
	

.data
	array: .space 80 	# Allocate 80 bytes = space enough to hold 20 words
	message1: .asciiz "Enter the number of elements: "
	message2: .asciiz "Enter integers: "
	message3: .asciiz "Enter N: "
	message4: .asciiz "\n Number of elements equal to N: "
	message5: .asciiz "\n Number of elements less than N: "
	message6: .asciiz "\n Number of elements greater than N: "
	message7: .asciiz "\n Number of elements evenly divisible by N: "
