.text

## int
## accumulate(int total, int value) {
##     if (max_conts_bits_in_common(total, value) >= 2) {
##         total = total | value;
##     } else if (detect_parity(value) == 0) {
##         total = total + value;
##     } else {
##         total = total * value;
##     }
##     return total;
## }

.globl accumulate
accumulate:
	# Your code goes here :)
	move	$v0, $a0
	sub	$sp, $sp, 16	#find stack
	sw	$ra, 0($sp)
	sw	$v0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a0, 12($sp)	

	jal	max_conts_bits_in_common
	lw	$a1, 8($sp)
	lw	$ra, 0($sp)
	blt	$v0, 2, ELSEIF	#result>=2
	
	lw	$v0, 4($sp)
	
	or	$v0, $v0, $a1
	j	NORMAL	

ELSEIF:	
	move	$a0, $a1
	jal	detect_parity
	lw	$a0, 4($sp)
	bne	$v0, 0, ELSE
	lw	$v0, 4($sp)
	add	$v0, $v0, $a1
	j	NORMAL

ELSE:	
	lw	$v0, 4($sp)
	mul	$v0, $v0, $a1
NORMAL:
	lw	$ra, 0($sp)
	lw	$a1, 8($sp)
	lw	$a0, 12($sp)
	add	$sp, $sp, 16
	jr	$ra
