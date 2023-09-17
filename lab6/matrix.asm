.text
	la $a0, message1	#ask for matrix size in terms of dimensions N (N x N square matrix)	N >= 1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a1, $v0		#$a1 contains matrix dimension N
	mul $a2, $a1, $a1	#$a2 contains number of elements N x N
	#allocation with syscall 9
	mul $a0, $a2, 4		#number of bytes to allocate in $a0
	li $v0, 9
	syscall
	move $a0, $v0		#$a0 contains the address now
	jal fillMatrix
	move $t0, $a0			#store address for later use in $t0	address
	move $t1, $a1			#store N for later use in $t1		N
	mul $t2, $a1, $a1		#store size for later use in $t2	N^2
	jal displayMatrix
menu:
	la $a0, message9
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	beq $v0, 1, colSum
	beq $v0, 2, rowSum
	beq $v0, 3, findElement
	beq $v0, 4, exit
	j exit				#if any other integer input --> exit
colSum:
	move $a0, $t0
	move $a1, $t1
	move $a2, $t2
	jal columnByColumn
	j menu
rowSum:
	move $a0, $t0
	move $a1, $t1
	move $a2, $t2
	jal rowByRow
	j menu
findElement:				#this assumes that row and column inputs are valid 
	la $a0, message7
	li $v0, 4
	syscall
	la $a0, message6
	syscall
	li $v0, 5
	syscall
	move $a2, $v0
	la $a0, message5
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a3, $v0
	move $a1, $t1
	move $a0, $t0
	jal displayElement
	j menu
	
exit:
	li $v0, 10		#exit
	syscall
#subfunction to fill matrix elements	$a0: starting address, $a1: matrix dimension, $a2: number of elements			#dimension >= 1
fillMatrix:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	move $s0, $a0	#$s0: starting address (will be iterated)
	move $s1, $a1	#$s1: matrix dimension N
	move $s2, $a2	#$s2: number of elements
	li $s3, 1
	loop1:
		sw $s3, 0($s0)		#store value
		addi $s3, $s3, 1 	#increment counter
		addi $s0, $s0, 4	#increment address
		bgt $s3, $s2, done1
		j loop1
	done1:
	#starting address still in $a0 not changed
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra
#subfunction that displays square matrix 	$a0: starting address, $a1: matrix dimension, $a2: number of elements
displayMatrix:					#matrix elements dont really used, instead print square matrix with consecutive numbers		+ correct in heap
	addi $sp, $sp, 28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	move $s0, $a0				#$s0 = starting address
	move $s1, $a1				#$s1 = matrix dimension N
	move $s2, $a2				#$s2 = number of elements
	li $s3, 1				#rows counter
	li $s4, 1				#columns counter
	la $a0, line
	li $v0, 4
	syscall
	loop2:	
		move $s6, $s3
		loop3:
		move $a0, $s6
		li $v0, 1
		syscall
		la $a0, space
		li $v0, 4
		syscall
		add $s6, $s6, $s1
		addi $s4, $s4, 1
		bgt $s4, $s1, done3
		j loop3
		done3:
		la $a0, line
		li $v0, 4
		syscall
		addi $s3, $s3, 1
		li $s4, 1
		bgt $s3, $s1, done2
		j loop2
	done2:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	jr $ra
#Display an element in matrix with given row and column numbers		$a0: address, $a1: dimension N, $a2: row number, $a3: column number
displayElement:
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	move $s0, $a2		#$s0 = i
	move $s1, $a3		#$s1 = j
	addi $s2, $s0, -1	#$s2 = i - 1
	addi $s3, $s1, -1	#$s3 = j - 1
	mul $s4, $s3, $a1	#$s4 = (j -1) x N
	mul $s4, $s4, 4		#$s4 = (j - 1) x N x 4
	mul $s5, $s2, 4		#$s5 = (i - 1) x 4
	add $s6, $s4, $s5	#$s6 = (j - 1) x N x 4 + (i - 1) x 4
	add $s7, $a0, $s6	#$s7 = address of the specified element
	
	la $a0, message8
	li $v0, 4
	syscall
	li $v0, 1		#print specified element with given column and row
	lw $a0, 0($s7)
	syscall				
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	jr $ra
#subfunction to obtain summation of matrix elements column-major (column by column) summation	$a0 = address, $a1 = N, $a2 = number of elements = N^2
#calculate summation of matrix elements  by traversing columns	(simple array traversing beginning to end)
columnByColumn:
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	move $s0, $a0		#$s0 = address of the matrix	(will be iterated)
	move $s1, $a1		#$s1 = dimension N
	move $s2, $a2		#$s2 = number of elements N^2
	loop4:
		lw $s3, 0($s0)	#$s3 = element
		add $s4, $s4, $s3	#$s4 = sum
		addi $s2, $s2, -1	#decrement element count after addition
		addi $s0, $s0, 4	#iterate
		beq $s2, $zero, done4
		j loop4
	done4:
		la $a0, message4
		li $v0, 4
		syscall
		li $v0, 1
		move $a0, $s4
		syscall
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	jr $ra	
		

#subfunction to obtain summation of matrix elements row-major (row by row) summation 		$a0 = address, $a1 = N, $a2 = number of elements = N^2
#calculate summation of matrix elements  by traversing rows
rowByRow:
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	move $s0, $a0		#$s0 = address
	move $s1, $a1		#$s1 = N (row count)
	move $s2, $a2		#$s2 = number of elements (N^2)
	mul $s3, $s1, 4		#$s3 = 4 x N
	move $s4, $a0		#$s4 = column iterator
	move $s5, $a1		#$s5 = N (column count)
	addi $s6, $zero, 0	#$s6 = sum
	loop5:					#sum the elements in one column here
		lw $s7, 0($s4)			#$s7 = element
		add $s6, $s6, $s7
		add $s4, $s4, $s3
		addi $s1, $s1, -1		#decrement row count
		beq $s1, $zero, rowDone
		j loop5
	rowDone:				#iterate to next column
		move $s1, $a1
		addi $s0, $s0, 4
		move $s4, $s0			#next column
		addi $s5, $s5, -1		#decrement column count
		beq $s5, $zero, allDone
		j loop5
	allDone:
		la $a0, message3
		li $v0, 4
		syscall
		li $v0, 1
		move $a0, $s6
		syscall
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	jr $ra	
.data
message1: .asciiz "\n Enter the dimension N of square matrix: "
message2: .asciiz "\n The matrix with given size : "
message3: .asciiz "\n Summation of matrix elements row-major (row by row) summation: "
message4: .asciiz "\n Summation of matrix elements column-major (column by column) summation: "
message5: .asciiz "\n Specify the column number: "
message6: .asciiz "\n Specify the row number: "
message7: .asciiz "\n Enter row and column numbers to see a desired element: "
message8: .asciiz "\n The element specified with given row and column number is: "
space: .asciiz " "
line: .asciiz "\n"
message9: .asciiz "\n Select the operation : \n 1 - Column-major summation \n 2 - Row-major summation \n 3 - Find and element in the matrix \n 4 - Exit \n"
