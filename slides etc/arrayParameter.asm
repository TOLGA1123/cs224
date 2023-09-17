	.text
# Generate a dynamically created array 
# Populate it in a subprogram
# Print it in another subprogram
# February 28 Version
	lw	$t0, arraySize   # In number of words
	sll	$a0, $t0, 2	 # $a0= 4 x $t0 (no. of words to be allocatedd)
	li	$v0, 9
	syscall
	# Array beginning address is in $v0
	
# Populate array in subprogram populateArray
	move	$a0, $v0	# $v0 contains the beginning address of array
	lw	$a1, arraySize
	jal	populateArray
# Print array in subprogram printArray
	jal	printArray
	
# stop
	li	$v0, 10
	syscall
#===============================================================
populateArray:
	move	$t0, $a0	# $t0: array pointer
	move	$t1, $a1	# $t1: array size
	li	$t3, 1
	
again1:	
	bgt	$t3, $t1, done1
	sw	$t3, 0($t0)
	addi	$t3, $t3, 1
	addi	$t0, $t0, 4
	j	again1
done1:
	jr	$ra		# Go back
#===============================================================
printArray:
	move	$t0, $a0	# $t0: array pointer
	move	$t1, $a1	# $t1: array size
	li	$t3, 1		# addi $t3, $zero, 1
again2:	
	bgt	$t3, $t1, done2	
# Print array element pointed by $t0.
	lw	$a0, 0($t0)
	li	$v0, 1
	syscall
	addi	$t3, $t3, 1
	addi	$t0, $t0, 4
	j	again2
done2:
	jr	$ra		# Go back
#===============================================================
	.data
arraySize:
	.word	10			
	
	
	
