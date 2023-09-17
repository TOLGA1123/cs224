.text			
	li $v0, 4
	la $a0, message1
	syscall
	li $v0, 5
	syscall
	move $t0, $v0 		#save a to $t0
	li $v0, 4
	la $a0, message2
	syscall
	li $v0, 5
	syscall
	move $t1, $v0		#save b to $t1
	sll $t2, $t0, 1		# $t2 = 2*a
	sub $t3, $t2, $t1	# $t3 = 2*a-b
	add $t4, $t1, $t0	# $t4 = a+b
	div $t3, $t4
	mflo $s0		#$s0 = x = (2*a-b)/(a+b)	#integer division #unsigned 
	li $v0, 4
	la $a0, message3
	syscall
	move $a0, $s0		#copy x to $a0 to be printed
	li $v0, 1
	syscall
	li $v0, 10
	syscall 		#exit the program
	
	
	
.data
message1: .asciiz "\n Enter a: "
message2: .asciiz "\n Enter b: "
message3: .asciiz "\n Result of the expression (2*a-b)/(a+b) = "
