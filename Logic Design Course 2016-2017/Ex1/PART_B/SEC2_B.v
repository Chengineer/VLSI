/* Chen Grapel. Logic Design Course Exercise 1 (part B): 32-bit adder. Filename: SEC2_B.v */
`include "SEC2_A.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module adder_32b #(parameter WIDTH=32)(input [(WIDTH-1):0]a,b,input cin,output [(WIDTH-1):0]sum, output cry);// module name and ports list
	
	wire [WIDTH:0]carry;// 33-bit inner signal to assist implementing that the carry out of the current index is the carry in of the next index
	assign carry[0]=cin;
	assign cry=carry[WIDTH];

	genvar i;
	generate
		for(i=0;i<(WIDTH);i=i+1)// "apply" the 1bit adder for each of the 32 bits
			begin:adder32
				adder_1b ADDER(.a(a[i]),.b(b[i]),.cin(carry[i]),.sum(sum[i]),.cry(carry[i+1]));// instantiation (by name) of the 1bit addr
			end
	endgenerate
	
endmodule
