.text

## void
## collect_baskets(int max_baskets, Node *spot, Baskets *baskets) {
##     if (spot == NULL || baskets == NULL || spot->seen == 1) {
##         return;
##     }
##     spot->seen = 1;
##     for (int i = 0; i < spot->num_children && baskets->num_found < max_baskets;
##          i++) {
##         collect_baskets(max_baskets, spot->children[i], baskets);
##     }
##     if (baskets->num_found < max_baskets && get_num_carrots(spot) > 0) {
##         baskets->basket[baskets->num_found] = spot;
##         baskets->num_found++;
##     }
##     return;
## }
## 
## struct Node {
##     char seen;		0
##     int basket;		4
##     int dirt;		8
##     int id_size;		12
##     int *identity;	16
##     int num_children; 20
##     Node *children[4]; 24
## };
## 
## struct Baskets {
##     int num_found; 0 
##     Node *basket[10]; 4
## };

.globl collect_baskets
collect_baskets:
	# Your code goes here :)
	
	beq	$a1, $0, OUT
	beq	$a2, $0, OUT
	lw	$t0, 0($a1)
	beq $t0, 1, OUT

	sub	$sp, $sp, 24	#need to add
	
	sw	$s0, 16($sp)	#need to restore
	sw	$s1, 20($sp)


	li	$t0, 1
	sw	$t0, 0($a1)	#spot->seen = 1
	li	$s0, 0		#int i = 0

FOR:
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a2, 12($sp)

	lw	$t0, 20($a1)
	lw	$t1, 0($a2)
	bge	$s0, $t0, OUTFOR
	bge	$t1, $a0, OUTFOR

	mul	$s0, $s0, 4
	add $t0, $a1, $s0
	lw	$a1, 24($t0)

	jal	collect_baskets

	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$a2, 12($sp)

	add	$s0, $s0, 1
	j 	FOR

OUTFOR:
	lw	$s1, 0($a2)
	bge	$s1, $a0, OUTIF
	
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	
	move $a0, $a1
	jal get_num_carrots
	lw	$a0, 4($sp)
	lw	$ra, 0($sp)
	ble	$v0, 0, OUTIF

	mul	$t1, $s1, 4
	add	$t2, $a2, 4
	add	$t2, $t1, $t2
	sw	$a1, 0($t2)
	lw	$t2, 0($a2)
	add	$t2, $t2, 1
	sw	$t2, 0($a2)

OUTIF:
	lw	$s0, 16($sp)	#need to restore
	lw	$s1, 20($sp)
	add	$sp, $sp, 24

OUT:
	jr  $ra
