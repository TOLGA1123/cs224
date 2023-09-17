##
##	Program3.asm is a loop implementation
##	of the Fibonacci function
##        

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
.globl __start
 
__start:		# execution starts here
	li $a0,10	# to calculate fib(7)
	jal fib		# call fib			#flb typo
	move $a0,$v0	# print result
	li $v0, 1
	syscall					#syscal typo

	la $a0,end	# print newline
	li $v0,4
	syscall

	li $v0,10	#should be 10 not 100
	syscall		# bye bye

#------------------------------------------------


fib:	move $v0,$a0	# initialise last element
	blt $a0,2,done	# fib(0)=0, fib(1)=1			#don

	li $t0,0	# second last element
	li $v0,1	# last element

loop:	add $t1,$t0,$v0	# get next value	#v0
	move $t0,$v0	# update second last
	move $v0,$t1	# update last element
	sub $a0,$a0,1	# decrement count
	bgt $a0,1,loop	# exit loop when count=0             # 0 should be 1 here  one extra addition    fib(3)=> 2 addition etc. n-1 addition
done:	jr $ra

#################################				Go: execution paused at breakpoint: Program3.asm
#					 	#
#     	 data segment		#
#						#
#################################

	.data
end:	.asciiz "\n"		#end1

##
## end of Program3.asm
