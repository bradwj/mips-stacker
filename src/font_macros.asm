# font_macros.asm
# contains macros used to draw letters on the Bitmap Display

# macro to draw big M
.macro draw_big_M
	# left column
	li	$a0, 1		# X = 1
	li	$a1, 7		# Y = 7
	jal	draw_pixel
	li	$a1, 6		# Y = 6
	jal	draw_pixel
	li	$a1, 5		# Y = 5
	jal	draw_pixel		
	li	$a1, 4		# ...
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 2		# X = 2
	li	$a1, 7		# Y = 7
	jal	draw_pixel
	li	$a1, 6		# Y = 6
	jal	draw_pixel
	li	$a1, 5		# Y = 5
	jal	draw_pixel		
	li	$a1, 4		# ...
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 3		# X = 3
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 4		# X = 4
	li	$a1, 4
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	
	li	$a0, 5		# X = 5
	li	$a1, 4
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	
	li	$a0, 6		# X = 6
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel

	
	# right column
	li	$a0, 7		# X = 7	
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel
	li	$a1, 5	
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	# right column
	li	$a0, 8		# X = 8
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel
	li	$a1, 5	
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
.end_macro

# macro to draw big I
.macro draw_big_I
	# draw left end
	li	$a0, 10 	# X = 10
	li	$a1, 1
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 6
	jal	draw_pixel
	li	$a1, 7
	jal	draw_pixel
	
	li	$a0, 11 	# X = 11
	li	$a1, 1
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 6
	jal	draw_pixel
	li	$a1, 7
	jal	draw_pixel
	
	# middle column of I
	li	$a0, 12		# X = 12
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel
	li	$a1, 5	
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 13		# X = 13
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel
	li	$a1, 5	
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	# draw right end
	li	$a0, 14 	# X = 14
	li	$a1, 1
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 6
	jal	draw_pixel
	li	$a1, 7
	jal	draw_pixel
	
	li	$a0, 15 	# X = 15
	li	$a1, 1
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 6
	jal	draw_pixel
	li	$a1, 7
	jal	draw_pixel
.end_macro

# macro to draw big P
.macro draw_big_P
	li	$a0, 17		# X = 17		
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel
	li	$a1, 5	
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 18		# X = 18
	li	$a1, 7				
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel
	li	$a1, 5	
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 19		# X = 19
	li	$a1, 7
	jal	draw_pixel
	li	$a1, 6
	jal	draw_pixel
	li	$a1, 5
	jal	draw_pixel
	li	$a1, 4
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 20		# X = 20
	li	$a1, 5
	jal	draw_pixel
	li	$a1, 4
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 21		# X = 21
	li	$a1, 5
	jal	draw_pixel
	li	$a1, 4
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 22		# X = 22
	li	$a1, 5
	jal	draw_pixel
	li	$a1, 4
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
.end_macro	

# macro to draw big S
.macro draw_big_S
	li	$a0, 24		# X = 24		
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 25		# X = 25		
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 3
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 26		# X = 26		
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 27		# X = 27		
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 28		# X = 28		
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel
	li	$a1, 5			
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
	
	li	$a0, 29		# X = 29		
	li	$a1, 7			
	jal	draw_pixel
	li	$a1, 6			
	jal	draw_pixel
	li	$a1, 5			
	jal	draw_pixel		
	li	$a1, 4			
	jal	draw_pixel
	li	$a1, 2
	jal	draw_pixel
	li	$a1, 1
	jal	draw_pixel
.end_macro

# macro to draw S
.macro draw_S
	li	$a0, 2		# X = 2
	li	$a1, 9		# Y = 9
	jal	draw_pixel
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 3		# X = 3
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 4		# X = 4
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
.end_macro

# macro to draw T
.macro draw_T
	li	$a0, 6		# X = 6
	li	$a1, 9
	jal	draw_pixel
	
	li	$a0, 7		# X = 7
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 8		# X = 8
	li	$a1, 9
	jal	draw_pixel
.end_macro

# macro to draw A
.macro draw_A
	li	$a0, 10		# X = 10
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 11		# X = 11
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	
	li	$a0, 12		# X = 12
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
.end_macro

# macro to draw C
.macro draw_C
	li	$a0, 14		# X = 14
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 15		# X = 15
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 16		# X = 16
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
.end_macro

# macro to draw K
.macro draw_K
	li	$a0, 18		# X = 18
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 19		# X = 19
	li	$a1, 11
	jal	draw_pixel
	
	li	$a0, 20		# X = 20
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
.end_macro

# macro to draw E
.macro draw_E
	li	$a0, 22		# X = 22
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 23		# X = 23
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 24		# X = 24
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
.end_macro

# macro to draw R
.macro draw_R
	li	$a0, 26		# X = 26
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
	
	li	$a0, 27		# X = 27
	li	$a1, 9
	jal	draw_pixel
	li	$a1, 11
	jal	draw_pixel
	
	li	$a0, 28		# X = 28
	li	$a1, 10
	jal	draw_pixel
	li	$a1, 12
	jal	draw_pixel
	li	$a1, 13
	jal	draw_pixel
.end_macro
