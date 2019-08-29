`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           regnum, wr_data, next_pc, TimerInterrupt,
           MTC0, ERET, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input   [4:0] regnum;
    input  [31:0] wr_data;
    input  [29:0] next_pc;
    input         TimerInterrupt, MTC0, ERET, clock, reset;
    wire   [29:0] EPCin;
    wire   [31:0] dkout,user_status;
    wire   [31:0] status_register,cause_register;
    wire    exception_level;


   
	register User_status(user_status, wr_data,clock, dkout[12] , reset);

	assign status_register = {{16{1'b0}},user_status[15:8],{6{1'b0}}, exception_level,user_status[0] };
	assign cause_register = {{16{1'b0}}, TimerInterrupt, {15{1'b0}}};

	

	assign TakenInterrupt = ((cause_register[15] & status_register[15]) & (status_register[0] & ~status_register[1]));
	
	decoder32 dk(dkout, regnum, MTC0);
	

	
	mux2v #(30) mux2(EPCin,wr_data[31:2],next_pc,TakenInterrupt);

	register #(30) EPC_register(EPC, EPCin, clock, (TakenInterrupt | dkout[14]),reset);
	
	dffe Exception_level(exception_level, 1, clock, TakenInterrupt,(reset | ERET));

	mux32v	mux4(rd_data,0,1,2,3,4,5,6,7,8,9,10,11,status_register,cause_register,{EPC,2'b00},15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,regnum);
	

    // your Verilog for coprocessor 0 goes here
endmodule
