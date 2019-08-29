.text

## int
## detect_parity(int number) {
##     int bits_counted = 0;
##     int return_value = 1;
##     for (int i = 0; i < 32; i++) {
##         int bit = (number >> i) & 1;
##         // zero is false, anything else is true
##         if (bit) { 
##             bits_counted++;
##         }
##     }
##     if (bits_counted % 2 != 0) {
##         return_value = 0;
##     }
##     return return_value;
## }

.globl detect_parity
detect_parity:
	# Your code goes here :)
	li	$t0,0		#store 0 to bits_counted	
	li	$t1,1		#store 1 to return value
	li	$t3,32		#store	32 
	li	$t4,0		#store int i = 0
	move	$t5,$a0		#store numver to t5

	
FORLOOP:
	#implement for loop
	bge	$t4,$t3,GETOUT	#whether i is equal 32 
	
	and	$t6,$t5,1	# &1
	srl	$t5,$t5,1	#shift right 1
	beq	$t6,0,ISZERO	# whether it is zero
	add	$t0,$t0,1	#bits_counted++
ISZERO: 
	add	$t4,$t4,1
	j	FORLOOP

GETOUT:
	and	$t4,$t0,1
	beq	$t4,$0,	B
	li	$t1,0
B:
	move	$v0,$t1
	jr	$ra
	
