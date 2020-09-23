/* Chen Grapel Logic Design Course Exercise 2+3 (part B 2):Fibonacci series generator test bench. Filename: PART_B_2_TB.v */

`include "PART_B_2.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module Fibonacci_tb();
	
	parameter FibBits=10;
	reg clk;
	reg nrst;
	wire [FibBits-1:0] f;

	Fibonacci UUT(.clk(clk),.nrst(nrst),.f(f));// instantiation of the Fibonacci module

	initial
		begin
			clk=1'b0; nrst=1'b0;// initial input values
			$monitor($time,"clk=%b,nrst=%b,f=%d",clk,nrst,f);// System monitoring function
		end

	always #1 clk=~clk;// define clock signal to toggle every 1Xtime unit

	initial 
		begin
			#1 nrst=1'b1;
			#32 nrst=1'b0;/* limits the output to the first 17 elements (->extended version. the first 16 elements of the "regular" series are included) */
			#2 nrst=1'b1;
			#7 nrst=1'b0;
			#2 $finish;// System function - end simulation run    
		end

endmodule
