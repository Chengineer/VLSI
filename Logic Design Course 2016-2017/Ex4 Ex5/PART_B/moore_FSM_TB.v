/* Chen Grapel Logic Design Course Exercise 4+5 (part B): moore FSM test bench. Filename: moore_FSM_TB.v */

`include "moore_FSM.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module MooreFSM_tb();

	reg x;
	reg clk;
	reg nrst;
	wire y;

	MooreFSM UUT(.x(x),.clk(clk),.nrst(nrst),.y(y));// instantiation of the MooreFSM module

	initial
		begin
			x=1'b0;clk=1'b0;nrst=1'b0;// initial input values
			$monitor($time,"x=%b,clk=%b,nrst=%b,y=%b",x,clk,nrst,y);// System monitoring function
		end

	always #1 clk=~clk;// clock generation
		
	initial 
		begin
			#2 nrst=1'b1;
			#2 x=1'b1;
			#8 x=1'b0;
			#1 x=1'b1;
			#4 nrst=1'b0;
			#4 nrst=1'b1;
			#2 x=1'b1;
			#2 x=1'b0;
			#1 x=1'b1;
			#4 x=1'b0;
			#4 x=1'b1;			
			#2 $finish;// System function - end simulation run    
		end

endmodule
