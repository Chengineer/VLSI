/* Chen Grapel. Logic Design Course Exercise 1 (part A sections A,B,C,D): 8-bit mux test bench. Filename: SEC1_A_B_C_D_tb.v */
`include "SEC1_A.v"
`include "SEC1_B.v"
`include "SEC1_C.v"
`include "SEC1_D.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module mux8_2_tb();

	parameter WIDTH=8;
	reg [(WIDTH-1):0]A,B;
	reg SEL;
	wire [(WIDTH-1):0]OUT_A,OUT_B,OUT_B2,OUT_C,OUT_D;// avoiding races

	// instantiations of different modules which implement MUX: 
	mux8_2A UUT1(A,B,SEL,OUT_A);// by position
	mux8_2B UUT2(.a(A),.b(B),.sel(SEL),.out(OUT_B));// by name
	mux8_2B2 UUT3(.a(A),.b(B),.sel(SEL),.out(OUT_B2));// by name
	mux8_2C UUT4(A,B,SEL,OUT_C);// by position
	mux8_2D UUT5(A,B,SEL,OUT_D);// by position

	initial
		begin
			A=8'hAA; B=8'hBB; SEL=1'b0;// initial input values
			$monitor($time,"A=%h,B=%h,SEL=%b,OUT_A=%h,OUT_B=%h,OUT_B2=%h,OUT_C=%h,OUT_D=%h",A,B,SEL,OUT_A,OUT_B,OUT_B2,OUT_C,OUT_D);// System monitoring function
		end

	initial 
		begin
			#2 SEL=1'b1;// OUT=A
			#2 SEL=1'b0;// OUT=B
			#2 $finish;// System function - end simulation run    
		end

endmodule
