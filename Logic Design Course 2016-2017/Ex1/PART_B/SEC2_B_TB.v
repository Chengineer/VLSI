/* Chen Grapel. Logic Design Course Exercise 1 (part B): 32-bit adder test bench. Filename: SEC2_B_TB.v */
`include "SEC2_B.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module adder_32b_tb();// module name and ports list

	parameter WIDTH=32;
	reg [(WIDTH-1):0]A,B;
	reg Cin;
	wire [(WIDTH-1):0]Sum;
	wire Cry;

	adder_32b UUT(A,B,Cin,Sum,Cry);// instantiation (by position) of the 32bit adder

	initial
		begin
			A=32'd0; B=32'd0; Cin=1'b0;// initial input values
			$monitor($time,"A=%h,B=%h,Cin=%b,Sum=%h,Cry=%b",A,B,Cin,Sum,Cry);// System monitoring function
		end

	initial 
		begin
			#2 A=32'hFFFFFFFF; B=32'hFFFFFFFF; 
			#2 A=32'hFFFFFFFF; B=32'hFFFFFFFF; Cin=1'b1;
			#2 A=32'h7DFEF9FA; B=32'h2DCE79DA; 
			#2 A=32'h7DFEF9FA; B=32'h2DCE79DA; Cin=1'b0;
			#2 A=32'h1CE69DA; B=32'h11CA694A; Cin=1'b1;
			#2 A=32'h80808080; B=32'hC1C1C1C1; 
			#2 A=32'h80808080; B=32'hC1C1C1C1; Cin=1'b0;
			#2 $finish;// System function - end simulation run 
		end

endmodule
