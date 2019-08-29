module alu1_test;
    // exhaustively test your 1-bit ALU by adapting mux4_tb.v

    reg  A = 0, B = 0;
    reg [2:0] control = 0;
    reg carryin = 0;
    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

             A = 1; B = 0; carryin = 1; control = `ALU_ADD; 
        # 10 A = 0; B = 1; carryin = 1; control = `ALU_SUB; 
        # 10 A = 0; B = 0; carryin = 1;control = `ALU_SUB;
	#10  A = 1; B = 0; carryin = 0; control = `ALU_ADD;
        # 10 A = 0; B = 1; carryin = 0; control = `ALU_SUB;
        # 10 A = 0; B = 0; carryin = 0;control = `ALU_SUB;

	# 10 $finish;
    end 

    wire out, carryout;
    
    alu1 a(out, carryout, A, B,carryin, control);  



endmodule
