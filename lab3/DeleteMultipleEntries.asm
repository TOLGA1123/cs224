.text
	lw $a0, listSize
	la $a1, listData
	jal createList
	
	move	$a0, $v0	# Pass the linked list address in $a0
	move $a3, $v0		#copy the list head address for later use
	jal 	printLinkedList
	la $a0, message
	li $v0, 4
	syscall
	
	move $a1, $a3		#only needs header address from create list			#not  use la $a0, listData lw $a1, listSize here (array)
	jal DeleteMultipleEntries
	move $a0, $v0
	jal printLinkedList
	
	li $v0, 10
	syscall
	
#a subprogram to delete multiple values from a sorted linked list.
#arguments $a0 = size of the list	$a1 = header address of the list			return $v0 header address of list
DeleteMultipleEntries:								############## causes memory leaks on list idk how to delete unused nodes ################
	addi	$sp, $sp, -24		#allocate stack space
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$s5, 0($sp)
	
	move $s0, $a1			#$s0 = head address of the list		head address dont change when deleting multiple values -> return $a1
loop:	
	lw $s1, 0($s0)			#$s1 = points to the next node
	lw $s2, 0($s1)			#$s2 = address segment of next node
	beq $s2, 0, alldone		#if next node is last
	lw $s3, 4($s0)			#$s3 = data value of current node
	lw $s4, 4($s1)			#$s4 = data value of next node
	beq $s3, $s4, deleteNode	#if datavalue current == datavalue next  deleteNode
	move $s0, $s1			#iterate to next node
	j loop
deleteNode:
	sw $s2, 0($s0)			#current node address segment point to the next next node		#memory leak unused node
	j loop
alldone:
	sw $zero, 0($s1)		#grounding last node		#dont use $s0 here use $s1 last item included idk why
	move $v0, $a1			#return head address of the list (first item should remain)
	
	#############################################################################################	
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $s4, 4($sp)
	lw $s5, 0($sp)
	addi $sp, $sp, 24
	jr $ra
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

listData: .word 1, 2, 2, 3			#must be sorted			assuming list is not empty
listSize: .word 4					#must be exact size of the list

message: .asciiz "\n \n \n List after multiple entries removed: "
