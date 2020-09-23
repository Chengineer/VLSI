/* Chen Grapel Logic Design Course Exercise 4+5 (part A): the top level of a system that computes the Greatest Common Divisor of two integers. Filename:top_level.v */

`include "control_FSM.v"
`include "data_path.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution


module toplevel(In_A,In_B,Clk,nrst,In_ready,Result_taken,Result);// module name and ports list
	
	parameter numOfBits=5;// size of data in&out 
	localparam bits=2;// number of bits required to represent mux-A input options
	// input ports:
	input [numOfBits-1:0] In_A;
	input [numOfBits-1:0] In_B;
	input Clk;
	input nrst;
	input In_ready;
	input Result_taken;
	// output port:
	output [numOfBits-1:0] Result;
	// inner signals (the communication between the control and the data path):
	wire [bits-1:0] Asel;
	wire Aen;
	wire Bsel;
	wire Ben;
	wire B_eq_0;
	wire A_lessThan_B;
	
	// wiring the entire system:
	controlFSM Control(.clk(Clk),.nrst(nrst),.In_ready(In_ready),.B_eq_0(B_eq_0),.A_lessThan_B(A_lessThan_B),.Result_taken(Result_taken),.Asel(Asel),.Aen(Aen),.Bsel(Bsel),.Ben(Ben));// instantiation of the controlFSM module
	datapath Data(.In_A(In_A),.In_B(In_B),.clk(Clk),.Asel(Asel),.Aen(Aen),.Bsel(Bsel),.Ben(Ben),.Result(Result),.B_eq_0(B_eq_0),.A_lessThan_B(A_lessThan_B));// instantiation of the datapath module
	
endmodule
