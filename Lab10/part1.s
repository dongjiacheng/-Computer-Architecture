

##int main(){
##	struc BunniesInfo = getbunniesinfo();
##	int weightcatch = 0;
##	for(int i = 0; i < numbunnies; i++)
##	{
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

	li	$t1, 0			#t1 is buunyWeight

LOOP:
	la	$t0, bunnies_data
	sw	$t0, 0($s5)
	
	lw	$t3, 0($t0)		#t3 is num_bunnies
	add	$t0,	$t0,	4

	
	

	li	$t2, 0	#i is 0

	bge	$t2, $t3, END
	
					#mul	$t4, $t2, 16
	
	lw	$t5, 0($t0)	#t5 is x
	lw	$t6, 0($s3)	#current x
	
	ble	$t6, $t5, ELSEX
	li	$t9, 	180	
	sw	$t9,    0($s1)
	li	$t9,    1
	sw	$t9,    0($s2)
	j 	AFTERELSEX

ELSEX:
	li	$t9,	0	
	sw	$t9,    0($s1)
	li	$t9,	1	
	sw	$t9,    0($s2)

AFTERELSEX:
	li	$t9,	10
	sw	$t9,	0($s0)
GOX:
	lw	$t6, 0($s3)
	bne	$t6, $t5, GOX
	
	li	$t9,	0
	sw	$t9,	0($s0)

	lw	$t5, 4($t0)	#t5 is Y
	lw	$t6, 0($s4)	#current Y

	ble	$t6, $t5, ELSEY
	li	$t9,	270	
	sw	$t9,	0($s1)
	li	$t9,	1	
	sw	$t9,	0($s2)	
	j	AFTERELSEY

ELSEY:	
	li	$t9,	90
	sw	$t9,	0($s1)
	li	$t9,	1
	sw	$t9,	0($s2)

AFTERELSEY:
	li	$t9,	10
	sw	$t9,	0($s0)

GOY:
	lw	$t6, 	0($s4)
	bne	$t6, 	$t5, GOY

	li	$t9,	0
	sw	$t9,	0($s0)

	li	$t9,	1
	sw	$t9,	0($s6)
	lw	$t7,	8($t0)
	add	$t1, $t1, $t7
	add	$t2, $t2, 1	
#	add	$t0, $t0, 16
	li	$t9,	500
	ble	$t1,	$t9,	LOOP	
	

END:
	jr	$ra

	# note that we infinite loop to avoid stopping the simulation early
	
