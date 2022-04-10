# macros.asm
# contains general macros used

# macro to pause (immediate) the program for the specified time in milliseconds
# %time_in_ms = time to pause in milliseconds
.macro pausei (%time_in_ms)
	move	$t9, $a0		# save value of $a0 in $t9
	li	$v0, 32			# syscall code 32 to pause program
	li	$a0, %time_in_ms	# load pause time in $a0
	syscall
	move	$a0, $t9		# restore value of $a0
.end_macro

# macro to pause the program for the amount of time stored in a register
# $time_in_ms = register with time to pause in milliseconds
.macro pause ($time_in_ms)
	move	$t9, $a0		# save value of $a0, in $t9
	li	$v0, 32			# syscall code 32 to pause
	move	$a0, $time_in_ms	# load pause time from register
	syscall
	move	$a0, $t9		# restore value of $a0
.end_macro

# macro to swap the values in two registers
# $a = first register
# $b = second register
.macro swap ($a, $b)
	move	$t9, $a			# temp = a
	move	$a, $b			# a = b 
	move	$b, $t9			# b = temp
.end_macro

# macro to print string to console
# $string = address of string to print
.macro print_string ($string)
	move	$t9, $a0
	move	$a0, $string
	li	$v0, 4
	syscall
	move	$a0, $t9
.end_macro


# macro to print integer to console
# $int = register of int to print
.macro print_int ($int)
	move	$t9, $a0
	move	$a0, $int
	li	$v0, 1
	syscall
	move	$a0, $t9
.end_macro
