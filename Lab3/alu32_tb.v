module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        // add more test cases here!
         # 10 A = 8; B = -4; control = `ALU_ADD; 
         # 10 A = 0; B = 0; control = `ALU_ADD; 
         # 10 A = 0; B = 0; control = `ALU_SUB;
         # 10 A = 10; B = 5; control = `ALU_SUB; 
         # 10 A = 32'h7FFFFFFF; B = 32'h7FFFFFFF; control =  `ALU_ADD;
         # 10 A = -65530; B = 65532; control =  `ALU_SUB;
         # 10 A = 32'b11111111111111111111111111111111; B =32'b11111111111111111111111111111111; control =  `ALU_ADD; 
        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test