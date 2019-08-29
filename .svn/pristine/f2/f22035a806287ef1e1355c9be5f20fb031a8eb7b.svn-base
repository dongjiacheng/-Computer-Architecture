.text

## int turns[4] = {1, 0, -1, 0}; // Declared as a global in calculate_identity_main.s
## int
## calculate_identity(int *v, int size) {
##     int dist = size;
##     int total = 0;
##     int idx = -1;
##     turns[1] = size;
##     turns[3] = -size;
##     while (dist > 0) {
##         for (int i = 0; i < 4; i++) {
##             for (int j = 0; j < dist; j++) {
##                 idx = idx + turns[i];
##                 total = accumulate(total, v[idx]);
##                 v[idx] = total;
##             }
##             if (i % 2 == 0) {
##                 dist--;
##             }
##         }
##     }
##     return twisted_sum_array(v, size * size);
## }

.globl calculate_identity
calculate_identity:
	# Your code goes here :)
	sub	$sp, $sp, 52	#caller safe
	move	$t0, $a1		#dist = size
	li	$t1, 0			#total = 0
	li	$t2, -1			#idx = -1
	
	la	$t9, turns	#load address

	sw	$a1, 4($t9)	#turns[1] = size
	sub 	$t3, $0, $a1		#-size
	sw	$t3, 12($t9)	#turns[3] = -size
WHILE:
	ble	$t0, 0, OUTWHILE
	li	$t4, 0			#int i = 0
FOR1:
	bge $t4, 4, FIRSTFOR
	li	$t5, 0 			#int j = 0
FOR2:
	bge	$t5, $t0, SECONDFOR
	mul $t6, $t4, 4		#address of turn i
	add $t6, $t6, $t9	#address of turn i
	lw	$t6, 0($t6)		#turns[i]
	add $t2, $t6, $t2	#idx = idx + turns[i]
	mul	$t7, $t2, 4		
	add $t7, $t7, $a0
	lw	$t8, 0($t7)		#v[idx]

	
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw 	$t0, 8($sp)
	sw 	$t1, 12($sp)
	sw 	$t2, 16($sp)
	sw 	$t3, 20($sp)
	sw 	$t4, 24($sp)
	sw 	$t5, 28($sp)
	sw	$t6, 32($sp)
	sw	$t7, 36($sp)
	sw	$t8, 40($sp)
	sw	$ra, 44($sp)
	sw	$t9, 48($sp)

	move	$a0, $t1
	move	$a1, $t8
	jal accumulate

	move	$t1, $v0		#total = accumulate
	lw	$a0, 0($sp)		#store back
	lw	$a1, 4($sp)
	lw 	$t0, 8($sp)
##lw 	$t1, 12($sp)
	lw 	$t2, 16($sp)
	lw 	$t3, 20($sp)
	lw 	$t4, 24($sp)
	lw 	$t5, 28($sp)
	lw	$t6, 32($sp)
	lw	$t7, 36($sp)
	lw	$t8, 40($sp)
	lw	$ra, 44($sp)
	lw	$t9, 48($sp)

	sw	$t1, 0($t7)		#v[idx] = total
	add 	$t5, $t5, 1		#j++
	j  FOR2

SECONDFOR:
	and	$t5,$t4,1		#if (i % 2 == 0)
	bne	$t5,0,	B
	sub	$t0,$t0,1		#dist--;
B:
	add $t4, $t4, 1		#i++
	j 	FOR1

FIRSTFOR:
	j 	WHILE

OUTWHILE:
	mul	$t4, $a1, $a1		#t4 is size*size
	move $a1, $t4 			# size*size is new a1
	jal twisted_sum_array
	lw	$ra, 44($sp)		#retrive PC
	add $sp, $sp, 52		#pop stack
	jr	$ra
