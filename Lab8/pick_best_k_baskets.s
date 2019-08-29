.text

## void
## pick_best_k_baskets(int k, Baskets *baskets) {
##     if (baskets == NULL) {
##         return;
##     }
##     for (int i = 0; i < k; i++) {
##         for (int j = baskets->num_found - 1; j > i; j--) {
##             if (get_num_carrots(baskets->basket[j - 1]) <
##                 get_num_carrots(baskets->basket[j])) {
##                 // Swaps values stored at j-1 and j in place.
##                 // The address stored in basket array is 32 bits
##                 // (i.e. You do NOT need to do any casting in MIPS.)
##                 baskets->basket[j] = (Node *)((int)baskets->basket[j] ^
##                                               (int)baskets->basket[j - 1]);
##                 baskets->basket[j - 1] = (Node *)((int)baskets->basket[j] ^
##                                                   (int)baskets->basket[j - 1]);
##                 baskets->basket[j] = (Node *)((int)baskets->basket[j] ^
##                                               (int)baskets->basket[j - 1]);
##             }
##         }
##     }
## }
## 
## struct Node {
##     char seen;		1+3	0
##     int basket;		4	4
##     int dirt;		4	8
##     int id_size;		4	12
##     int *identity;		4	16
##     int num_children;	4	20
##     Node *children[4];	4	24
## };					28
## 				
## struct Baskets {
##     int num_found;		4	0
##     Node* basket[10];	4	4
## };					8

.globl pick_best_k_baskets
pick_best_k_baskets:
	# Your code goes here :)
	bne	$a1, $0, Normal
	jr	$ra
Normal:
	sub  	$sp, $sp, 20	
	li	$s0, 0			#i = 0
	move	$s1, $a0
	
FOR1:
	bge 	$s0, $a0, OUTFOR1
	lw	$t0, 0($a1)
	sub	$t0, $t0, 1		#basket->numfount - 1	
	move	$s2, $t0		#j = baket->n - 1
FOR2:	
	ble 	$s2, $s0, OUTFOR2	#s2 is j and s0 is i
	
	
	sw	$a0, 0($sp)		
	sw	$a1, 4($sp)
	sw	$v0, 8($sp)
	sw	$t0, 12($sp)
	sw	$ra, 16($sp)	

	mul	$s3, $s2, 4
	add	$s3, $a1, $s3		#s3 now point to bakset+j-1
	lw	$s4, 0($s3)		#s4 is baket[j-1]
	move	$a0, $s4
	jal	get_num_carrots
	move	$s5, $v0	

	lw	$a0, 0($sp)		
	lw	$a1, 4($sp)
	lw	$v0, 8($sp)
	lw	$t0, 12($sp)
	lw	$ra, 16($sp)

	
	sw	$a0, 0($sp)		
	sw	$a1, 4($sp)
	sw	$v0, 8($sp)
	sw	$t0, 12($sp)
	sw	$ra, 16($sp)	

	
	
	add	$s6, $s3, 4		#s6 point to basket[j]
	lw	$s7, 0($s6)		#s7 is baket[j]
	move	$a0, $s7

	


	jal	get_num_carrots
	move	$t1, $v0

	lw	$a0, 0($sp)		
	lw	$a1, 4($sp)
	lw	$v0, 8($sp)
	lw	$t0, 12($sp)
	lw	$ra, 16($sp)
	
	lw	$s4, 0($s3)		#s4 is baket[j-1]
	lw	$s7, 0($s6)		#s7 is baket[j]
	bge	$s5, $t1, OUTIF
	xor	$s7, $s7, $s4
	sw	$s7, 0($s6)
	xor	$s4, $s4, $s7
	sw	$s4, 0($s3)
	xor	$s7, $s7, $s4
	sw	$s7, 0($s6) 	

OUTIF:
	sub	$s2, $s2, 1		#j--
	j	FOR2	

OUTFOR2:
	add	$s0, $s0, 1		#i++
	j	FOR1	

OUTFOR1:	
	add  	$sp, $sp, 20	
	jr	$ra
