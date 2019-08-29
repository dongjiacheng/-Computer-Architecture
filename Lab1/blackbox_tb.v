module blackbox_test;


	reg r,v,y;
	wire o;

	blackbox scbox (o,r,v,y);
	

	
	initial begin
		$dumpfile("blackbox.vcd");
	 	$dumpvars(0,blackbox_test);
		r =0 ;v =0 ; y =0 ; #10;
		r =0 ;v =0 ; y =1 ; #10;
		r =0 ;v =1 ; y =0 ; #10;
		r =0 ;v =1 ; y =1 ; #10;
		r =1 ;v =0 ; y =0 ; #10;
		r =1 ;v =0 ; y =1 ; #10;
		r =1 ;v =1 ; y =0 ; #10;
		r =1 ;v =1 ; y =1 ; #10;

 		$finish;
 	end

	 initial 
               $monitor("AtTime %2t, r = %d v = %d y = %d  output = %d ",$time, r,v, y, o);


endmodule // blackbox_test
