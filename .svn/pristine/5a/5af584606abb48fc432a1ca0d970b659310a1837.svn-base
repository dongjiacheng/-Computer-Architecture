module timer(TimerInterrupt, TimerAddress, cycle,
             address, data, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt, TimerAddress;
    output [31:0] cycle;
    input  [31:0] address, data;
    input         MemRead, MemWrite, clock, reset;
    wire [31:0] InterOut, CycleOut,ALUout;
    wire zero, negative;
    wire InterruptLieEnable;
    wire TimeAddress,Acknowledge,TimeWrite,TimeRead;
    wire insideWire = (address == 32'hffff001c);
    wire insideWire2 = (address == 32'hffff006c);

    assign TimerAddress = (insideWire | insideWire2);
    assign Acknowledge = (MemWrite & insideWire2);
    assign TimeWrite = (insideWire & MemWrite);
    assign TimeRead = (insideWire & MemRead);
    
    register #(32,32'hffffffff) InterrruptCycle(InterOut, data, clock, TimeWrite, reset);
    

    register cycleCounter(CycleOut, ALUout, clock, 1, reset);

    assign InterruptLieEnable = (InterOut == CycleOut);
    
    alu32 alu(ALUout, zero, negative, `ALU_ADD, CycleOut, 32'd1);	
    
    tristate trI(cycle,CycleOut,TimeRead);

    dffe Interruptline(TimerInterrupt,1'b1,clock,InterruptLieEnable,(Acknowledge | reset));
	

    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
