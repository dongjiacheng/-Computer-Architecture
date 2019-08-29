.text

## int
## get_secret_id(int k, Baskets *baskets) {
##     if (baskets == NULL) {
##         return 0;
##     }
##     int secret_id = 0;
##     for (int i = 0; i < k; i++) {
##         secret_id += calculate_identity(baskets->basket[i]->identity,
##                                         baskets->basket[i]->id_size);
##     }
##     return secret_id;
## }
## 
## struct Node {
##     char seen;	0
##     int basket;	4
##     int dirt;	8
##     int id_size;	12
##     int *identity;	16
##     int num_children;	20
##     Node *children[4];	24
## };
## 
## struct Baskets {
##     int num_found;
##     Node *basket[10];
## };

.globl get_secret_id
get_secret_id:
	# Your code goes here :)
	sub	$sp, $sp, 8 
	sw  $s0, 0($sp)
	sw 	$s1, 4($sp)
	
	



	
	li	$v0, 0
	beq	$a0, $0, OUT;
	li	$s0, 0			#secret_id = 0
	li	$s1, 0			#int i = 0
	sub	$sp, $sp, 12 

FOR:
	bge $s1, $a0, OUTFOR
	
	
	sw  $a0, 0($sp)
	sw 	$a1, 4($sp)
	sw	$ra, 8($sp)

	mul	$t0, $s1, 4
	add	$t0, $t0, $a1
	lw	$t1, 4($t0)		#basktets->basketp[i]
	lw	$a0, 16($t1)
	lw	$a1, 12($t1)
	jal	calculate_identity

	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$ra, 8($sp)

	add	$s0, $s0, $v0
	add	$s1, $s1, 1
	j 	FOR

	
OUTFOR:
	add	$sp, $sp, 12

	move	$v0, $s0

	
	lw  $s0, 0($sp)
	lw 	$s1, 4($sp)
	add	$sp, $sp, 8 

OUT:	
	jr  $ra
