# Name: Brad Johnson
# Class: CS 2340.002 - Mazidi
# Assignment: Bitmap Project
# Description: MIPS Stacker - An endless 2D stacker game implemented with MIPS using the MARS 4.5.1 Bitmap and Keyboard MMIO Simulator

# Instructions: 
#         set pixel dim to 16x16
#         set display dim to 512x512
#	use $gp as base address
#	make sure to resize bitmap window so entire bitmap display is shown
#   Connect keyboard and run
#	press space to place block
#	all other keys are ignored

.include "macros.asm"	
.include "font_macros.asm"

# setup constants

# width of screen in pixels
# 512 / 16 = 32
.eqv WIDTH 32
# height of screen in pixels
.eqv HEIGHT 32

.eqv INITIAL_BLOCK_WIDTH 8	# block constants
.eqv INITIAL_BLOCK_HEIGHT 8
.eqv BLOCK_HEIGHT 2

.eqv EASY_DELAY 75		# game delay in milliseconds, for each difficulty
.eqv MEDIUM_DELAY 50
.eqv HARD_DELAY 25
.eqv IMPOSSIBLE_DELAY 10

.eqv BACKGROUND_COLOR 0		# set background color to black
.eqv INITIAL_COLOR 0x000000FF	# initial color set to blue
.eqv WHITE 0x00FFFFFF
.eqv YELLOW 0x00FFFF00

.data
game_delay:	.word 	0		# current game delay in milliseconds
y_position:	.word 	0		# stores the y position
left_position: 	.word 	0		# stores the position of the left edge of the block
right_position:	.word	0		# stores the position of the right edge of the block
score:		.word 	0		# keeps track of the game score
block_delay:	.word	150		# delay between drawing block rows 
color_index:	.word 	0		# the index of the current color in the colors array
block_color:	.word 	INITIAL_COLOR	# the current color of the block
color_gradient:	.word 	INITIAL_COLOR, 0x003200ff, 0x004800ff, 0x005800ff, 0x007700ff,  # the color gradient of
			0x009000ff, 0x00a600ff, 0x00ba00ff, 0x00cc00ff, 0x00dd00ff, 	# each consecutive block
			0x00ff00c9, 0x00ff0093, 0x00ff2b60, 0x00ff6b30, 0x00ff9600,   	# (-1 indicates end of array)
			0x00fdb800, 0x00d6d300, 0x00a9e833, 0x0071fa71, 0x0000f088,  
			0x0000e4a8, 0x0000d7cc, 0x0000c8f2, 0x0000b7ff, 0x0000a6ff, 
			0x000091ff, 0x000078ff, 0x000055ff, -1
.align 2
choose_difficulty_message: 	.asciiz "Choose your difficulty:\n    (1) Noobie Stacker\n    (2) Mediocre Stacker\n    (3) Stacking Mastermind\n    (4) Lol. Good luck."
game_over_message: 		.asciiz "GAME OVER!\nScore: "
play_again_message:		.asciiz "Would you like to play again?"
goodbye_message:		.asciiz "Thanks for playing MIPS Stacker!\n\nCreated by Brad Johnson"

.text

setup:				
	jal	draw_initial_block	# draw the initial block
	jal	change_block_color	# change the block color
	lw	$t0, game_delay		# pause for GAME_DELAY ms
	pause ($t0)
	
	jal	draw_title		# draw and animate the title "MIPS STACKER"
	
	jal	choose_difficulty	# popup dialog input for player to choose difficulty
	
	jal	clear_title		# remove the title
	
main_loop:

create_block_from_left:
	# create new block from left side of the screen
	li	$s0, 0				# $s0 = 0 = X_left
	lw	$t0, right_position		# $s1 = right_pos - left_pos = X_right
	lw	$t1, left_position
	sub	$s1, $t0, $t1			
	
	lw 	$s2, y_position			# $s2 = y_position = Y_bottom
	addi 	$s3, $s2, -BLOCK_HEIGHT		# $s3 = Y_bottom - BLOCK_HEIGHT = Y_top
	
	lw	$a2, block_color		# load block color into a2
	li	$a0, 0				# a0 = X = 0
	
left_horizontal_loop:				# while (X <= X_right)
	move	$a1, $s2			#   a1 = Y_bottom = Y
	
left_vertical_loop:				#   while (Y > Y_top)
	jal	draw_pixel			#     draw pixel
	addi	$a1, $a1, -1			#     Y-- (move up one pixel)
	bgt	$a1, $s3, left_vertical_loop	#     jump back to vertical loop when haven't reached Y_top
	lw	$t0, game_delay			#   pause for GAME_DELAY ms
	pause ($t0)
	addi	$a0, $a0, 1			#   X++ (move right one pixel)
	ble	$a0, $s1, left_horizontal_loop	#   jump back to horizontal loop when haven't reach X_right
	
	
	# call function to move block and receive input for placing the block
	li	$a0, 1		# move block initially in the right direction (+1)
	jal	move_block
	
	
	
create_block_from_right:
	# create new block from right side of the screen
	lw	$t0, right_position		# $t1 = right_pos - left_pos = block width
	lw	$t1, left_position
	sub	$t1, $t0, $t1
	
	li	$s1, WIDTH			# s1 = WIDTH - 1 = X_right
	subi	$s1, $s1, 1
	sub	$s0, $s1, $t1			# s0 = WIDTH - block width = X_left
	lw 	$s2, y_position			# $s2 = y_position = Y_bottom
	addi 	$s3, $s2, -BLOCK_HEIGHT		# $s3 = Y_bottom - BLOCK_HEIGHT = Y_top
	
	lw	$a2, block_color		# load block color into a2
	move	$a0, $s1			# a0 = X_right = X
	
right_horizontal_loop:				# while (X >= X_left)
	move	$a1, $s2			#   a1 = Y_bottom = Y
	
right_vertical_loop:				#   while (Y > Y_top)
	jal	draw_pixel			#     draw pixel
	addi	$a1, $a1, -1			#     Y-- (move up one pixel)
	bgt	$a1, $s3, right_vertical_loop	#     jump back to vertical loop when haven't reached Y_top
	lw	$t0, game_delay			#   pause for GAME_DELAY ms
	pause ($t0)
	addi	$a0, $a0, -1			#   X-- (move left one pixel)
	bge	$a0, $s0, right_horizontal_loop	#   jump back to horizontal loop when haven't reach X_left
	
	# call function to move block
	li	$a0, -1			# move block initially in the left direction (-1)
	jal	move_block
	
	j	main_loop		# jump to the beginning of the main_loop
	
game_over:
	# play sad trombone sound :(
	# notes: D, C#, C, B
	li 	$v0, 33		
	li 	$a2, 57		# instrument = trombone
	li 	$a3, 127	# volume = 127 (max)
	li 	$a1, 600	# duration = 600 ms	
	
	li 	$a0, 62		# note = D
	syscall	
	
	li	$a0, 61		# note = C#
	syscall
	
	li	$a0, 60		# note = C
	syscall
	
	li	$a0, 59		# note = B
	li	$a1, 1200	# duration = 1200 ms
	syscall
	
	# display game over message and score
	li 	$v0, 56 		# syscall value for dialog
	la 	$a0, game_over_message 	# load game over message
	lw 	$a1, score		# load score
	syscall
	
	# ask if want to play again
	li	$v0, 50			# syscall code for confirm dialog
	la	$a0, play_again_message # load play again message
	syscall
	# if $a0 == 0: yes
	# if $a0 == 1 or 2: no
	bnez	$a0, exit
	j 	reset_game
exit:
	# output goodbye message dialog
	li	$v0, 55			# syscall code for message dialog
	la	$a0, goodbye_message	# load goodbye message
	li	$a1, 1			# info style
	syscall
	
	# exit the program
	li	$v0, 10
	syscall
	
	
reset_game:
	# use draw block function to draw over entire screen in BACKGROUND_COLOR
	li	$a0, 0		# X_left = 0
	li	$a1, WIDTH	# X_right = WIDTH
	li	$a2, HEIGHT	# Y_bottom = HEIGHT
	li	$a3, 0		# Y_top = 0
	
	li	$t0, BACKGROUND_COLOR
	sw	$t0, block_color
	jal	draw_block
	
	sw	$0, score		# reset all initial values
	sw	$0, y_position	
	sw	$0, left_position
	sw	$0, right_position
	sw	$0, color_index
	
	li	$t0, INITIAL_COLOR
	sw	$t0, block_color
	
	jal	choose_difficulty	# choose difficulty again
	jal	draw_initial_block
	jal	change_block_color	# change the block color
	lw	$t0, game_delay		# pause for GAME_DELAY ms
	pause ($t0)
	j	main_loop		# start main loop again



#############################################
# function that popups dialog input for player to choose difficulty
# get user input for difficulty
choose_difficulty:
	li	$v0, 51
	la	$a0, choose_difficulty_message
	syscall
	
	# if a1 == -2, cancel was chosen -> exit game
	li	$t0, -2
	beq	$a1, $t0, exit
	
	# if a0 == 2, difficulty = MEDIUM
	li	$t0, 2
	beq	$a0, $t0, medium
	
	# if a0 == 3, difficulty = HARD
	li	$t0, 3
	beq	$a0, $t0, hard
	
	# if a0 == 4, difficulty = IMPOSSIBLE
	li	$t0, 4
	beq	$a0, $t0, impossible
	
	# otherwise, difficulty = EASY
	li	$t1, EASY_DELAY
	j	set_difficulty
medium:
	li	$t1, MEDIUM_DELAY
	j	set_difficulty
hard:	
	li	$t1, HARD_DELAY
	j	set_difficulty
impossible:
	li	$t1, IMPOSSIBLE_DELAY
set_difficulty:
	sw	$t1, game_delay		# set game_delay
	jr	$ra			# return


#############################################
# function to move a block horizontally across the screen and place block when space inputted.
# $a0 = initial horizontal shift direction (+1 = right, -1 = left)
# expected values:
#	$s0 = X_left
#	$s1 = X_right
#	$s2 = Y_bottom
#	$s3 = Y_top
move_block:
	# while either end of the screen hasn't been reached yet,
	# draw pixels on left and right side of block, looping from Y_bottom to Y_top.
	# when end of screen is reached, block switches directions and continues animating

	addi	$sp, $sp, -4			# store return address on the stack
	sw	$ra, ($sp)			
	move	$s4, $a0			# s4 = horizontal shift direction: +1 right, -1 left
	lw	$s5, block_color	 	# s5 = color from get_block_color function
animate_loop:
	move	$a1, $s2			# a1 = Y_bottom = Y
	# check for input
	lw 	$t0, 0xffff0000  		# t0 checks for input
    	bnez 	$t0, process_input   		# if there's input, process it
    	
animate_vertical:
    	bltz	$s4, moving_left		# jump to moving_left when shift direction is negative
    	
    						# when moving right:
	li	$a2, BACKGROUND_COLOR		# draw over left side with BACKGROUND_COLOR
	move	$a0, $s0			# a0 = X_left = X
	jal 	draw_pixel
	
	move	$a2, $s5			# draw right side + 1 with block_color
	addi	$a0, $s1, 1			# a0 = X_right + 1 = X
	jal 	draw_pixel
	
	j 	update_coords
	
moving_left:					# when moving left:
	li	$a2, BACKGROUND_COLOR		# draw over right side with BACKGROUND_COLOR
	move	$a0, $s1			# a0 = X_right = X
	jal	draw_pixel
	
	move	$a2, $s5			# draw over left side - 1 with block_color
	addi	$a0, $s0, -1			# a0 = X_left - 1 = X
	jal	draw_pixel		
	
update_coords:
	addi	$a1, $a1, -1			# Y-- (move up one pixel)
	bgt	$a1, $s3, animate_vertical	# jump back to animate loop when Y_top not reached
	
    	lw	$t0, game_delay			# pause for GAME_DELAY ms
	pause ($t0)
    	
	li	$t0, WIDTH
	addi	$t0, $t0, -1			# t0 = WIDTH-1
	add	$s0, $s0, $s4			# X_left += horizontal_shift
	add	$s1, $s1, $s4			# X_right += horizontal_shift
	beq	$s1, $t0, change_direction	# change direction when X_right == WIDTH-1
	beq	$s0, 0, change_direction	# change direction when X_left == 0
	j	animate_loop			# continue animation loop
	
change_direction:
	neg	$s4, $s4			# $s4 = -$s4
	j	animate_loop
	
	
process_input:					# process input
	lw 	$t1, 0xffff0004
	bne	$t1, 32, animate_loop		# continue animating block if space (32) not entered
	
place_block:
	# stop moving the block and compare the block position to the stack position.
	# game over if the block is not placed on the stack.
	# otherwise, remove any parts of the block that are hanging off the stack
	
	lw	$s7, block_color		# save block color in s7
	li	$t0, BACKGROUND_COLOR		# t0 = BACKGROUND_COLOR
	sw	$t0, block_color 		# set block color to background color
	
compare_left:					# compare left side
	lw	$a1, left_position		# a1 = left_position - 1
	addi	$a1, $a1, -1
	ble	$s1, $a1, game_over		# if X_right <= left_position - 1, game over				
	ble	$s0, $a1, blackout_left 	# if X_left <= left_position - 1, blackout left
	sw	$s0, left_position		# else, left_position = X_left
	j	compare_right
	
blackout_left:					# blackout left part of the black that is hanging off the stack
	move	$a0, $s0			# a0 = X_left (a1 already set to left position)
	move	$a2, $s2			# a2 = Y_bottom
	move	$a3, $s3			# a3 = Y_top
	jal	draw_block			# call draw_block function
	
compare_right:					# compare right side
	lw	$a0, right_position		# a0 = right_position + 1
	addi	$a0, $a0, 1
	bge	$s0, $a0, game_over		# if X_left >= right_position + 1, game over
	bge	$s1, $a0, blackout_right	# if X_right >= right_position + 1, blackout right
	sw	$s1, right_position		# else, right_position = X_right
	j	after_compare_right
	
blackout_right:					# blackout right part of the black that is hanging off the stack
	move	$a1, $s1			# a1 = X_right (a0 already set to right position)
	move	$a2, $s2			# a2 = Y_bottom
	move	$a3, $s3			# a3 = Y_top
	jal	draw_block			# call draw_block function
	
after_compare_right:				# after the block is placed:
	sw	$s7, block_color		# restore block color back to original color
	sw	$s3, y_position			# y_position = Y top position
	
	li 	$v0, 31				# play wood block sound
	li 	$a0, 67				# pitch = 67 = G
	li 	$a1, 300			# duration = 300 ms
	li 	$a2, 115			# instrument = wood block
	li 	$a3, 127			# volume = 127 (max)
	syscall			
	
	jal	move_stack_down 		# move the stack down (if y_position >= HEIGHT/2)
	
	jal	change_block_color		# change block color to the next color in colors array
	
	jal	increase_score			# increase the score count
	
	lw	$ra, ($sp)			# restore return address from the stack
	addi	$sp, $sp, 4
	jr	$ra				# return


#############################################
# function to animate entire stack moving down by BLOCK_HEIGHT
# no args
move_stack_down:
	# only move stack down if y_position >= HEIGHT/2
	li	$t0, HEIGHT		# t0 = HEIGHT/2
	sra	$t0, $t0, 1

	lw	$t1, y_position		# t1 = y_position
	bgt	$t1, $t0, return	# return if y_position > HEIGHT/2 
	
	addi	$sp, $sp, -4		# save return address on the stack
	sw	$ra, ($sp)	
	
	addi 	$t0, $0, WIDTH  		# t0 = WIDTH/2
	sra 	$t0, $t0, 1
	li	$t1, INITIAL_BLOCK_WIDTH	# t1 = INITIAL_BLOCK_WIDTH/2
	sra	$t1, $t1, 1			
	sub	$s0, $t0, $t1			# s0 = WIDTH/2 - INITIAL_BLOCK_WIDTH/2 = left position
	add	$s1, $t0, $t1			# s1 = WIDTH/2 + INITIAL_BLOCK_WIDTH/2 + 1 = right position
	addi	$s1, $s1, -1
	
	# move down the stack by one pixel, BLOCK_HEIGHT times
	li	$s2, 0				# s2 = i = 0
	# while (i < BLOCK_HEIGHT) move stack down one pixel
move_down_loop:
	# starting at bottom, going up to HEIGHT/2,
	# loop from left position to right position and copy down the color of the pixel above
	li	$t0, HEIGHT
	addi	$s3, $t0, -1			# s3 = HEIGHT - 1 = Y position
	sra	$s4, $s3, 1			# s4 = (HEIGHT-1)/2 = ending Y position
move_vertical_loop:
	move	$s5, $s0			# s5 = s0 = left position
move_horizontal_loop:
						# get color of the pixel above
	move	$a0, $s5			# a0 = X
	addi	$a1, $s3, -1			# a1 = Y - 1 (y position above)
	jal	get_address			# call function to get address; returns address in $v0
	lw	$a2, ($v0)			# a2 = color of the pixel above
	
	move	$a1, $s3			# a1 = Y
	jal	draw_pixel			# call function to draw pixel at current location
		
continue:	
	addi	$s5, $s5, 1			# X position += 1
	ble	$s5, $s1, move_horizontal_loop	# jump back to move_horizontal_loop when ending X position not reached
	addi	$s3, $s3, -1			# Y-- (move Y position up 1)
	bge	$s3, $s4, move_vertical_loop	# jump back to move_vertical_loop when ending Y position not reached
	addi	$s2, $s2, 1			# i++
	li	$t0, BLOCK_HEIGHT
	lw	$t1, game_delay			# pause for GAME_DELAY ms
	pause ($t1)
	blt	$s2, $t0, move_down_loop	# move the whole stack down again if i < BLOCK_HEIGHT
	
	lw	$t0, y_position
	addi	$t0, $t0, BLOCK_HEIGHT
	sw	$t0, y_position			# y_position -= BLOCK_HEIGHT
	lw	$ra, ($sp)			# restore return address from stack
	addi	$sp, $sp, 4
return:
	jr	$ra				# return
	

#################################################
# function to draw the initial block
# no args
draw_initial_block:
	# setup arguments to draw block at center bottom of screen
	li 	$t0, WIDTH  			# t0 = WIDTH/2
	sra 	$t0, $t0, 1
	li	$t1, INITIAL_BLOCK_WIDTH	# t1 = INITIAL_BLOCK_WIDTH/2
	sra	$t1, $t1, 1			
	sub	$a0, $t0, $t1			# a0 = t0 - t1 = left bound of block
	sw	$a0, left_position		# update left_position
	add	$a1, $t0, $t1			# a1 = t0 + t1 - 1 = right bound of block
	addi	$a1, $a1, -1
	sw	$a1, right_position		# update right_position
	
	li 	$a2, HEIGHT   			# a2 = HEIGHT-1 (bottom of screen)
	addi	$a2, $a2, -1
	addi	$a3, $a2, -INITIAL_BLOCK_HEIGHT	# a3 = top bound of block
	sw	$a3, y_position			# update y_position

	addi	$sp, $sp, -4			# store $ra on stack
	sw	$ra, ($sp)
	jal	draw_block			# call draw_block function
	sw	$0, block_delay			# set block delay to 0
	lw	$ra, ($sp)
	addi	$sp, $sp, 4			# restore $ra from stack
	jr	$ra				# return


#################################################
# function to draw a block
# $a0 = leftmost X position (X_left)
# $a1 = rightmost X position (X_right)
# $a2 = bottom Y position (Y_bottom)
# $a3 = top Y position (Y_top)
draw_block:
	addi	$sp, $sp, -16
	sw	$ra, ($sp)		# store $ra on stack
	sw	$s0, 4($sp)		# store saved registers on stack before using them
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)

	move	$s0, $a0		# s0 = a0 = X_left
	move	$s1, $a1		# s1 = a1 = X_right
	move	$s2, $a3		# s2 = a3 = Y_top
	
	move	$a1, $a2		# a1 = Y_bottom
	lw	$a2, block_color	# a2 stores color of block
	lw	$t0, block_delay	# t0 = block delay
	
height_loop:				# while (Y > Y_top) {
	move	$a0, $s0		#   a0 = current X position = X_left
	pause ($t0)
	
width_loop:				#   while (X <= X_right) {
	jal	draw_pixel		#     draw pixel
	addi	$a0, $a0, 1		#     X++
	
	ble	$a0, $s1, width_loop	#   }		# jump back to length_loop when X_right not reached
	addi	$a1, $a1, -1		#   Y--		# otherwise, decrease Y value by 1 (move up 1)
	bgt	$a1, $s2, height_loop	# }		# jump back to height_loop when Y_top not reached
	
	# after loops have finished
	lw	$ra, ($sp)		# restore saved registers from stack
	lw	$s0, 4($sp)	
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)	
	addi	$sp, $sp, 16
	jr	$ra			# return


#########################################################
# function to increase the score count
# no args
increase_score:
	lw	$t0, score
	addi	$t0, $t0, 1
	sw	$t0, score
	jr	$ra
	

##############################################################
# function to change the block color to the next one in the color gradient array
# no args
change_block_color:
	lw	$t0, color_index	# t0 = current color index
	addi	$t0, $t0, 1		# color_index++
	sw	$t0, color_index
	sll	$t0, $t0, 2		# t0 *= 4
	la	$t1, color_gradient	# t1 = &color_gradient[0]
	add	$t3, $t0, $t1		# t3 = &color_gradient[i]
	lw	$t4, ($t3)		# t4 = color_gradient[i]
	
	# if color_gradient[i] < 0, set color_index back to 0
	bge	$t4, $0, set_color
	sw	$0, color_index		# color_index = 0
	lw	$t4, ($t1)		# t4 = color_gradient[0] = first color in array
	
set_color:
	sw	$t4, block_color	# block_color = t4
	jr	$ra			# return


#################################################
# function to draw and animate the game title "MIPS STACKER"
# no args
draw_title:
	addi	$sp, $sp, -12		# store return address on stack
	sw	$ra, ($sp)
	sw	$s0, 4($sp)		# store saved registers on stack
	sw	$s1, 8($sp)
	
	# draw "MIPS" title in initial block color
	li	$a2, INITIAL_COLOR
	li	$a3, 500		# delay of 500 ms between each letter
	jal	draw_MIPS
	
	# draw "STACKER" subtitle in white
	li	$a2, WHITE		# load white color
	jal	draw_STACKER
	
	# draw blue subtitle underline
	li	$a2, INITIAL_COLOR	# load blue color
	li	$a3, 10			# delay of 50 ms between each pixel draw
	jal	draw_underline
	
	# flash "STACKER" between white and yellow colors 5 times
	li	$s0, 0
	li	$s1, 5
flash_loop:
	pausei (250)
	li	$a2, YELLOW
	jal	draw_STACKER
	
	pausei (250)
	li	$a2, WHITE
	jal	draw_STACKER
	
	addi	$s0, $s0, 1
	blt	$s0, $s1, flash_loop
	
	# after loop
	lw	$ra, ($sp)		# restore return address from stack
	lw	$s0, 4($sp)		# restore saved registers from stack
	lw	$s1, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra			# return


##########################################
# function to clear the "MIPS STACKER" title
# no args
clear_title:
	addi	$sp, $sp, -4		# store return address on stack
	sw	$ra, ($sp)
	
	li	$a2, BACKGROUND_COLOR	# draw over "MIPS" with black color and no delay
	li	$a3, 250
	jal	draw_MIPS
	
	jal	draw_STACKER		# draw over "STACKER"
	
	li	$a3, 10
	jal	draw_underline		# draw over the underline with delay
	
	lw	$ra, ($sp)		# restore return address from stack
	addi	$sp, $sp, 4
	jr	$ra			# return
	

###########################################
# function to draw "MIPS" title in specified color
# $a2 = color
# $a3 = delay
draw_MIPS:
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	draw_big_M
	pause ($a3)
	draw_big_I
	pause ($a3)
	draw_big_P
	pause ($a3)
	draw_big_S
	pause ($a3)
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
	
###############################################
# function to draw "STACKER" subtitle in specified color
# $a2 = color
draw_STACKER:
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	draw_S			# use macros to draw each letter
	draw_T
	draw_A
	draw_C
	draw_K
	draw_E
	draw_R
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra


###############################################
# function to draw "STACKER" subtitle in specified color
# $a2 = color
# $a3 = delay
draw_underline:
	addi	$sp, $sp, -4		# store return address on stack
	sw	$ra, ($sp)
	li	$a0, 1			# X = 1
	li	$a1, 14			# Y = 14
underline_loop:
	jal	draw_pixel		# draw underline at Y = 14 from X = 1 to X = 30
	addi	$a0, $a0, 1
	pause ($a3)
	blt	$a0, 30, underline_loop
	lw	$ra, ($sp)		# restore return address from stack
	addi	$sp, $sp, 4
	jr	$ra			# return


#################################################
# function to draw a pixel
# $a0 = X
# $a1 = Y
# $a2 = color
draw_pixel:
	addi	$sp, $sp, -4	# store return address on stack
	sw	$ra, ($sp)
	jal	get_address	# call get_address function; returns address in $v0
	sw	$a2, ($v0)	# store color at memory location
	lw	$ra, ($sp)	# restore return address from stack
	addi	$sp, $sp, 4
	jr 	$ra		# return


#################################################
# function that calculates the address of the bitmap from X and Y coordinates
# $a0 = X
# $a1 = Y
# returns:
#	$v0 = the address of the location
get_address:
	# $v0 = address = $gp + 4*(x + y*width)
	mul	$v0, $a1, WIDTH   	# y * WIDTH
	add	$v0, $v0, $a0	  	# add X
	mul	$v0, $v0, 4	  	# multiply by 4 to get word offset
	add	$v0, $v0, $gp	  	# add to base address
	jr	$ra			# return $v0 (address)

