// 00 - AND, 01 - OR, 10 - NOR, 11 - XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire temp[3:0];

    and a1(temp[0],A,B);
    or o1(temp[1],A,B);
    nor n1(temp[2],A,B);
    xor x1(temp[3],A,B);


    mux4 max4(out,temp[0],temp[1],temp[2],temp[3],control[1:0]);
    
endmodule // logicunit
