/* Chen Grapel Logic Design Course Exercise 2+3 (part B 2): Fibonacci series generator (extended version -with F0). Filename:PART_B_2.v */

`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module Fibonacci(clk,nrst,f);// module name and ports list

	parameter FibBits=10;// number of bits required to represent a fibonnaci number from 0 to 987 (2^10=1024)
	input clk;// input port-clock
	input nrst;// input port-negative reset
	output [FibBits-1:0] f;// output port- the current Finonacci number
	reg [FibBits-1:0] tempF_n;// inner register-F(n)
	reg [FibBits-1:0] tempF_nminus1;// inner register-F(n-1)
	reg [FibBits-1:0] tempF_nplus1;// inner register-F(n+1)
	
	always @(posedge clk or negedge nrst)
		begin
			if(!nrst)// asynchronuous negative reset
				begin
					tempF_nminus1<=10'd0;
					tempF_n<=10'd1;// F1
					tempF_nplus1<=10'd0;// F0 (for an extended Fibonacci sequence)
				end
			else
				begin
					// implementing F(n+1)=F(n)+F(n-1)
					tempF_nminus1<=tempF_n;
					tempF_n<=tempF_nplus1;
					tempF_nplus1<=tempF_n+f;
				end
		end
	
	assign f=tempF_nplus1;// Fibonacci number
	
endmodule
