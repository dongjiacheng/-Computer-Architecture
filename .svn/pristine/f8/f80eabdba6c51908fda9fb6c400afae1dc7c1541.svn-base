.text

## int
## max_conts_bits_in_common(int a, int b) {
##     int bits_seen = 0;
##     int max_seen = 0;
##     int c = a & b;
##     for (int i = 0; i < INT_SIZE; i++) {
##         int bit = (c >> i) & 1;
##         if (bit) {
##             bits_seen++;
##         } else {
##             if (bits_seen > max_seen) {
##                 max_seen = bits_seen;
##             }
##             bits_seen = 0;
##         }
##     }
##     if (bits_seen > max_seen) {
##         max_seen = bits_seen;
##     }
##     return max_seen;
## }

.globl max_conts_bits_in_common
max_conts_bits_in_common:
	li	$t0, 0		#bits_seen = 0
	li	$t1, 0		#max_seen = 0
	and	$t2, $a0, $a1	#c = a & b
	li	$t3, 0		#int i = 0
	li	$t4, 32		#INT_SIZE is 32
FORLOOP:
	bge	$t3, $t4, OUTFOR
	andi	$t5, $t2, 1	#c & 1
	srl	$t2, $t2, 1	#c >> 1
	beq	$t5, 0, ISZERO	#if(bit)
	addi	$t0, $t0, 1	#bits_seen++
	j	NORMAL
ISZERO:
	ble	$t0, $t1, GREATER #if(bit > max)
	move	$t1, $t0	#max = bits
GREATER:
	li	$t0, 0		#bits_seen = 0	

NORMAL:	
	addi	$t3, $t3, 1	#i++
	j	FORLOOP
	# Your code goes here :)
OUTFOR:
	ble	$t0, $t1, FINAL
	move	$t1, $t0	
FINAL:
	move	$v0, $t1
	jr	$ra
