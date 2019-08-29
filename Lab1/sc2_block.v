// Complete the sc2_block module in this file
// Don't put any code in this file besides the sc2_block

module sc2_block(s, cout, a, b, cin);
output s,cout;
input a,b, cin;
wire wire1, wire2, wire3;

or o1(cout,wire3,wire2);
sc_block sc2(s,wire3,wire1,cin);
sc_block sc1(wire1,wire2,a,b);
endmodule // sc2_block
