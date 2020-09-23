/* Chen Grapel. Logic Design Course Exercise 1 (part B): 1-bit adder test bench. Filename: SEC2_A_TB.v */
`include "SEC2_A.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module adder_1b_tb();// module name and ports list

	reg A,B,Cin;
	wire Sum,Cry;

	adder_32b UUT(.a(A),.b(B),.cin(Cin),.sum(Sum),.cry(Cry));// instantiation (by name) of the 32bit adder

	initial
		begin
		A=1'b0; B=1'b0; Cin=1'b0;// initial input values
		$monitor($time,"A=%b,B=%b,Cin=%b,Sum=%b,Cry=%b",A,B,Cin,Sum,Cry);// System monitoring function
		end

	always #1 {A,B,Cin}={A,B,Cin}+1'b1;// update inputs every 1 time unit to cover all 8 input cases

	initial 
		begin
		#9 $finish;// System function - end simulation run 
		end

endmodule
