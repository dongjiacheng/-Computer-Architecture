.text

## int
## twisted_sum_array(int *v, int length) {
##     int sum = 0;
##     for (int i = 0; i < length; i++) {
##         if (v[length - 1 - i] & 1) {
##             sum >>= 1;
##         }
##         sum += v[i];
##     }
##     return sum;
## }

.globl twisted_sum_array
twisted_sum_array:
	li	$t0, 0		#sum = 0
	li	$t1, 0		#int i = 0
	
FORLOOP:
	bge	$t1, $a1, OUT	#i<length
	sub	$t2, $a1, 1	#length - 1
	sub	$t2, $t2, $t1	#length - 1 - i
	
	mul	$t2, $t2, 4
	add	$t2, $a0, $t2
	lw	$t3, 0($t2)	#v[]
	andi	$t3, $t3, 1	#v[]&1
	beq	$t3, 0, ZERO	#if
	sra	$t0, $t0, 1	#sum >>= 1;
ZERO:
	mul	$t4, $t1, 4  	#i*4
	add	$t4, $a0, $t4
	lw	$t5, 0($t4)	#v[i]
	add	$t0, $t0, $t5	#sum += v[i]
	add	$t1, $t1, 1
	j	FORLOOP
OUT:
	move	$v0, $t0
	# Your code goes here :)
	jr	$ra
