module i_reader_test;
 
    reg restart = 1;
    reg [2:0] bits = 3'b0;
    reg clk = 0;
    always #5 clk = !clk;
    
    initial begin
 
        $dumpfile("i_reader.vcd");  
        $dumpvars(0, i_reader_test);
       
         restart = 1;
        # 23
            bits = 3'b111;
        # 4
            bits = 3'b000;       // not an I: restart is still 1
        # 5
            restart = 0;
        # 8
            bits = 3'b111;
        # 10
            bits = 3'b000;       // I
        # 10
            bits = 3'b111;
        # 20
            bits = 3'b000;       // not an I: sequence was 00, 11, 11, 00
        # 15
            $finish;
    end                      
    
    wire I;
    i_reader ir(I, bits, clk, restart);
 
// discouraged:  most students find this more confusing than gtkwave
//     initial
//       $monitor("At time %t, bits = %b I = %d restart = %x",
//                $time, bits, I, restart);
endmodule // i_reader_test
