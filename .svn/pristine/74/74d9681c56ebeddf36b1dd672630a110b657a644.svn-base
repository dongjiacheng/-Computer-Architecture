module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire wireN1,wireN2,wireN3,wireN4,wireN5,wireN6,wireN7,wireN8,wireN9;

   or oF(valid,a,b,c,d,e,f,g);
   or o0(number[0],wireN1,wireN3,wireN5,wireN7,wireN9);
   or o1(number[1],wireN7,wireN6,wireN3,wireN2);
   or o2(number[2],wireN7,wireN6,wireN5,wireN4);
   or o3(number[3],wireN8,wireN9);
   and a1(wireN1,d,a);
   and a2(wireN2,d,b);
   and a3(wireN3,d,c);
   and a4(wireN4,a,e);
   and a5(wireN5,b,e);
   and a6(wireN6,c,e);
   and a7(wireN7,f,a);
   and a8(wireN8,f,b);
   and a9(wireN9,f,c);



endmodule // keypad
