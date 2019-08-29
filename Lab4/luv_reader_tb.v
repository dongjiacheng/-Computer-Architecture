module luv_reader_test;

   reg reset = 1;
   reg [2:0] bits = 3'b0;
   reg clk = 0;
   always #5 clk = !clk;
   
   initial begin

      $dumpfile("luv.vcd");  
      $dumpvars(0, luv_reader_test);
      
      reset = 1;
        # 23
            bits = 3'b111;
        # 4
            bits = 3'b000;       // not an I: restart is still 1
        # 5
            reset = 0;
        # 8
            bits = 3'b111;
        # 10
            bits = 3'b000;       // I
        # 10
            bits = 3'b111;
	reset = 1;
        # 10
            bits = 3'b001;
	# 10
	    bits = 3'b000;
	# 10
	    bits = 3'b111;
	#10
            bits = 3'b001;
	#10
	    bits = 3'b111;
	#10 
	    bits = 3'b000;
	#10
	    bits = 3'b111;
	#10
	    bits = 3'b000;
		reset = 0;
	#10
	    bits = 3'b110;
	#10
	    bits = 3'b001;
	#10
	    bits = 3'b110;
	#10
	    bits = 3'b000;	
	
		       // not an I: sequence was 00, 11, 11, 00
        # 15
	
      $finish;              // end the simulation
   end                      
   
   wire I, L, U, V;
   luv_reader lr(I, L, U, V, bits, clk, reset);

   initial
     $monitor("At time %t, bits = %b I = %d L = %d U = %d V = %d reset = %x",
              $time, bits, I, L, U, V, reset);
endmodule // luv_reader_test
