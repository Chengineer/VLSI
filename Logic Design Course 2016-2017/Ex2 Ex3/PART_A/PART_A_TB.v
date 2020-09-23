/* Chen Grapel Logic Design Course Exercise 2+3 (part A): 16 to 1 MUX test bench. Filename: PART_A_TB.v */

`include "PART_A.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module Mux_tb();

	parameter NUM_LEVELS = 5;
	parameter WIDTH = 2**(NUM_LEVELS-1);
	reg [(WIDTH-1):0] in;
	reg [(NUM_LEVELS-2):0] sel;
	wire out;
	integer i;

	Mux UUT(.in(in),.sel(sel),.out(out));// instantiation of the Mux module

	initial
		begin
			in=16'b0; sel=4'd0;// initial input values
			$monitor($time,"in=%b,sel=%d,out=%b",in,sel,out);// System monitoring function
		end

	initial 
		begin
			#2 sel=4'd14;
			#2 in=16'b1010101010101010;
			for(i=0; i<16; i=i+1)// all 16 options of sel
				begin
					#2 sel=i;
				end
			#2 $finish;// System function - end simulation run    
		end

endmodule
