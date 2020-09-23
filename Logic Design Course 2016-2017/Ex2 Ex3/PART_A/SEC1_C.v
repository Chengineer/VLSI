/* Chen Grapel Logic Design Course Exercise 1 (part A section C): 8-bit mux. Filename: SEC1_C.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module mux8_2C #(parameter WIDTH=8)(input [(WIDTH-1):0]a,b,input sel,output [(WIDTH-1):0]out);// module name and ports list

	// conditional assignment:
	assign out=(sel)?a:b;// if select bit=1:out=a,if select bit=0:out=b

endmodule
