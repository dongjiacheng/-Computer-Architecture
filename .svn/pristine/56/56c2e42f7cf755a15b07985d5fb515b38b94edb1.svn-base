module sc2_test;

	reg A,B,Cin;
	wire S , Cout;

	sc2_block scbox (S, Cout, A, B, Cin);
	

	
	initial begin
		$dumpfile("sc2.vcd");
	 	$dumpvars(0,sc2_test);
		A =0 ;B =0 ; Cin =0 ; #10;
		A =1 ;B =1 ; Cin =0 ; #10;
		A =0 ;B =1 ; Cin =0 ; #10;
		A =0 ;B =1 ; Cin =1 ; #10;
		A =1 ;B =0 ; Cin =0 ; #10;
		A =1 ;B =0 ; Cin =1 ; #10;
	

 		$finish;
 	end

	 initial 
               $monitor("AtTime %2t, A = %d B = %d Cin = %d S = %d Cout = %d ",$time, A,B, Cin, S, Cout);

endmodule // sc2_test
