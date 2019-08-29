##int main(){
##	
##	int weightcatch = 0;
##	for(int i = 0; i < numbunnies; i++)
##	{
##	struc BunniesInfo = getbunniesinfo();
##	Bunny current = bunniesInfo.info[i];
##	x = findcurrentLoc();
##	
##	if(current.x > x)
##		setDirTo(0(absolute))
##	else
##		setDirTo(180(absolute)) 
##	setvelocityto(10)
##	do{
##      x = findcurrentLoc(x);}
##	while(x != current.x)
##	setvelocityto(0);
##	y = findcurrentLoc(y);
##	if(current.y > y)
##               setDirTo(90(absolute))
##	else
##		 setDirTo(270(absolute))
##	setvelocityto(10);
##	do{
##	y = findcurrentLoc(y)}
##	while(y != current.x)
##	setvelocityto(0);
##	catch();
##	weight+= current.weight;	
##	if(weight >= 500)
##		break;
##	}
##


.data
# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

SEARCH_BUNNIES          = 0xffff0054
CATCH_BUNNY             = 0xffff0058
PUT_BUNNIES_IN_PLAYPEN  = 0xffff005c

PLAYPEN_LOCATION        = 0xffff0044

# interrupt constants
BUNNY_MOVE_INT_MASK     = 0x400
BUNNY_MOVE_ACK          = 0xffff0020

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c

.data
.align 2
bunnies_data: .space 484
# put your data things here


.text
main:
	# put your code here :)
	la	$s0,	VELOCITY
	la	$s1,	ANGLE
	la	$s2,	ANGLE_CONTROL
	la	$s3,	BOT_X
	la	$s4,	BOT_Y
	la	$s5,	SEARCH_BUNNIES
	la	$s6,	CATCH_BUNNY 

	li	$t4, TIMER_INT_MASK		# timer interrupt enable bit
	or	$t4, $t4, BONK_INT_MASK	# bonk interrupt bit
	or  $t4, $t4, BUNNY_MOVE_INT_MASK
	or	$t4, $t4, 1		# global interrupt enable
	mtc0	$t4, $12		# set interrupt mask (Status register)


	li	$t1, 0			#t1 is buunyWeight
	li	$s7, 0			#bunny number
LOOP:
	la	$t0, bunnies_data
	sw	$t0, 0($s5)
	
	lw	$t3, 0($t0)		#t3 is num_bunnies
	add	$t0,	$t0,	4

	lw	$t8, 12($t0)	#remainning cycle

	lw	$t7, TIMER		# read current time
	add	$t7, $t7, $t8		# add 50 to current time
	sw	$t7, TIMER		# request timer interrupt in cycles

	

	

	
	
					#mul	$t4, $t2, 16
	
	lw	$t5, 0($t0)	#t5 is x
	lw	$t6, 0($s3)	#current x
	
	ble	$t6, $t5, ELSEX
	li	$t9, 	180
	move	$t8,	$t9	
	sw	$t9,    0($s1)
	li	$t9,    1
	sw	$t9,    0($s2)
	j 	AFTERELSEX

ELSEX:
	li	$t9,	0	
	move	$t8,	$t9
	sw	$t9,    0($s1)
	li	$t9,	1	
	sw	$t9,    0($s2)

AFTERELSEX:
	li	$t9,	10
	sw	$t9,	0($s0)
GOX:
	lw	$t6, 0($s3)
	lw	$t7, ANGLE
	bne $t7, $t8, CHANGE
	bne	$t6, $t5, GOX
	
	li	$t9,	0
	sw	$t9,	0($s0)

	lw	$t5, 4($t0)	#t5 is Y
	lw	$t6, 0($s4)	#current Y

	ble	$t6, $t5, ELSEY
	li	$t9,	270
	move	$t8,	$t9	
	sw	$t9,	0($s1)
	li	$t9,	1	
	sw	$t9,	0($s2)	
	j	AFTERELSEY

ELSEY:	
	li	$t9,	90
	move	$t8,	$t9
	sw	$t9,	0($s1)
	li	$t9,	1
	sw	$t9,	0($s2)

AFTERELSEY:
	li	$t9,	10
	sw	$t9,	0($s0)

GOY:
	lw	$t6, 	0($s4)
	lw	$t7, ANGLE
	bne 	$t8, $t7, CHANGE
	bne	$t6, 	$t5, GOY

	li	$t9,	0
	sw	$t9,	0($s0)

	li	$t9,	1
	sw	$t9,	0($s6)
	lw	$t7,	8($t0)
	add	$t1, $t1, $t7
	add	$s7, $s7, 1
CHANGE:
	
#	add	$t0, $t0, 16
	li	$t9,	100
	ble	$t1,	$t9,	LOOP	
	

END:
	lw	$t9,	PLAYPEN_LOCATION
	and	$t8,	$t9,	0x0000ffff	#t5 is y
	srl	$t7,	$t9,	16		#t4 is x

	move	$t5, 	$t7
	lw	$t6, 0($s3)	#current x

	
	ble	$t6, $t5, ELSEX1
	li	$t9, 	180	
	sw	$t9,    0($s1)
	li	$t9,    1
	sw	$t9,    0($s2)
	j 	AFTERELSEX1

ELSEX1:
	li	$t9,	0	
	sw	$t9,    0($s1)
	li	$t9,	1	
	sw	$t9,    0($s2)

AFTERELSEX1:
	li	$t9,	10
	sw	$t9,	0($s0)
GOX1:
	lw	$t6, 0($s3)
	bne	$t6, $t5, GOX1
	
	li	$t9,	0
	sw	$t9,	0($s0)

	move 	$t5, 	$t8
	lw	$t6, 0($s4)	#current Y

	ble	$t6, $t5, ELSEY1
	li	$t9,	270	
	sw	$t9,	0($s1)
	li	$t9,	1	
	sw	$t9,	0($s2)	
	j	AFTERELSEY1

ELSEY1:	
	li	$t9,	90
	sw	$t9,	0($s1)
	li	$t9,	1
	sw	$t9,	0($s2)

AFTERELSEY1:
	li	$t9,	10
	sw	$t9,	0($s0)

GOY1:
	lw	$t6, 	0($s4)
	bne	$t6, 	$t5, GOY1

	li	$t9,	0
	sw	$t9,	0($s0)
	sw	$s7,    PUT_BUNNIES_IN_PLAYPEN
	
	

	jr	$ra
	# note that we infinite loop to avoid stopping the simulation early

.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 8	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at                               
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers                  
	sw	$a1, 4($k0)		# by storing them to a global variable     

	mfc0	$k0, $13		# Get Cause register                       
	srl	$a0, $k0, 2                


	# fall through to done
interrupt_dispatch:			# Interrupt:                             
	mfc0	$k0, $13		# Get Cause register, again                 
	beq	$k0, 0, done		# handled all outstanding interrupts     

	and	$a0, $k0, BONK_INT_MASK	# is there a bonk interrupt?                
	bne	$a0, 0, bonk_interrupt   

	and	$a0, $k0, BUNNY_MOVE_INT_MASK	# is there a timer interrupt?
	bne	$a0, 0, bunney_move_interrupt

	and	$a0, $k0, TIMER_INT_MASK	# is there a timer interrupt?
	bne	$a0, 0, timer_interrupt



	# add dispatch for other interrupt types here.

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall 
	j	done

bunney_move_interrupt:
	sw	$a1, BUNNY_MOVE_ACK		# acknowledge interrupt




	j       interrupt_dispatch

bonk_interrupt:
    li	$a0, 90
	sw	$a0, ANGLE		# set angle to turn 70 degrees
	sw	$zero, ANGLE_CONTROL	# send the turn command
	li	$a0, 10




      sw      $a1, BONK_ACK  # acknowledge interrupt

      j       interrupt_dispatch       # see if other interrupts are waiting

timer_interrupt:
	sw	$a1, TIMER_ACK		# acknowledge interrupt
	li	$a0, 90
	sw	$a0, ANGLE		# set angle to turn 70 degrees
	sw	$zero, ANGLE_CONTROL	# send the turn command
	sw	$zero,	VELOCITY

	j	interrupt_dispatch	# see if other interrupts are waiting



done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)

.set noat
	move	$at, $k1		# Restore $at
.set at 
	eret



