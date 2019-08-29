// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
// add sub and or nor xor addi andi ori xori

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;
    
    wire inst_add = (opcode == `OP_OTHER0) && (funct == `OP0_ADD);
    wire inst_sub = (opcode == `OP_OTHER0) && (funct == `OP0_SUB);
    wire inst_and = (opcode == `OP_OTHER0) && (funct == `OP0_AND);
    wire inst_or = (opcode == `OP_OTHER0) && (funct == `OP0_OR);
    wire inst_nor = (opcode == `OP_OTHER0) && (funct == `OP0_NOR);
    wire inst_xor = (opcode == `OP_OTHER0) && (funct == `OP0_XOR);
    
    wire inst_addi = opcode == `OP_ADDI;
    wire inst_andi = opcode == `OP_ANDI;
    wire inst_ori = opcode == `OP_ORI;
    wire inst_xori = opcode == `OP_XORI;

    assign writeenable = inst_add | inst_addi |  inst_sub | inst_and | inst_or | inst_xor | inst_ori | inst_andi | inst_xori | inst_nor;
    assign except = ~(inst_add | inst_addi |  inst_sub | inst_and | inst_or | inst_xor | inst_ori | inst_andi | inst_xori | inst_nor);
    
    or oA1(alu_op[0],inst_sub,inst_or,inst_xor,inst_ori,inst_xori);
    or oA2(alu_op[1],inst_add,inst_sub,inst_nor,inst_xor,inst_addi,inst_xori);
    or oA3(alu_op[2],inst_and,inst_or,inst_nor,inst_xor,inst_andi,inst_ori,inst_xori);
    
    assign rd_src = ~(opcode == `OP_OTHER0);
    assign alu_src2 = ~(opcode == `OP_OTHER0);
    

endmodule // mips_decode