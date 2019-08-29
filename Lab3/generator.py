## a code generator for the ALU chain in the 32-bit ALU
## see example_generator.py for inspiration
## 
## python generator.py
from __future__ import print_function

width = 32
for i in range(1, width):
    print("	register rg{0}(reg{0},wr_data,clock,decoded[{0}],reset);".format(i))
