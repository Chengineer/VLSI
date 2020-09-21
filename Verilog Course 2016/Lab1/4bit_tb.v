/* Chen Grapel. Verilog Course Exercise 1: 4bits Counter + Test Bench for 4bits Counter
   Filename: 4bit_tb.v */
`include "4bit.v"   
`timescale 1ns / 100ps 
  
module cntr_4b_tb () ;
	reg Clk ;			// System Clock Stimuli
	reg Nrst ;			// System active-low Reset Stimuli
	reg Up ;
	wire [3:0] Dout ;	// Counter Output Monitor

// instantiation of the 4bits Counter
cntr_4b UUT (Clk, Nrst, Up, Dout) ;	// 4bits Counter - UUT (Unit Under test)

initial 
	begin 
		Clk=1'b0; Nrst=1'b0;
		$monitor($time, "Clk=%b, Nrst=%b, Up=%b, Dout=%h", Clk,Nrst,Up,Dout); // System monitoring function
	end
	 
// clock declaration 
always #1 Clk = ~Clk;	// Clock cycle time = 2nSec, i.e clock frequency = 500MHz

initial
	begin
		#0 Up = 1'b1;
		#2 Nrst=1'b1;	// Out of reset
		#5 Up = 1'b0;
		#35 $finish ;	// System function - end simulation run 
	end
endmodule
