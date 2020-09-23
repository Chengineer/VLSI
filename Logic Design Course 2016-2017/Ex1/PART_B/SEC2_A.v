/* Chen Grapel. Logic Design Course Exercise 1 (part B): 1-bit adder. Filename: SEC2_A.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module adder_1b(input a,b,cin,output sum,cry);// module name and ports list

	// implementations of 1bit adder logic functions:
	assign sum=(a^b^cin);
	assign cry=((a&b)|(cin&(a^b)));
	
endmodule
