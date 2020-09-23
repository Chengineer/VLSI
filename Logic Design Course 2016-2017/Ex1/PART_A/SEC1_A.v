/* Chen Grapel. Logic Design Course Exercise 1 (part A section A): 8-bit mux. Filename: SEC1_A.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module mux8_2A #(parameter WIDTH=8)(input [(WIDTH-1):0]a,b,input sel,output [(WIDTH-1):0]out);// module name and ports list
	
	// continuous assignment:
	assign out=((a&(sel))|((~sel)&b));
	
endmodule
