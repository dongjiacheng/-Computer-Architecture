.text

## int
## search_carrot(int max_baskets $a0, int k $a1 , Node *root $a2, Baskets *baskets $a3 ) {
##     if (root == NULL || baskets == NULL) {
##         return 0;
##     }
##     baskets->num_found = 0;
##     for (int i = 0; i < max_baskets; i++) {
##         baskets->basket[i] = NULL;
##     }
##     collect_baskets(max_baskets, root, baskets);
##     pick_best_k_baskets(k, baskets);
##     return get_secret_id(k, baskets);
## }
## 
## struct Node {
##     char seen;			0
##     int basket;			4	
##     int dirt;			8
##     int id_size;			12
##     int *identity;		16
##     int num_children;	20
##     Node *children[4];	24
## };
## 
## struct Baskets {
##     int num_found;		0
##     Node *basket[10];	4
## };

.globl search_carrot
search_carrot:
	li	$v0, 0
	beq	$a2, $0, OUT
	beq	$a3, $0, OUT


	sub	$sp, $sp, 20
	

	# Your code goes here :)
	li	$t0, 0
	sw	$t0, 0($a3) 

	li	$t3, 0		# i = 0
FOR:
	bge	$t3, $a0, OUTFOR
	mul	$t0, $t3, 4
	add	$t0, $t0, $a3
	sw	$0,	4($t0)
	add	$t3, $t3, 1
	j 	FOR

OUTFOR:
	#call collect basket
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$a3, 12($sp)
	sw	$ra, 16($sp)

	move	$a1, $a2
	move	$a2, $a3	
	jal	collect_baskets

	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)
	lw	$ra, 16($sp)

	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$a3, 12($sp)
	sw	$ra, 16($sp)

	move	$a0, $a1
	move	$a1, $a3
	jal pick_best_k_baskets

	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)
	lw	$ra, 16($sp)

	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$a3, 12($sp)
	sw	$ra, 16($sp)

	move	$a0, $a1
	move	$a1, $a3
	jal get_secret_id

	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)
	lw	$ra, 16($sp)

	add	$sp, $sp, 20

OUT:
	jr  $ra
