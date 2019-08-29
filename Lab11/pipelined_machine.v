module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4_IF,PC_plus4_DE, PC_target;
    wire [31:0]  inst_IF,inst_DE;

    wire [31:0]  imm = {{ 16{inst_DE[15]} }, inst_DE[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst_DE[25:21];
    wire [4:0]   rt = inst_DE[20:16];
    wire [4:0]   rd = inst_DE[15:11];
    wire [5:0]   opcode_DE = inst_DE[31:26];
    wire [5:0]   funct_DE = inst_DE[5:0];

    wire [4:0]   wr_regnum_DE,wr_regnum_MW;
    wire [2:0]   ALUOp;

    wire         RegWrite_DE,RegWrite_MW, BEQ, ALUSrc, MemRead_DE,MemRead_MW, MemWrite_DE,MemWrite_MW, MemToReg_DE,MemToReg_MW, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data_DE, alu_out_data_MW, load_data, wr_data,select_data_DE,select_data_MW, rdSelect_data;

    wire  enable_flush, forwardA, forwardB, stall;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~stall , reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4_IF, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_DE, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4_IF, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_IF, PC[31:2]);

    mips_decode decode(ALUOp, RegWrite_DE, BEQ, ALUSrc, MemRead_DE, MemWrite_DE, MemToReg_DE, RegDst,
                      opcode_DE, funct_DE);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_MW, clk, reset);

    mux2v #(32) imm_mux(B_data, select_data_DE, imm, ALUSrc);
    alu32 alu(alu_out_data_DE, zero, ALUOp, rdSelect_data, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_MW, select_data_MW, MemRead_MW, MemWrite_MW, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data_MW, load_data, MemToReg_MW);
    mux2v #(5) rd_mux(wr_regnum_DE, rt, rd, RegDst);

    register #(30) PC_plus4_PIPE(PC_plus4_DE, PC_plus4_IF, clk, ~stall, enable_flush);
   
    //register #(5)  rs_PIPE(rs_right, rs_left, clk, 1'b1, enable_flush);
    //register #(5)  rd_PIPE(rd_right, rd_left, clk, 1'b1, enable_flush);
    //register #(5)  rs_PIPE(rt_right, rt_left, clk, 1'b1, enable_flush);
    //mux

   // register #(32) imm_PIPE(imm_DE, imm_IF, clk, 1'b1, enable_flush);
    register #(32) inst_PIPE(inst_DE, inst_IF, clk, ~stall, enable_flush);

   
    register #(32) aluData_PIPE(alu_out_data_MW, alu_out_data_DE, clk, 1'b1, reset);
    register #(5)  wr_PIPE(wr_regnum_MW, wr_regnum_DE, clk, 1'b1, reset);
    register #(1)  MemToReg_PIPE(MemToReg_MW, MemToReg_DE, clk, 1'b1, stall||reset);
    register #(1)  regWrite_PIPE(RegWrite_MW, RegWrite_DE, clk, 1'b1, stall||reset);
    register #(1)  MemRead_PIPE(MemRead_MW, MemRead_DE, clk, 1'b1, stall||reset);
    register #(32) select_PIPE(select_data_MW, select_data_DE, clk, 1'b1, reset); 
    register #(1)  MemWrite_PIPE(MemWrite_MW, MemWrite_DE, clk, 1'b1, stall||reset);

    assign forwardA = (wr_regnum_MW == rs) && RegWrite_MW && (wr_regnum_MW != 0);
    assign forwardB = (wr_regnum_MW == rt) && RegWrite_MW && (wr_regnum_MW != 0);
    assign enable_flush = PCSrc || reset;
    assign stall = MemRead_MW && ((wr_regnum_MW == rs) || (wr_regnum_MW == rt))  && (wr_regnum_MW != 0);
    
    
    mux2v #(32) mux_forwardB(select_data_DE, rd2_data, alu_out_data_MW ,forwardB);
    mux2v #(32) mux_forwardA(rdSelect_data, rd1_data, alu_out_data_MW ,forwardA);

endmodule // pipelined_machine
