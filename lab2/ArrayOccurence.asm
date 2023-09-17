.text
	li $v0, 4
	la $a0, message1
	syscall
	li $v0, 5
	syscall
	move $a0, $v0 
	jal CreateArray
	move $a1, $v0		#store array's size in $a1		
	move $a2, $v1		#store the address of array in $a2
	la $a0, message3
	li $v0, 4
	syscall
	jal PrintArray
	la $a0, message5
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a0, $v0		#store n in $a0
	jal ArrayEntryCheck
	move $a3, $v0		#store appearance in $a3
	la $a0, message6
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $a3
	syscall
	

	li $v0, 10		#exit
	syscall 		



#subprogram that creates an array with given size  #$a0 = array size (bytes)	#$v0 = array size #$v1 = array address
CreateArray:
	addi $sp, $sp, -12
	sw $s0, 0($sp)		#save $s0 on stack  ($s0 = 0)
	sw $s1, 4($sp)		#save $s1 on stack ($s1 = 0)
	sw $ra, 8($sp)		#save $ra
	move $s0, $a0		#array size = $s0
	sll $a0, $a0, 2		#array size integer to byte
	li $v0, 9
	syscall			#allocate memory
	move $s1,$v0		#s1 = array pointer (address of the array)
	jal InitializeArray
	move $v0, $s0		#return the array size in $v0
	move $v1, $s1		#return the base address of the array iv $v1
	lw $ra, 8($sp)		#restore $ra
	lw $s1, 4($sp)		#restore $s1
	lw $s0, 0($sp)		#restore $s0
	addi $sp, $sp, 12	#deallocate stack space
	jr $ra
#subprogram that initializes the array values with user inputs
InitializeArray:
	addi $sp, $sp, -8
	sw $s2, 0($sp)		#save $s2 on stack ($s2 = 0)	#s2 = array index i
	sw $s1, 4($sp)		#save $s1 on stack (array pointer = address of the array)
for:
	beq $s2, $s0, done
	li $v0, 4
	la $a0, message2
	syscall
	li $v0, 5
	syscall
	sw $v0, 0($s1)		#filling the array with inputs
	addi $s2, $s2, 1	#i = i+1
	addi $s1, $s1, 4	#incrementing array pointer by 4
	j for
done:
	lw $s2, 0($sp)		#restore $s2 from stack
	lw $s1, 4($sp)		#restore $s1 from stack
	addi $sp, $sp, 8	#deallocate stack space
	jr $ra
	
#subprogram that prints array elements			#$a1: array size,	$a2: array address 
PrintArray:
	addi $sp, $sp, -8
	sw $s0, 0($sp)			#save $s0 in stack ($s0 = 0)
	sw $s1, 4($sp)			#save $s1 in stack ($s1 = 0)			
	addi $s0, $s0, 0		#$s0 = array index i
	move $s1, $a2			#$s1 = array pointer
printFor:
	beq $s0, $a1, printDone
	li $v0, 1
	lw $a0, 0($s1)
	syscall
	addi $s0, $s0, 1		# i = i + 1
	addi $s1, $s1, 4		# increment pointer by 4
	li $v0, 4
	la $a0, message4
	syscall
	j printFor
printDone:
	lw $s0, 0($sp)			# restore $s0
	lw $s1, 4($sp)			# restore $s1
	addi $sp, $sp, 8		#deallocate stack space
	jr $ra
	
#subprogram that receives an array and an index position of the array and returns the number of occurrences of the array element that occurs at that position
# $a0: n (index position)  # $a1: array size  # $a2: array address		index n starts at 0
ArrayEntryCheck:		
	addi $sp, $sp, -28
	sw $s0, 0($sp)		#store $s0
	sw $s1, 4($sp)		#store $s1
	sw $s2, 8($sp)		#store $s2
	sw $s3, 12($sp)		#store $s3
	sw $s4, 16($sp)		#store $s4
	sw $s5, 20($sp)		#store $s5
	sw $s6, 24($sp)		#store $s6
	move $s0, $a0		#$s0 = index n
	move $s1, $a1		#$s1 = array size
	move $s2, $a2		#$s2 = array address (pointer)
	sll $s0, $s0, 2		#multiply n by 4 
	add $s2, $s2, $s0	#array pointer now points to the given index
	lw $s3, 0($s2)		#save n'th element to $s3	n=0 0x4 = 0 first element
	sub $s2, $s2, $s0	#return back array pointer to first index
	addi $s4, $0, 0		#$s4 = i	
	addi $s5, $0, 0		#$s5 = appearance count
for2:
	beq $s4, $s1, done2	#if i = arraysize branch to done2
	lw $s6, 0($s2)		#$s6 = array(i)		# $s4 increment 1 # $s2 increment 4
	beq $s6, $s3, same
	addi $s4, $s4, 1	#increment i by 1
	addi $s2, $s2, 4	#increment pointer by 4
	j for2
	same:
	addi $s5, $s5, 1	#increment appearance by 1
	addi $s4, $s4, 1	#increment i by 1
	addi $s2, $s2, 4	#increment pointer by 4
	j for2
done2:	
	move $v0, $s5		#return appearance count on $v0
	lw $s0, 0($sp)		#restore $s0
	lw $s1, 4($sp)		#restore $s1
	lw $s2, 8($sp)		#restore $s2
	lw $s3, 12($sp)		#restore $s3
	lw $s4, 16($sp)		#restore $s4
	lw $s5, 20($sp)		#restore $s5
	lw $s6, 24($sp)		#restore $s6
	addi $sp, $sp, 28	#deallocate stack space
	jr $ra
	
.data
	message1: .asciiz "Enter the size of array: "
	message2: .asciiz "Enter the elements of array: "	
	message3: .asciiz "\n Array: "
	message4: .asciiz " " 
	message5: .asciiz "\n Enter index position n: "
	message6: .asciiz "\n The number of occurrences of the array element that occurs at n'th position: "
