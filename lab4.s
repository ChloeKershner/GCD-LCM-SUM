#                                           CS 240, Lab #4
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
# 
#
j main
###############################################################################
#                           Data Section
.data

# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Chloe Kershner"
student_id: .asciiz "826281307"

new_line: .asciiz "\n"
space: .asciiz " "


t1_str: .asciiz "Testing GCD: \n"
t2_str: .asciiz "Testing LCM: \n"
t3_str: .asciiz "Testing RANDOM SUM: \n"

po_str: .asciiz "Obtained output: " 
eo_str: .asciiz "Expected output: "

GCD_test_data_A:	.word 1, 36, 360, 108, 28300
GCD_test_data_B:	.word 12,54, 210, 144, 74000

GCD_output:           .word 1, 18, 30, 36, 100

LCM_test_data_A:	.word 1, 36, 360, 108, 28300
LCM_test_data_B:	.word 12,54, 210, 144, 74000
LCM_output:           .word 12, 108, 2520, 432, 20942000

RANDOM_test_data_A:	.word 1, 144, 42, 260, 74000
RANDOM_test_data_B:	.word 12, 108, 54, 210, 44000
RANDOM_test_data_C:	.word 4, 109, 36, 360, 28300

RANDOM_output:           .word 26, 720, 216, 3120, 21044400

###############################################################################
#                           Text Section
.text
# Utility function to print an array
print_array:
li $t1, 0
move $t2, $a0
print:

lw $a0, ($t2)
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra
###############################################################################
###############################################################################
#                           PART 1 (GCD)
#a0: input number
#a1: input number
.globl gcd
gcd:
############################### Part 1: your code begins here ################
addi $t1, $zero, 0		# varibale to hold temp value
addi $t2, $a0, 0		# varibale to preserve x value arg
addi $t3, $a1, 0		# varibale to preserve y value arg
sub $sp, $sp, 4			# decrement the stack pointer
sw $ra, 0($sp)			# save $ra into stack
jal euclidGCD			# call function
j done				# jump to end of program since recursion is done
euclidGCD:
sub $sp, $sp, 4			# decrement the stack pointer
sw $ra, 0($sp)			# save $ra into stack 
move $v0, $t2			# move contents of first argument into return register $v0
beqz $t3, endGCD		# if second argument is equal to 0, we are done, jump to doneGCD
move $t1, $t3			# otherwise, move second arg into temp register
div $t2, $t3			# divide first arg by second arg
mfhi $t3			# save the remainder into second arg
move $t2, $t1			# set first arg to temp varibale (holds $a1 before division)
jal euclidGCD			# call function again
endGCD:				# at this point, we have hit the base case
lw $ra, 0($sp)			# load contents of $sp into $ra
addi $sp, $sp, 4		# increment stack pointer
jr $ra				# jump to $ra
done:				# end of part 1
lw $ra, 0($sp)			# load contents of $sp into $ra
addi $sp, $sp, 4		# increment stack pointer




############################### Part 1: your code ends here  ##################
jr $ra
###############################################################################
###############################################################################
#                           PART 2 (LCM)

# Find the least common multiplier of two numbers given
# Make a call to the GCD function to compute the LCM
# LCM = a1*a2 / GCD

# preserve the $ra register value in stack before making the call!!!

#a0: input number
#a1: input number

.globl lcm
lcm:
############################### Part 2: your code begins here ################

sub $sp, $sp, 12	# decrement stack pointer
sw $ra, 8($sp)		# store $ra to stack
sw $a0, 4($sp)		# store $a0 to stack
sw $a1, 0($sp)		# store $a1 to stack
jal gcd			# call gcd method
move $t0, $v0		# save return value into $t0
lw $ra, 8($sp)		# load $ra back from stack
lw $t1, 4($sp)		# load first arg back into $t1
lw $t2, 0($sp)		# load second arg back into $t2
addi $sp, $sp, 12	# increment stack pointer back
mul $t3, $t1, $t2	# multiply the two args
div $t3, $t0		# divide them by the gcd result
mflo $v0		# save the lo register into $v0 to return

############################### Part 2: your code ends here  ##################
jr $ra
###############################################################################
#                           PART 3 (Random SUM)

# You are given three integers. You need to find the smallest 
# one and the largest one.
# 
# Then find the GCD and LCM of the two numbers. 
#
# Return the sum of Smallest, largest, GCD and LCM
#
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2. You 
# need to store the answer into register $t0. It will be returned by the
# function to the caller.
# Use stacks to store the smallest and largest values before making the function call. 

.globl random_sum
random_sum:
############################### Part 3: your code begins here ################

bgt $a0, $a1, else1	# branch if $a0 is greater than $a1
move $t0, $a1		# if not, $a1 is the greater number
j next1			#skip the else statement
else1:
move $t0, $a0		# $a0 is the greater number
next1:
bgt $t0, $a2, doneGT	#same process cheking against third number
move $t0, $a2
doneGT:

bgt $a0, $a1, else2 	#same process as above, but to check for smallest number instead
move $t1, $a0
j next2
else2:
move $t1, $a1
next2:
bgt $a2, $t1, doneLT
move $t1, $a2
doneLT:

sub $sp, $sp, 24	#decrement stack pointer 24 to hold 6 items
sw $ra, 20($sp)		# store $ra
sw $a0, 16($sp)		# store $a0
sw $a1, 12($sp)		# store $a1
sw $t0, 8($sp)		# store $t0
sw $t1, 4($sp)		# store $t1
move $a0, $t0		# set $a0 and $a1 args to call gcd using numbers above
move $a1, $t1
jal gcd			# call gcd

sw $v0, 0($sp)		# save the result into stack
jal lcm			# call lcm

lw $ra, 20($sp)		# load $ra back
lw $a0, 16($sp)		# load $a0 back
lw $a1, 12($sp)		# load $a1 back
lw $t0, 8($sp)		# load $t0 back
lw $t1, 4($sp)		# load $t1 back
lw $t2, 0($sp)		# load $t2 back
move $t3, $v0		# save lcm result into $t3
addi $sp, $sp, 24	# increment stack pointer back

add $t0, $t0, $t1	#series of addition to add all four numbers
add $t0, $t0, $t2
add $v0, $t0, $t3









############################### Part 3: your code ends here  ##################
jr $ra
###############################################################################

#                          Main Function 
main:
li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall
la $a0, new_line
syscall
###############################################################################
#                          TESTING PART 1 - GCD
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t1_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, GCD_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, GCD_test_data_A
la $s3, GCD_test_data_B
#j skip_line
##############################################
test_gcd:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 0($s5)
jal gcd

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_gcd

###############################################################################

#                          TESTING PART 2 - LCM
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t2_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, LCM_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, LCM_test_data_A
la $s3, LCM_test_data_B
#j skip_line
##############################################
test_lcm:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 0($s5)
jal lcm

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_lcm

###############################################################################
#                          TESTING PART 3 - RANDOM SUM
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t3_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, RANDOM_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, RANDOM_test_data_A
la $s3, RANDOM_test_data_B
la $s4, RANDOM_test_data_C
#j skip_line
##############################################
test_random:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s5, $s2, $s1
add $s6, $s3, $s1
add $s7, $s4, $s1
# Pass input parameter
lw $a0, 0($s5)
lw $a1, 0($s6)
lw $a2, 0($s7)
jal random_sum

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_random

###############################################################################

_end:
# new line
li $v0, 4
la $a0, new_line
syscall

# end program
li $v0, 10
syscall
###############################################################################


