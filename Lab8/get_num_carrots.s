.text

## struct Node {
##     char seen;            1+3
##     int basket;	     4
##     int dirt;	     4
##     int id_size;          4
##     int *identity;        4
##     int num_children;     4
##     Node *children[4];    4
## };
##
## int
## get_num_carrots(Node *spot) {
##     if (spot == NULL) {
##         return 0;
##     }
##     // Inverts the first and third byte.
##     unsigned int dig = spot->dirt ^ 0x00ff00ff;
##     // Circular shifts the bytes left one.
##     dig = ((dig & 0xffffff) << 8) | ((dig & 0xff000000) >> 24);
##     return spot->basket ^ dig;
## }

.globl get_num_carrots
get_num_carrots:
	# Your code goes here :)
	
	
	bne  $a0, $0, Normal		#if spot == NULL
	li   $v0, 0
	
	jr   $ra

	Normal:
	
	lw   $t1, 8($a0)
	xor  $t2, $t1, 0x00ff00ff	#dig = spot->dirt ^ 0x00ff00ff
        and  $t3, $t2, 0xffffff
        sll  $t3, $t3, 8
	and  $t4, $t2, 0xff000000
	srl  $t4, $t4, 24
	or   $t2, $t3, $t4
	lw   $t3, 4($a0)
	xor  $v0, $t2, $t3

	
	jr   $ra
