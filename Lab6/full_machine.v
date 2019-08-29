// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst, rsData, rtData,B,imm32,branchOFF,goinB,sltout,sltin,data_out,goinBLT;  
    wire [31:0] PC,nextPC,out,out2,mux0,mux1,mux2,BLTout,MRDout,luiIN,LUIout, ADDMout,goinRdata;
    wire   overflow, zero, negative,overflow2, zero2, negative2,addm,byte_load,mem_read;   
    wire [2:0] alu_op;
    wire       writeenable, rd_src, alu_src2,mem_rd,word_we,byte_we,byte_ld,lui,slt;
    wire [4:0] rdNum;
    wire [1:0] control_type;
    wire [7:0] btout;
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst,PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf ( rsData, rtData,
                inst[25:21], inst[20:16], rdNum, goinRdata, 
                writeenable, clock, reset);

    mux4v controlPart(nextPC,mux0 , mux1, mux2, rsData, control_type);
    alu32 A1(mux0, overflow, zero, negative, PC,32'h00000004, 3'b010);  
    alu32 Aequal(mux1,overflow, zero, negative, mux0, branchOFF, 3'b010);

    assign mux2 = {PC[31:28],inst[25:0],2'b00};    
    assign branchOFF = imm32[29:0]<<2;
    mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                    inst[31:26], inst[5:0], zero2);    
    /* add other modules */
    
    mux2v forADDm(goinB,B, 32'h00000000 ,addm);  

    
    mux2v mx1(B,rtData,imm32,alu_src2);  

    assign imm32 = {{16{inst[15]}}, inst[15:0]};

    mux2v #(5) mx0(rdNum, inst[15:11] ,inst[20:16],rd_src);


    alu32 A2(out2, overflow2, zero2, negative2, rsData, goinB , alu_op[2:0]);

    assign  sltin = {31'b0,negative2};  

    mux2v mxslt(sltout,out2,sltin,slt);

    data_mem d1(data_out, out2,rtData, word_we, byte_we, clock, reset);

    mux4v #(8) byteprocess(btout,data_out[7:0],data_out[15:8],data_out[23:16],data_out[31:24],out2[1:0]);

    assign goinBLT = {24'b0,btout};
        
    mux2v mxBLT(BLTout,data_out,goinBLT,byte_load);

    mux2v mxMRD(MRDout,sltout,BLTout,mem_read);

    assign luiIN = {inst[15:0],16'b0};    

    mux2v mxLUI(LUIout,MRDout,luiIN,lui);

    alu32 AaddM(ADDMout, overflow, zero, negative, BLTout, rtData, 3'b010);

    mux2v mxRDDATA(goinRdata,LUIout,ADDMout,addm);

endmodule // full_machine