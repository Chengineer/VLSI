/* Chen Grapel Logic Design Course Exercise 4+5 (part A): data path test bench. Filename: data_path_TB.v */

`include "data_path.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module datapath_tb();

	parameter numOfBits=5;
	localparam bits=2;
	reg [numOfBits-1:0] In_A;
	reg [numOfBits-1:0] In_B;
	reg clk;
	reg [bits-1:0] Asel;
	reg Aen;
	reg Bsel;
	reg Ben;
	wire [numOfBits-1:0] Result;
	wire B_eq_0;
	wire A_lessThan_B;

	datapath UUT(.In_A(In_A),.In_B(In_B),.clk(clk),.Asel(Asel),.Aen(Aen),.Bsel(Bsel),.Ben(Ben),.Result(Result),.B_eq_0(B_eq_0),.A_lessThan_B(A_lessThan_B));// instantiation of the Mux module

	initial
		begin
			In_A=5'd0;In_B=5'd0;clk=1'b0;Asel=2'd0;Aen=1'b0;Bsel=1'b0;Ben=1'b0;// initial input values
			$monitor($time,"In_A=%d,In_B=%d,clk=%b,Asel=%d,Aen=%b,Bsel=%b,Ben=%b,Result=%d,B_eq_0=%b,A_lessThan_B=%b",In_A,In_B,clk,Asel,Aen,Bsel,Ben,Result,B_eq_0,A_lessThan_B);// System monitoring function
		end

	always #1 clk=~clk;// clock generation

	initial 
		begin
			#2 In_A=5'd6;In_B=5'd3;
			#2 Asel=2'd0;Aen=1'b1;Bsel=1'b1;Ben=1'b1;
			#2 Asel=2'd1;Ben=1'b0;
			#4 Asel=2'd2;Bsel=1'b0;Ben=1'b1; 
			#2 $finish;// System function - end simulation run    
		end

endmodule
