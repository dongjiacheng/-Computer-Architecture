# before running your code for the first time, run:
#     module load QtSpim
# run with:
#     QtSpim -file main.s question_4.s

# int replace_matches(char *array, int length, char from, char to) {
#     int matches = 0;
#     for (int i = 0; i < length; i++) {
#         if (array[i] == from) {
#             array[i] = to;
#             matches++;
#         }
#     }
#     return matches;
# }
.globl replace_matches
replace_matches:
	li	$t0,	0
	
	li	$t1,	0	#i is $t1
LOOP:
	bge	$t1,	$a1, END
	mul	$t2,	$t1, 1	
	add	$t2,	$a0, $t2
	lbu	$t3,	0($t2)
	bne	$t3,	$a2,	OUTIF
	sb	$a3,	0($t2)
	add	$t0,	$t0, 1
OUTIF:
	add	$t1,	$t1, 1
	j	LOOP



END:
	move	$v0,	$t0
	jr	$ra
