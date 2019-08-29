# before running your code for the first time, run:
#     module load QtSpim
# run with:
#     QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *children[4];
#     int *data;
# };
# 
# void quad_accumulate_down(node_t *root, int value) {
#     if (root == NULL) {
#         return;
#     }
# 
#     value += *(root->data);
#     *(root->data) = value;
# 
#     for (int i = 0; i < 4; i++) {
#         quad_accumulate_down(root->children[i], value);
#     }
# }
.globl quad_accumulate_down
quad_accumulate_down:
sub $sp, $sp, 16
beq $a0, $0 end
lw $t1, 16($a0)
lw $t2, 0($t1)
add $a1, $t2, $a1
sw $a1, 0($t1)

li $t2, 0
forloop:
bge $t2, 4, end
mul $t3, $t2, 4
add $t3, $t3, $a0

sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $t2, 12($sp) 

lw $a0, 0($t3)
jal quad_accumulate_down

lw $ra, 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $t2, 12($sp) 


add $t2, $t2, 1
j forloop

end:
add $sp, $sp, 16
jr $ra
