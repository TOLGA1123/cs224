.text
	lw $a0, listSize
	la $a1, listData
	jal createList
	
	move	$a0, $v0	# Pass the linked list address in $a0
	move $a3, $v0		#copy the list head address for later use
	jal 	printLinkedList
	
	la $a0, message1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a0, $v0		#$a0 = input value
	move $a1, $a3		#$a1 = list head address
	lw $a2, listSize	#$a2 = listSize
	jal copyAllExcept_x
	move $a0, $v0		#base address of the new list
	jal printLinkedList
	
	li $v0, 10
	syscall
#$a0 = number of nodes to be created	#$a1 = address of the first data member that will be added to linked list
#$v0 returns the list head
createList:
	addi	$sp, $sp, -24		#allocate stack space
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$s5, 0($sp)
	move $s0, $a0		#$s0 = number of nodes
	li $s1, 1		#$s1 = node counter
	lw $s2, 0($a1)		#$s2 = node data segment		$a1 +4 later
	
	li $a0, 8		#create first node
	li $v0, 9
	syscall
	
	move $s3, $v0		#$s3 points to the first and last node of the linked list.
	move $s4, $v0		#$s4 = list head
	
	sw	$s2, 4($s3)	#store the data value
addNode: 
	beq $s1, $s0, allDone
	addi $s1, $s1, 1
	addi $a1, $a1, 4	#next data value to be added
	lw $s2, 0($a1)		#$s2 = node data segment		$a1 +4 later
	li $a0, 8
	li $v0, 9
	syscall
	sw $v0, 0($s3)		# Connect the this node to the lst node pointed by $s3.
	move $s3, $v0		# Now make $s3 pointing to the newly created node.
	
	sw $s2, 4($s3)
	j addNode		
		
allDone:	
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s3.
	sw	$zero, 0($s3)
	move	$v0, $s4	# Now $v0 points to the list head ($s4).
	
	lw	$s5, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
 	jr $ra	
 	
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#=========================================================
#subprogram to copy all entries of a linked list to a newly created linked list in the same order except a value which is given as a parameter.
#returns newly created list head in $v0, and its size in $v1
#arguments $a0 = input value, $a1 = list header address, $a2 = listSize
copyAllExcept_x:	
	addi $sp, $sp, 32		#allocate stack space
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	################################## do here #####################################
	move $s0, $a0			#$s0 = input value
	move $s1, $a1			#$s1 = original list header address
	move $s2, $a2			#$s2 = original list size (will be changed)
	li $s3, 1			#$s3 = node counter for original list
	li $s4, 1			#$s4 = node counter for copy list
loop:
	bgt $s3, $a2, alldone		#if node counter == original list size
	lw $s5, 4($s1)			#$s5 = data value from original list
	bne $s5, $s0, copyNode
	addi $s2, $s2, -1		#if data = input decrement list size
	addi $s3, $s3, 1		#increment counter
	addi $s1, $s1, 8
	j loop
copyNode:
	beq $s4, 1, copyFirstNode	#adding the first node for copy list
	bgt $s4, $s2, alldone		#if copy node counter == list size
	addi $s3, $s3, 1		#increment counter
	addi $s4, $s4, 1		#increment copy counter
	addi $s1, $s1, 8
	li $a0, 8
	li $v0, 9
	syscall
	sw $v0, 0($s6)			#connect this node to previous node
	move $s6, $v0			#now $s6 points to the next node
	sw $s5, 4($s6)			#data value
	j loop
copyFirstNode:
	addi $s3, $s3, 1		#increment counter
	addi $s4, $s4, 1		#increment copy counter
	addi $s1, $s1, 8
	li $a0, 8
	li $v0, 9
	syscall
	move $s6, $v0			#$s6 = header of the new list
	move $s7, $v0			#$s7 = header of the new list
	sw $s5, 4($s6)			#entering data value for node 
	j loop
alldone: 
	sw $zero, 0($s6)		#grounding the last node
	
	move $v0, $s7			#return list head
	move $v1, $s2			#return list size
			
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	jr $ra
	.data
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "

listData: .word 1, 1, 3, 3, 5, 6, 1, 4
listSize: .word 8					#must be exact size of the list
message1: .asciiz "Enter a value to delete from the list: "
