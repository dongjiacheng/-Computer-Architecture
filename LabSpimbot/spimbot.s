# syscall constants
PRINT_STRING = 4
PRINT_CHAR   = 11
PRINT_INT    = 1

# debug constants
PRINT_INT_ADDR   = 0xffff0080
PRINT_FLOAT_ADDR = 0xffff0084
PRINT_HEX_ADDR   = 0xffff0088

# spimbot constants
VELOCITY       = 0xffff0010
ANGLE          = 0xffff0014
ANGLE_CONTROL  = 0xffff0018
BOT_X          = 0xffff0020
BOT_Y          = 0xffff0024
OTHER_BOT_X    = 0xffff00a0
OTHER_BOT_Y    = 0xffff00a4
TIMER          = 0xffff001c
SCORES_REQUEST = 0xffff1018

# introduced in lab10
SEARCH_BUNNIES          = 0xffff0054
CATCH_BUNNY             = 0xffff0058
PUT_BUNNIES_IN_PLAYPEN  = 0xffff005c
PLAYPEN_LOCATION        = 0xffff0044

# introduced in labSpimbot
LOCK_PLAYPEN            = 0xffff0048
UNLOCK_PLAYPEN          = 0xffff004c
REQUEST_PUZZLE          = 0xffff00d0
SUBMIT_SOLUTION         = 0xffff00d4
NUM_BUNNIES_CARRIED     = 0xffff0050
NUM_CARROTS             = 0xffff0040
PLAYPEN_OTHER_LOCATION  = 0xffff00dc

# interrupt constants
BONK_MASK               = 0x1000
BONK_ACK                = 0xffff0060
TIMER_MASK              = 0x8000
TIMER_ACK               = 0xffff006c
BUNNY_MOVE_INT_MASK     = 0x400
BUNNY_MOVE_ACK          = 0xffff0020
PLAYPEN_UNLOCK_INT_MASK = 0x2000
PLAYPEN_UNLOCK_ACK      = 0xffff005c
EX_CARRY_LIMIT_INT_MASK = 0x4000
EX_CARRY_LIMIT_ACK      = 0xffff002c
REQUEST_PUZZLE_INT_MASK = 0x800
REQUEST_PUZZLE_ACK      = 0xffff00d8

.data
.align 2
puzzle_data: .space 9804# data things go here
basket_data: .space 44
puzzle_solution: 4

.text
main:
li  $t4, TIMER_MASK
or	$t4, $t4, REQUEST_PUZZLE_INT_MASK		# puzzle interrupt enable bit
or	$t4, $t4, 1		# global interrupt enable
mtc0	$t4, $12		# set interrupt mask (Status register)
    # go wild
    # the world is your oyster :)
j   main



.globl pick_best_k_baskets
pick_best_k_baskets:
	bne	$a1, 0, pbkb_do
	jr	$ra

pbkb_do:
	sub	$sp, $sp, 32
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)

	move	$s0, $a0			# $s0 = int k
	move	$s1, $a1			# $s1 = Baskets *baskets

	li	$s2, 0				# $s2 = int i = 0
pbkb_for_i:
	bge	$s2, $s0, pbkb_done		# if (i >= k), done

	lw	$s3, 0($s1)
	sub	$s3, $s3, 1			# $s3 = int j = baskets->num_found - 1
pbkb_for_j:
	ble	$s3, $s2, pbkb_for_j_done	# if (j <= i), done

	sub	$s5, $s3, 1
	mul	$s5, $s5, 4
	add	$s5, $s5, $s1
	lw	$a0, 4($s5)			# baskets->basket[j-1]
	jal	get_num_carrots			# get_num_carrots(baskets->basket[j-1])
	move	$s4, $v0

	mul	$s6, $s3, 4
	add	$s6, $s6, $s1
	lw	$a0, 4($s6)			# baskets->basket[j]
	jal	get_num_carrots			# get_num_carrots(baskets->basket[j])

	bge	$s4, $v0, pbkb_for_j_cont	# if (get_num_carrots(baskets->basket[j-1]) >= get_num_carrots(baskets->basket[j])), skip

	## This is very inefficient in MIPS. Can you think of a better way?

	## We're changing the _values_ of the array elements, so we don't need to
	## recompute addresses every time, and can reuse them from earlier.

	lw	$t0, 4($s6)			# baskets->basket[j]
	lw	$t1, 4($s5)			# baskets->basket[j-1]
	xor	$t2, $t0, $t1			# baskets->basket[j] ^ baskets->basket[j-1]
	sw	$t2, 4($s6)			# baskets->basket[j] = baskets->basket[j] ^ baskets->basket[j-1]

	lw	$t0, 4($s6)			# baskets->basket[j]
	lw	$t1, 4($s5)			# baskets->basket[j-1]
	xor	$t2, $t0, $t1			# baskets->basket[j] ^ baskets->basket[j-1]
	sw	$t2, 4($s5)			# baskets->basket[j-1] = baskets->basket[j] ^ baskets->basket[j-1]

	lw	$t0, 4($s6)			# baskets->basket[j]
	lw	$t1, 4($s5)			# baskets->basket[j-1]
	xor	$t2, $t0, $t1			# baskets->basket[j] ^ baskets->basket[j-1]
	sw	$t2, 4($s6)			# baskets->basket[j] = baskets->basket[j] ^ baskets->basket[j-1]

pbkb_for_j_cont:
	sub	$s3, $s3, 1			# j--
	j	pbkb_for_j

pbkb_for_j_done:
	add	$s2, $s2, 1			# i++
	j	pbkb_for_i

pbkb_done:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	add	$sp, $sp, 32
	jr	$ra


.globl search_carrot
search_carrot:
	move	$v0, $0			# set return value to 0 early
	beq	$a2, 0, sc_ret		# if (root == NULL), return 0
	beq	$a3, 0, sc_ret		# if (baskets == NULL), return 0

	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)

	move	$s0, $a1		# $s0 = int k
	move	$s1, $a3		# $s1 = Baskets *baskets

	sw	$0, 0($a3)		# baskets->num_found = 0

	move	$t0, $0			# $t0 = int i = 0
sc_for:
	bge	$t0, $a0, sc_done	# if (i >= max_baskets), done

	mul	$t1, $t0, 4
	add	$t1, $t1, $a3
	sw	$t0, 4($t1)		# baskets->basket[i] = NULL

	add	$t0, $t0, 1		# i++
	j	sc_for


sc_done:
	move	$a1, $a2
	move	$a2, $a3
	jal	collect_baskets		# collect_baskets(max_baskets, root, baskets)

	move	$a0, $s0
	move	$a1, $s1
	jal	pick_best_k_baskets	# pick_best_k_baskets(k, baskets)

	move	$a0, $s0
	move	$a1, $s1

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12

	j	get_secret_id		# get_secret_id(k, baskets), tail call

sc_ret:
	jr	$ra


.globl collect_baskets
collect_baskets:
	beq	$a1, 0, cb_ret		# if (spot == NULL), return
	beq	$a2, 0, cb_ret		# if (baskets == NULL), return
	lb	$t0, 0($a1)
	beq	$t0, 1, cb_ret		# if (spot->seen == 1), return

	li	$t0, 1
	sb	$t0, 0($a1)		# spot->seen = 1

	sub	$sp, $sp, 20
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)

	move	$s0, $a0		# $s0 = int max_baskets
	move	$s1, $a1		# $s1 = Node *spot
	move	$s2, $a2		# $s2 = Baskets *baskets

	move	$s3, $0			# $s3 = int i = 0
cb_for:
	lw	$t0, 20($s1)		# spot->num_children
	bge	$s3, $t0, cb_done	# if (i >= spot->num_children), done
	lw	$t0, 0($s2)		# baskets->num_found
	bge	$t0, $s0, cb_done	# if (baskets->num_found >= max_baskets), done

	move	$a0, $s0
	mul	$a1, $s3, 4
	add	$a1, $a1, $s1
	lw	$a1, 24($a1)		# spot->children[i]
	move	$a2, $s2
	jal	collect_baskets		# collect_baskets(max_baskets, spot->children[i], baskets)

	add	$s3, $s3, 1		# i++
	j	cb_for


cb_done:
	lw	$t0, 0($s2)		# baskets->num_found
	bge	$t0, $s0, cb_return	# if (baskets->num_found >= max_baskets), return

	move	$a0, $s1
	jal	get_num_carrots
	ble	$v0, 0, cb_return 	# if (get_num_carrots(spot) <= 0), return

	lw	$t0, 0($s2)		# baskets->num_found
	mul	$t1, $t0, 4
	add	$t1, $t1, $s2
	sw	$s1, 4($t1)		# baskets->basket[baskets->num_found] = spot

	add	$t0, $t0, 1
	sw	$t0, 0($s2)		# baskets->num_found++

cb_return:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	add	$sp, $sp, 20

cb_ret:
	jr	$ra


.globl get_num_carrots
get_num_carrots:
	bne	$a0, 0, gnc_do		# if (spot != NULL), continue
	move	$v0, $0			# return 0
	jr	$ra

gnc_do:
	lw	$t0, 8($a0)		# spot->dirt
	xor	$t0, $t0, 0x00ff00ff	# $t0 = unsigned int dig = spot->dirt ^ 0x00ff00ff

	and	$t1, $t0, 0xffffff 	# dig & 0xffffff
	sll	$t1, $t1, 8		# (dig & 0xffffff) << 8

	and	$t2, $t0, 0xff000000 	# dig & 0xff00aadi0000
	srl	$t2, $t2, 24		# (dig & 0xff000000) >> 24

	or	$t0, $t1, $t2		# dig = ((dig & 0xffffff) << 8) | ((dig & 0xff000000) >> 24)

	lw	$v0, 4($a0)		# spot->basket
	xor	$v0, $v0, $t0		# return spot->basket ^ dig
	jr	$ra


.globl get_secret_id
get_secret_id:
	bne	$a1, 0, gsi_do		# if (baskets != NULL), continue
	move	$v0, $0			# return 0
	jr	$ra

gsi_do:
	sub	$sp, $sp, 20
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)

	move	$s0, $a0		# $s0 = int k
	move	$s1, $a1		# $s1 = Baskets *baskets
	move	$s2, $0			# $s2 = int secret_id = 0

	move	$s3, $0			# $s3 = int i = 0
gsi_for:
	bge	$s3, $s0, gsi_return	# if (i >= k), done

	mul	$t0, $s3, 4
	add	$t0, $t0, $s1
	lw	$t0, 4($t0)		# baskets->basket[i]

	lw	$a0, 16($t0)		# baskets->basket[i]->identity
	lw	$a1, 12($t0)		# baskets->basket[i]->id_size
	jal	calculate_identity	# calculate_identity(baskets->basket[i]->identity, baskets->basket[i]->id_size)

	addu	$s2, $s2, $v0		# secret_it += ...

	add	$s3, $s3, 1		# i++
	j	gsi_for

gsi_return:
	move	$v0, $s2		# return secret_id

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	add	$sp, $sp, 20
	jr	$ra

.globl PUZZLE_SOLVER
PUZZLE_SOLVER:
la  $t0, puzzle_data
sw  $t0, REQUEST_PUZZLE







.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 16	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at                               
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers                  
	sw	$a1, 4($k0)		# by storing them to a global variable     

	sw	$a2, 8($k0)
	sw  $a3, 12($k0)

	mfc0	$k0, $13		# Get Cause register                       
	srl	$a0, $k0, 2                

interrupt_dispatch:			# Interrupt:                             
	mfc0	$k0, $13		# Get Cause register, again                 
	beq	$k0, 0, done		# handled all outstanding interrupts     

	and	$a0, $k0, REQUEST_PUZZLE_INT_MASK	# is there a puzzle interrupt?                
	bne	$a0, 0, puzzle_interrupt   

puzzle_interrupt:
	li $a0, 10
	la $a2, puzzle_data
    lw $a1, 9803($a2) 
    sw 0, basket_data
    la $a3, basket_data

    jal search_carrot

    sw $v0, puzzle_solution
    lw $a0, puzzle_solution
    sw $a0, SUBMIT_SOLUTION

done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
	lw	$a2, 8($k0)
	lw  $a3, 12($k0)

.set noat
	move	$at, $k1		# Restore $at
.set at 
	eret


