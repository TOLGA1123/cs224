
.text
	li $v0, 4
	la $a0, message1
	syscall
	li $v0, 5
	syscall
	move $a0, $v0 
	jal CreateArray		#call CreateArray with the given array size $a0
	move $a1, $v0		#store array's size in $a1		for first array
	move $a2, $v1		#store the address of array in $a2
	move $s4, $a1		#$s4 = first array's size	
	move $s5, $a2		#$s5 = first array's address		#$s4-$s5-$s6-$s7 used for storing 2 arrays size and address that will later be copied on arguments
	li $v0, 4
	la $a0, message1
	syscall
	li $v0, 5
	syscall
	move $a0, $v0
	jal CreateArray
	move $a3, $v0		#copy second array's size to $a3  since $v0 is changed during PrintArray
	la $a0, message3
	li $v0, 4
	syscall		
	jal PrintArray
	move $a1, $a3		#store array's size in $a1		for second array
	move $a2, $v1		#store the address of array in $a2
	move $s6, $a1		#$s6 = second array's size	
	move $s7, $a2		#$s7 = second array's address   
	la $a0, message4
	li $v0, 4
	syscall		
	jal PrintArray
	#arguments for CalculateDistance
	move $a0, $s4		#$a0 = first array's size
	move $a1, $s5		#$a1 = first array's address
	move $a2, $s6		#$a2 = second array's size
	move $a3, $s7		#$a3 = second array's address
	jal CalculateDistance
	move $a1, $v0		#copy the distance to $a1
	la $a0, message6
	li $v0, 4
	syscall
	move $a0, $a1
	li $v0, 1
	syscall
	li $v0, 10		#exit the program
	syscall
	
	
#subprogram that creates an array with given size  #$a0 = array size (bytes)
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
	move $v0, $s0		#return the array size
	move $v1, $s1		#return the base address of the array
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
	la $a0, message5
	syscall
	j printFor
printDone:
	lw $s0, 0($sp)			# restore $s0
	lw $s1, 4($sp)			# restore $s1
	addi $sp, $sp, 8		#deallocate stack space
	jr $ra
	
	
#subprogram that calculates the Hamming distance between two arrays		#assuming that two arrays have same size
#$a0 = first array's size
#$a1 = first array's address
#$a2 = second array's size
#$a3 = second array's address
#returns hamming distance in $v0
CalculateDistance:
	addi $sp, $sp, -12
	sw $s0, 0($sp)			#save $s0 in stack
	sw $s1, 4($sp)			#save $s1 in stack
	sw $s2, 8($sp)			#save $s2 in stack
	addi $s0, $0, 0			#$s0 = array index i	i + 1
	li $v0, 0			#$v0 = Distance (Return Value)
	
	
	###### Simplify here a bit
Iterate:
	beq $s0, $a0, Return
	lw $s1, 0($a1)			#$s1 = array1(i)	$a1 + 4
	lw $s2, 0($a3)			#$s2 = array2(i)	$a3 + 4
	bne $s1, $s2, AddDistance 			#if array1(i) != array2(i)
done5:
 	addi $s0, $s0, 1
 	addi $a1, $a1, 4
 	addi $a3, $a3, 4
	j Iterate
AddDistance: 
	addi $v0, $v0, 1		#if array1(i) != array2(i) increment distance
	j done5
Return:	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	jr $ra
.data
	message1: .asciiz "Enter the size of array: "
	message2: .asciiz "Enter the elements of array: "
	message3: .asciiz "\n First array = "
	message4: .asciiz "\n Second array = "
	message5: .asciiz " "
	message6: .asciiz "\n Hamming distance between two arrays: "
	
	
	
