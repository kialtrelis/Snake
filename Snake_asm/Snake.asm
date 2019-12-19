 .kdata     # kernel data
s1: .word 10
s2: .word 11 
                .data
Snake_body:
        .word   0 : 320
Snake_body_end: 0
head_ptr: .word 0
tail_ptr: .word 0
Input: .word 0
Last_Dirrection: .word 0
Score: .word 0
LastTick: .word 0
Ticks: .word 0
TickPeriod: .word 0
Colors: .word   0x000000        # background color (black)
        .word   0xFFFFFF        # foreground color (white
DigitTable:
        .byte   ' ', 0,0,0,0,0,0,0,0,0,0,0,0
        .byte   '0', 0x7e,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '1', 0x38,0x78,0xf8,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
        .byte   '2', 0x7e,0xff,0x83,0x06,0x0c,0x18,0x30,0x60,0xc0,0xc1,0xff,0x7e
        .byte   '3', 0x7e,0xff,0x83,0x03,0x03,0x1e,0x1e,0x03,0x03,0x83,0xff,0x7e
        .byte   '4', 0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '5', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0x7f,0x03,0x03,0x83,0xff,0x7f
        .byte   '6', 0xc0,0xc0,0xc0,0xc0,0xc0,0xfe,0xfe,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '7', 0x7e,0xff,0x03,0x06,0x06,0x0c,0x0c,0x18,0x18,0x30,0x30,0x60
        .byte   '8', 0x7e,0xff,0xc3,0xc3,0xc3,0x7e,0x7e,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '9', 0x7e,0xff,0xc3,0xc3,0xc3,0x7f,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '+', 0x00,0x00,0x00,0x18,0x18,0x7e,0x7e,0x18,0x18,0x00,0x00,0x00
        .byte   '-', 0x00,0x00,0x00,0x00,0x00,0x7e,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   '*', 0x00,0x00,0x00,0x66,0x3c,0x18,0x18,0x3c,0x66,0x00,0x00,0x00
        .byte   '/', 0x00,0x00,0x18,0x18,0x00,0x7e,0x7e,0x00,0x18,0x18,0x00,0x00
        .byte   '=', 0x00,0x00,0x00,0x00,0x7e,0x00,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   'A', 0x18,0x3c,0x66,0xc3,0xc3,0xc3,0xff,0xff,0xc3,0xc3,0xc3,0xc3
        .byte   'B', 0xfc,0xfe,0xc3,0xc3,0xc3,0xfe,0xfe,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'C', 0x7e,0xff,0xc1,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc1,0xff,0x7e
        .byte   'D', 0xfc,0xfe,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'E', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xff,0xff
        .byte   'F', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xc0,0xc0
# add additional characters here....
# first byte is the ascii character
# next 12 bytes are the pixels that are "on" for each of the 12 lines
        .byte    0, 0,0,0,0,0,0,0,0,0,0,0,0
stack_beg:

# .align 3 
        .word   0 : 40
stack_end:
sequence: .byte 0 : 8
.byte 0x00
max: .byte 5
counter: .byte 0
current: .byte 0
win: .asciiz "You Win! "
#.align 3
loss: .asciiz "Game Over. \nPlease hit 'r' to Restart, 'e' to Exit\n "
blank: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n "
controls: 
.asciiz "\n 'a' Left, 'd' Right, 'w' Up, 'S' Down\n 'p' Pause, 'r' Restart game, 'm' Menu, 'e' Exit\n"
.align 2 
ColorTable:
.word
.word  	0x000000	#black 		#0
.word 	0x0000FF 	#blue		#1
.word	0x00FF00 	#green		#2
.word	0xFF0000 	#red		#3
.word	0x00FFFF 	#blue+red	#4
.word	0xFF00FF 	#blue+red	#5
.word	0xFFFF00 	#green+red(yellow)#6
.word 	0xFFFFFF 	#white		#7
.word
CurrentChar: 
.align 3 
.asciiz "5"
.text
 # unit sizes = 8 pixels
 # screen size = 32x32 units
 # arena size = 28x28 units

	#These only once
	la $a0, controls	# Displays controls
	li $v0, 4		#
	syscall			#
	mfc0 $a0, $12   	# read from the status register
      	ori $a0, 0xff11   	# enable all interrupts
      	mtc0 $a0, $12   	# write back to the status register 
      	lui $t0, 0xFFFF   	# $t0 = 0xFFFF0000;
      	ori $a0, $0, 2    	# enable keyboard interrupt
      	sw $a0, 0($t0)   	# write back to 0xFFFF0000; 
      	
	li $v0, 30		# get system time
	syscall 		# a0 has least significant word
	move $a1, $a0		#
	li $a0, 0		#
	li $v0, 40		#
	syscall			# seeds rand set id = 0


# Run every time game restarts.
Begin:
  	li $v0, 30		# Initialzes global variables
	syscall			#		
	sw $a0, LastTick	#
	li $t0, 0		#
	sw $t0, Score		#
	sw $t0, Ticks		#
	sw $t0, Input		#
	sw $t0, Last_Dirrection	#
	li $t0, 200		#
	sw $t0, TickPeriod	#

# draws starting objects
LevelStart:   	
	jal DrawArena			# redraws objects incase display has not been cleared.
	jal ScoreDisplay		#
	jal ClockDisplay		#
 
	la $t0, head_ptr		# creates a snake
	la $t1, tail_ptr		#
	la $t2, Snake_body		#
	la $t3, Snake_body_end		#
	sw $t2, ($t1)			#	
	add $t7, $t2, 8			# 
	sw $t7, ($t0)			#
	
	li $t7, 975			# initilizes a snake
	sw $t7, ($t2)			#
	li $t7, 943			#
	sw $t7, 4($t2)			#
	li $t7, 911			#
	sw $t7, 8($t2)			#
	
	lw $a0, ($t2)			# draws initial Snake
	li $a1, 2			#
	jal DrawUnit			#
	lw $a0, 4($t2)			# 
	li $a1, 2			#
	jal DrawUnit			#
	lw $a0, 8($t2)			# 
	li $a1, 2			#
	jal DrawUnit			#
		
	jal AppleGen			# draws 5 starting apples
	jal AppleGen			#
	jal AppleGen			#
	jal AppleGen			#
	jal AppleGen			#
main:
infloop:				# Base loop for game to keep running.
	jal GameClock			# 
	jal ClockDisplay		# Update Disaply
	lw $a0, Input			# handles users input after each tick
	beq $a0, 4, callPause		#
	beq $a0, 5, callRestart		#
#	beq $a0, 6, callDisplayHighScore#
	beq $a0, 7, callMenue		#
	beq $a0, 8, ExitPrgm		# 
	jal SnakeTracker		#
j infloop	

# Special function calls
#################################
callPause:			#	
	lw $t7 Last_Dirrection	# 
	sw $t7 Input		# clear Input
	jal Pause		# Pause
	j infloop		#
callRestart:			#	
	lw $t7 Last_Dirrection	#
	sw $t7 Input		# clear Input
	jal Restart		# Restarts
	j infloop		#
#callDisplayHighScore:		#	
#	lw $t7 Last_Dirrection	#
#	sw $t7 Input		# clear Input
#	jal HighScoreDisplay	# Displays High Score
#	j infloop		#
callMenue:			#	
	lw $t7 Last_Dirrection	#
	sw $t7 Input		# clear Input
	jal Menue		# Displays Menue
	j infloop		#
#################################
        
        
        
# Menue: Displays Controls
Menue:
	la $a0, controls	# Displays controls
	li $v0, 4		#
	syscall			#
 jr $ra
          
          
          
# Restarts game
Restart:
j Begin


                
# Draws the starting arena
DrawArena:
	addiu	$sp, $sp, -4	# make room on stack
	sw $ra, 0($sp)		# store $ra

	li $a0, 8		# draws a black square inside a white square
	li $a1, 16		#
	li $a2, 7		#
	li $a3, 240		#
	jal DrawBox		#
	li $a0, 16		#
	li $a1, 24		#
	li $a2, 8		#
	li $a3, 224		#
	jal DrawBox		#

	lw $ra, 0($sp)		# load original $ra
	addiu $sp, $sp,4	# adjust $sp
jr	$ra

  		
			
# $a0 = dirrection(0-3:up,down,left,right)
SnakeTracker:	
addiu	$sp, $sp, -8		# make room on stack
	sw $ra, 0($sp)		# store $ra
	sw $s0, 4($sp)		# save $s0
	
	lw $t7, head_ptr	# checks if head_ptr is at the end of the memmory frame.
	la $t5, Snake_body_end	#
	beq $t5, $t7, headEq	#	
	add $t5, $t7, 4		# new head_ptr
headEqReturn:

	lw, $t1, Last_Dirrection# 
	lw $t0, ($t7)		#
	beq $a0, 0, headUp	# Switch(k) branches for next movement
	beq $a0, 1, headDown	#
	beq $a0, 2, headLeft	#
	beq $a0, 3, headRight	#	
headUp:				# case 0:
	beq $t1, 1, headDown	# if(last is in opposite dirrection) continue in last dirrection
	sub $t0, $t0, 32	#
	li $t1,0		#
	sw $t1, Last_Dirrection	# save dirrection of movement
j endHeadBranch			
headDown:			# case 1:
	beq $t1, 0, headUp	# if(last is in opposite dirrection) continue in last dirrection
	add $t0, $t0,32		#
	li $t1,1		#
	sw $t1, Last_Dirrection	# save dirrection of movement
j endHeadBranch			
headLeft:			# case 2:
	beq $t1, 3, headRight	# if(last is in opposite dirrection) continue in last dirrection
	sub $t0, $t0, 1		#
	li $t1,2		#
	sw $t1, Last_Dirrection	# save dirrection of movement
j endHeadBranch			
headRight:			# case 3:
	beq $t1, 2, headLeft	# if(last is in opposite dirrection) continue in last dirrection
	add $t0, $t0, 1		#
	li $t1,3		#
	sw $t1, Last_Dirrection	# save dirrection of movement
endHeadBranch:			
	sw $t0,($t5)		# Saves new location to head_ptr
	sw $t5, head_ptr	#
	
	move $s0, $t0		# Calls Collision Handler
	move $a0, $t0		#
	jal CollisionHandler	#
	move $t0 $s0		#
	move $s0, $v0		#
	
	move $a0, $t0		# Draws new head
	li $a1, 2		# 
	jal DrawUnit		#
	
	beq $s0, 1, snakeGrow	# if(apple hit = true) size + 1

	lw $t4, tail_ptr	# Draws over old tail		
	lw $a0, ($t4)		#
	li $a1, 0		#
	jal DrawUnit		#

	la $t3, Snake_body_end	#
	lw $t1, tail_ptr	#
	beq $t3, $t1, tailEq	# checks if tail_ptr is at the end of the memmory frame.
	add $t1, $t1, 4		# tail_ptr = tail_ptr + 1
	sw $t1, tail_ptr	#
tailEqReturn:
snakeGrow:	
	lw $s0, 4($sp)		# 
	lw $ra, 0($sp)		# load original $ra
	addiu $sp, $sp,8	# adjust $sp
jr $ra
# special cases for SnakeTracker when
# tail_ptr, or tail_ptr hits the end of the Snake_body container
#################################
tailEq:				#
	la $t2, Snake_body	#
	sw $t2, tail_ptr	#
j tailEqReturn			#
headEq:				#
	la $t5, Snake_body	#
j headEqReturn			#
#################################



# Updates the displayed score
ScoreDisplay:
	addiu	$sp, $sp, -12	# make room on stack
	sw $ra, 0($sp)		# store $ra
	sw $s0, 4($sp)		# save $s0
	sw $s1, 8($sp)		# save $s1

	lw $s0, Score		# loead Score
	li $s1, 80		#
scoreDisLoop:
	li $t6, 10		#
	div $s0, $t6		# strips lowest diget off score
	mfhi $t7 		# Current diget(remainder from division)
	mflo $s0		# unprocessed score
		
	addiu $t7, $t7, 48	#
	la $a2 CurrentChar	#
	sw $t7, ($a2)		#
	move $a0, $s1		#
	li $a1, 0		#
	jal OutText		# Displays current score

	sub $s1, $s1, 10	#
	bgt $s1, 0 scoreDisLoop # While(incrimenter>=10)

	lw $s1, 8($sp)		# 
	lw $s0, 4($sp)		# 
	lw $ra, 0($sp)		# load original $ra
	addiu $sp, $sp,12	# adjust $sp
jr $ra



# Updates Displayed time
ClockDisplay:
	addiu	$sp, $sp, -12	# make room on stack
	sw $ra, 0($sp)		# store $ra
	sw $s0, 4($sp)		# save $s0
	sw $s1, 8($sp)		# save $s1

	lw $s0, Ticks		# loead Ticks
	li $s1, 239		#
clockDisLoop:
	li $t6, 10		#
	div $s0, $t6		# strips lowest diget off time
	mfhi $t7 		# Current diget(remainder from division)
	mflo $s0		# unprocessed digets
		
	addiu $t7, $t7, 48	#
	la $a2 CurrentChar	#
	sw $t7, ($a2)		#
	move $a0, $s1		#
	li $a1, 0		#
	jal OutText		# Displays current

	sub $s1, $s1, 10	#
	bgt $s1, 159 clockDisLoop# While(incrimenter>=10)

	lw $s1, 8($sp)		# 
	lw $s0, 4($sp)		# 
	lw $ra, 0($sp)		# load original $ra
	addiu $sp, $sp,12	# adjust $sp
jr $ra



# $v0 = 1(apple hit), 0(no apple hit)
ScoreKeeper:
	lw $t0, Score		# updates score
	add $t0, $t0, 100	#
	sw $t0, Score		#
jr $ra				#



# $a0 = location value
# $v0 = (0 no collision, 1 apple)
CollisionHandler:
	addiu	$sp, $sp, -4	# make room on stack
	sw $ra, 0($sp)		# store $ra

	jal LocToXY		# change loc value to (x,y)
	move $a0, $v0		#
	move $a1, $v1		#
	jal ReadObject		# get color at(x,y)

	beq $v0, 3, collisionApple# Collision type branch statements 
	beq $v0, 2, collisionBad#
	beq $v0, 7, collisionBad#
	#beq $v0, 0, collisionNo# removed because $v0 already = 0 so no action required
collisionBranchEnd:		
	lw $ra, 0($sp)		# load original $ra
	addiu $sp, $sp,4	# adjust $sp	
jr $ra				# return()
collisionApple:			
	jal AppleGen		# Generates a new apple
	li $a0, 1		#
	jal ScoreKeeper		# updates score
	jal ScoreDisplay	# updates score display
	li $v0, 1		# $v0 = 1
j collisionBranchEnd		#
collisionBad:			
j GameOver			# jumps straight to GameOver function



# Generates an apple and places it at a valid location
AppleGen:
	addiu	$sp, $sp, -12	# make room on stack
	sw $ra, 0($sp)		# store $ra
	sw $s0, 4($sp)		# 
	sw $s1, 8($sp)		# 
reroleApple:
	li $v0, 42		# Generates a random value between 1-28
	li $a0, 0 		#
	li $a1, 28		#
	syscall			#
	add $s0, $a0, 2		# adjust vlaue to be inside arena
	sll $s0, $s0, 3
	
	li $v0, 42		# Generates a random value between 1-28
	li $a0, 0 		#
	li $a1, 28		#
	syscall			#
	add $s1, $a0, 3		# adjust vlaue to be inside arena
	sll $s1, $s1, 3		#
	
	move $a0, $s0		#
	move $a1, $s1		#
	jal ReadObject		#
	bne $v0, 0, reroleApple	# if(getcolor(x,y) != black) reroleApple
	
	move $a0, $s0		#
	move $a1, $s1		#
	li $a2, 3		#
	li $a3, 8		#
	jal DrawBox		# Draws new apple
	
	lw $s0, 4($sp)		# 
	lw $s1, 8($sp)		# 
	lw $ra, 0($sp)		# load original $ra
	addiu $sp, $sp,12	# adjust $sp	
jr $ra



# $a0 = location value
# $v0 = left most x
# $v1 = top most y
LocToXY:
	li $t0, 32		#
	div $a0, $t0		# temp = (num/32)
	mfhi $v0		# x = remainder * 8
	mflo $v1		# y = temp * 8
	sll $v0, $v0, 3		#
	sll $v1, $v1, 3		#
jr $ra



# $a0 = left most x
# $a1 = top most y
# $v0 = location value
XYToLoc:
	srl $a0, $a0, 3		# value = (x/8)+((y/8)*32)
	srl $a0, $a0, 3		#
	mul $v0, $a1, 32	#
	add $v0, $v0, $a0	# 
jr $ra



# $a0 = locaiton unit
# $a1 = color (0-7)
DrawUnit:
addiu	$sp, $sp, -8		# make room on stack
	sw $ra, 0($sp)		# store $ra
	sw $a1, 4($sp)		# save $a1
	
	jal LocToXY		# converts location to xy
	move $a0, $v0		#
	move $a1, $v1		#
	lw $a2, 4($sp)		# restors color
	li $a3, 8		#
	jal DrawBox		# Draws box

#	lw $a1, 4($sp)		#
	lw $ra, 0($sp)		# load original $ra
	addiu $sp, $sp,8	# adjust $sp
jr $ra



# $a0 = x coordinate (0-31)
# $a1 = y coordinate (0-31)
# $v0 = object code (0-7)
ReadObject:
	addiu	$sp, $sp, -12	# make room on stack
	sw $ra, 4($sp)		# store $ra
	sw $s0, 0($sp)		# store $s0
	sw $s1, 8($sp)		# store $s1
	
	jal CalcAddress 	# v0 has address for pixel

	lw $s0, 0($v0)		# gets color
	li $s1, 0		#
readObLoop:
	move $a2, $s1		# if (colorAt(location) == i) return i
	jal GetColor		# 	
	beq $v1, $s0, readObEnd	#
	addi $s1, $s1, 1	#
	bge $s1, 10,readObEnd	#
	j readObLoop 		#
readObEnd:
	move $v0, $s1		# $v0 = i
	
	lw $s0, 0($sp)		# restore $s0
	lw $s1, 8($sp)		# restore $s1
	lw $ra, 4($sp)		# load original $ra
	addiu $sp, $sp,12	# adjust $sp	
jr $ra	
	
	
	
#controls the games internal clock
GameClock:	
   	li $v0, 30		#
	lw $t7 LastTick		#
	lw $t0 TickPeriod	#
clockLoop:			
	syscall			# calculates difrence in time and loops till amount of time has passed.
	subu $t2, $a0, $t7	#
	bltu $t2, $t0, clockLoop#
	sw $a0, LastTick	#
		
	lw $t6 Ticks		# Ticks++
	addi $t6, $t6,1		#
	sw $t6 Ticks		#
jr $ra
       
    

#pausses until p is hit again
Pause:

	li $t0, 200		# sets s amount of time for program to wait
	li $v0, 30		#
	syscall			#
	move $t7, $a0		#
ploop2:
	syscall			# calculates difrence in time and loops till amount of time has passed.
	subu $t2, $a0, $t7	# THIS MUST REMAIN TO PREVENT MIPS FREEZING
	bltu $t2, $t0, ploop2	#
	
	lw $t3, Input		#
 	beq $t3, 8, ExitPrgm
	beq $t3, 5, Restart	# Handles if user attempts to restart while game paused
	beq $t3, 7, pMenue	#
	bne $t3, 4, Pause	# Loops infinatly untill p is his again 
	
	lw $t4 Last_Dirrection	# 
	sw $t4 Input		# clear Input
jr $ra				# Return
pMenue:
	addiu	$sp, $sp, -4	# make room on stack
	jal Menue		#
	lw $t4 Last_Dirrection	# 
	sw $t4 Input		# clear Input
	sw $ra, 0($sp)		# store $ra
	lw $ra, 0($sp)		# load original $ra
j Pause

# imported functions
##############################################################################################################################################
# $a0 = x coordinate (0-255)
# $a1 = y coordinate (0-255)
# returns $v0 = memory address
CalcAddress:
	li $v0, 0x10040000	# $vo = base + ($a0 x 4)+ ($a1 x 32 x 4)
	sll $a0, $a0, 2		#  
	sll $a1, $a1, 10	# was 7?
	add $v0, $v0, $a0	#
	add $v0, $v0, $a1	#
jr	$ra



# $a2 = color number (0-7)
# return $v1 = actual number to write to the display
GetColor:
	la $t0, ColorTable	# load base
	sll $a2, $a2, 2		# index x 4 is offset
	add $a2, $a2, $t0	# address is base  + offset
	lw $v1, 0($a2)		# get actual color from memory	
jr	$ra

	
			
# $a0 = x coordinate (0-255)
# $a1 = y coordinate (0-255)
# $a2 = color number (0-7)
DrawDot:
	addiu	$sp, $sp, -8	# make room on stack, 2 words
	sw $ra, 4($sp)		# store $ra
	sw $a2, 0($sp)		# store $a2
	jal CalcAddress 	# v0 has address for pixel

	lw $a2, 0($sp)		# restore $a2
	sw $v0, 0($sp)		# save $v0
	jal GetColor		# v1 has color
	
	lw $v0, 0($sp)		# restore $v0
	sw $v1, 0($v0)		# make dot
	lw $ra, 4($sp)		# load original $ra
	addiu $sp, $sp,8	# adjust $sp
jr $ra	



# $a0 = x coordinate (0-255)
# $a1 = y coordinate (0-255)
# $a2 = color number (0-7)
# $a3 = length of the line (1-32)
HorzLine: 
	addiu	$sp, $sp, -20	# make room on stack, 5 words
	sw $ra, 0($sp)		# store $ra
	sw $a0, 4($sp)		# store $a0
	sw $a1, 8($sp)		# store $a1
	sw $a2, 12($sp)		# store $a2

HorzLoop:
	sw $a0, 4($sp)		# store $a0
	sw $a3, 16($sp)		# store $a3
	
	jal DrawDot		# draws current pixel

	lw $a0, 4($sp)		# restore $a0
	lw $a1, 8($sp)		# restore $a1
	lw $a2, 12($sp)		# restore $a2
	lw $a3, 16($sp)		# restore $a3
	
	addi $a0, $a0, 1	# $a0++
	addi $a3, $a3, -1	# $a3--

	bne $a3, $0, HorzLoop	# if(a3 != 0){goto: HorzLoop}

	lw $ra, 0($sp)		# load original $ra
	addiu	$sp, $sp, 20	# remove 5 words from the stack
jr $ra	
		


# $a0 = x coordinate (0-255)
# $a1 = y coordinate (0-255)
# $a2 = color number (0-7)
# $a3 = length of the line (1-256)
VertLine:
	addiu	$sp, $sp, -20	# make room on stack, 5 words
	sw $ra, 0($sp)		# store $ra
	sw $a0, 4($sp)		# store $a0
	sw $a1, 8($sp)		# store $a1
	sw $a2, 12($sp)		# store $a2

VertLoop:
	sw $a1, 8($sp)		# store $a0
	sw $a3, 16($sp)		# store $a3
	
	jal DrawDot		# draws current pixel

	lw $a0, 4($sp)		# restore $a0
	lw $a1, 8($sp)		# restore $a1
	lw $a2, 12($sp)		# restore $a2
	lw $a3, 16($sp)		# restore $a3
	
	addi $a1, $a1, 1	# $a1++
	addi $a3, $a3, -1	# $a3--

	bne $a3, $0, VertLoop	# if(a3 != 0){goto: VertLoop}

	lw $ra, 0($sp)		# load original $ra
	addiu	$sp, $sp, 20	# remove 5 words from the stack
jr $ra	

		
	
# $a0 = x coordinate (0-255)
# $a1 = y coordinate (0-255)
# $a2 = color number (0-7)
# $a3 = size of the box (1-256)	
DrawBox:
	addiu	$sp, $sp, -24	# make room on stack, 6 words
	sw $ra, 0($sp)		# store $ra
	sw $a0, 4($sp)		# store $a0
	sw $a1, 8($sp)		# store $a1
	sw $a2, 12($sp)		# store $a2
	sw $a3, 16($sp)		# store $a3
	sw $s0, 20($sp)		# store $s0

	move $s0, $a3		# copy $a3 -> temp register $s0
BoxLoop:
	lw $a0, 4($sp)		# restore $a0
	lw $a2, 12($sp)		# restore $a2
	lw $a3, 16($sp)		# restore $a3
	
	jal HorzLine 		# draws current line

	addi $a1, $a1, 1	# $a1++
	addiu $s0, $s0, -1 	# decrement counter
	bne	$s0, $0, BoxLoop #if(s0 != 0){goto: BoxLoop}
	
	lw $ra, 0($sp)		# load original $ra
	lw $s0, 20($sp)		# load original $s0
	addiu	$sp, $sp, 24	# remove 6 words from the stack	
jr	$ra



GameOver:	
	la $sp, stack_end	#re initializes sp allowing Game over to be called by any funciton at any time
				#without causing a sp allignment problem
      	la 	$a0, loss	#
	li	$v0, 4		# displays "GAME OVER!"
    	syscall			#
    	
endGameLoop:
	jal GameClock		# Prevents game from closing upone loss
    	lw $t7 Input		# allowing player to exit or restart
 	beq $t7, 5, Restart	#
 	beq $t7, 8, ExitPrgm	#
	lw $t7 Last_Dirrection	#
	sw $t7 Input		# clear Input
j endGameLoop
ExitPrgm: 	
        li      $v0, 10		# Exits program
        syscall 		#

                                                                                                                                                                                              
###########################################################################################################################################################                
# OutText: display ascii characters on the bit mapped display
# $a0 = horizontal pixel co-ordinate (0-255)
# $a1 = vertical pixel co-ordinate (0-255)
# $a2 = pointer to asciiz text (to be displayed)
OutText:
        addiu   $sp, $sp, -24
        sw      $ra, 20($sp)

        li      $t8, 1          # line number in the digit array (1-12)
_text1:
        la      $t9, 0x10040000 # get the memory start address
        sll     $t0, $a0, 2     # assumes mars was configured as 256 x 256
        addu    $t9, $t9, $t0   # and 1 pixel width, 1 pixel height
        sll     $t0, $a1, 10    # (a0 * 4) + (a1 * 4 * 256)
        addu    $t9, $t9, $t0   # t9 = memory address for this pixel

        move    $t2, $a2        # t2 = pointer to the text string
_text2:
        lb      $t0, 0($t2)     # character to be displayed
        addiu   $t2, $t2, 1     # last character is a null
        beq     $t0, $zero, _text9

        la      $t3, DigitTable # find the character in the table
_text3:
        lb      $t4, 0($t3)     # get an entry from the table
        beq     $t4, $t0, _text4
        beq     $t4, $zero, _text4
        addiu   $t3, $t3, 13    # go to the next entry in the table
        j       _text3
_text4:
        addu    $t3, $t3, $t8   # t8 is the line number
        lb      $t4, 0($t3)     # bit map to be displayed

        sw      $zero, 0($t9)   # first pixel is black
        addiu   $t9, $t9, 4

        li      $t5, 8          # 8 bits to go out
_text5:
        la      $t7, Colors
        lw      $t7, 0($t7)     # assume black
        andi    $t6, $t4, 0x80  # mask out the bit (0=black, 1=white)
        beq     $t6, $zero, _text6
        la      $t7, Colors     # else it is white
        lw      $t7, 4($t7)
_text6:
        sw      $t7, 0($t9)     # write the pixel color
        addiu   $t9, $t9, 4     # go to the next memory position
        sll     $t4, $t4, 1     # and line number
        addiu   $t5, $t5, -1    # and decrement down (8,7,...0)
        bne     $t5, $zero, _text5

        sw      $zero, 0($t9)   # last pixel is black
        addiu   $t9, $t9, 4
        j       _text2          # go get another character

_text9:
        addiu   $a1, $a1, 1     # advance to the next line
        addiu   $t8, $t8, 1     # increment the digit array offset (1-12)
        bne     $t8, 13, _text1

        lw      $ra, 20($sp)
        addiu   $sp, $sp, 24
        jr      $ra


        
        
 .ktext 0x80000180    		# kernel code
      	.set noat    		# unlock($at)
      	move $k1, $at  	 	# 
      	.set at    		# unlock($at) 
      	sw $v0, s1    		# saving registers
      	sw $a0, s2    		# 
     
      	mfc0 $k0, $13  	 	# Cause register
      	srl $a0, $k0, 2		# Extract ExcCode Field
      	andi $a0, $a0, 0x1f 	# 
	bne $a0, $zero, kdone   # Ignores all other error code
KeyPress:
      	lui $v0, 0xFFFF   	# $t0 = 0xFFFF0000;
      	lw $a0, 4($v0)   	# get the input key
 
      	beq $a0, 'w', pressw	# valid inputs
	beq $a0, 's', presss	# case(k):
	beq $a0, 'a', pressa	#
	beq $a0, 'd', pressd	#
	beq $a0, 'p', pressp	#
	beq $a0, 'r', pressr	#
	#beq $a0, 'h', pressh	#
	beq $a0, 'm', pressm	#
	beq $a0, 'e', presse	#
	j kdone			# NO OP for all other inputs
pressw:	
	li $a0, 0		# case0:
	sw $a0, Input		#
	j kdone			#
presss:	
	li $a0, 1		# case1:
	sw $a0, Input		#
	j kdone			#
pressa:
	li $a0, 2		# case2:
	sw $a0, Input		#
	j kdone			#
pressd:
	li $a0, 3		# case3:
	sw $a0, Input		#
	j kdone			#
pressp:
	li $a0, 4		# case4:
	sw $a0, Input		#
	j kdone			#
pressr:
	li $a0, 5		# case5:
	sw $a0, Input		#
	j kdone			#
#pressh:
#	li $a0, 6		# case6:
#	sw $a0, Input		#
#	j kdone			#
pressm:
	li $a0, 7		# case7:
	sw $a0, Input		#
	j kdone			#
presse:
	li $a0, 8		# case8:
	sw $a0, Input		#
	
kdone:
      mtc0 $0, $13    	# Clear Cause register
      mfc0 $k0, $12   	# Set Status register
      andi $k0, 0xfffd	# clear EXL bit
      ori  $k0, 0x11  	# Interrupts enabled
      mtc0 $k0, $12   	# write back to status 
      lw $v0, s1   	# Restore other registers
      lw $a0, s2 
      .set noat    	# tell the assembler not to use $at
      move $at, $k1   	# Restore $at
      .set at     	# tell the assembler okay to use $at 
      eret     		# return to EPC 

