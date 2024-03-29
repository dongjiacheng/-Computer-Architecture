// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module dffe(q, d, clk, enable, reset);
   output q;
   reg    q;
   input  d;
   input  clk, enable, reset;

   always@(reset)
     if (reset == 1'b1)
       q <= 0;

   always@(posedge clk)
     if ((reset == 1'b0) && (enable == 1'b1))
       q <= d;
endmodule // dffe


module luv_reader(I, L, U, V, bits, clk, restart);
   output 	I, L, U, V;
   input [2:0] 	bits;
   input       restart, clk;
   wire        in000, in111,in001,
                sGarbage, sGarbage_next,
                sBlank, sBlank_next,
                sI, sI_next,sL,sL_next,sU,sU_next, sV, sV_next, sVt, sVt_next, sVth, sVth_next, 
                sI_end, sI_end_next,sL_end,sL_end_next,sU_end,sU_end_next,
                sV_end, sV_end_next;

    assign in000 = bits == 3'b000;
    assign in111 = bits == 3'b111;
    assign in001 = bits == 3'b001;
    assign in110 = bits == 3'b110;
   
    assign sGarbage_next = ((sBlank | sU_end|sL_end|sI_end | sV_end ) & ~(in000 | in111 | in110)) | ((sU | sGarbage | sVth ) & ~in000)|restart|((sI|sV) & ~(in000|in001))| (sL & ~(in000 | in111 ))| (sVt & ~(in000| in110)) ;
    
    assign sBlank_next = (sBlank | sI_end | sGarbage | sU_end | sL_end | sV_end | sVt | sV) & in000 & ~restart;
    assign sI_next = (sBlank | sI_end |sL_end| sU_end | sV_end ) & in111 & ~restart;
    assign sI_end_next = sI & in000 & ~restart;   
    assign sL_next = sI & in001 & ~restart;
    assign sL_end_next = sL & in000 & ~restart; 
    assign sU_next = sL & in111 & ~restart;  
    assign sU_end_next = sU & in000 & ~restart;
    assign sV_next = (sBlank | sI_end |sL_end| sU_end | sV_end ) & in110 & ~restart;
    assign sVt_next = sV & in001 & ~restart;
    assign sVth_next = sVt & in110 & ~restart;
    assign sV_end_next = sVth & in000 & ~restart;
     

    dffe fsGarbage(sGarbage, sGarbage_next, clk, 1'b1, 1'b0);
    dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
    dffe fsI(sI, sI_next, clk, 1'b1, 1'b0);
    dffe fsI_end(sI_end, sI_end_next, clk, 1'b1, 1'b0);
    dffe fsL(sL, sL_next, clk, 1'b1, 1'b0);
    dffe fsL_end(sL_end, sL_end_next, clk, 1'b1, 1'b0);
    dffe fsU(sU, sU_next, clk, 1'b1, 1'b0);
    dffe fsU_end(sU_end, sU_end_next, clk, 1'b1, 1'b0);
    dffe fsV(sV, sV_next, clk, 1'b1, 1'b0);
    dffe fsV_end(sV_end, sV_end_next, clk, 1'b1, 1'b0);
    dffe fsVt(sVt, sVt_next, clk, 1'b1, 1'b0);
    dffe fsVth(sVth, sVth_next, clk, 1'b1, 1'b0);


    assign I = sI_end;
    assign U = sU_end;
    assign L = sL_end;
    assign V = sV_end;
  
   
endmodule // luv_reader
