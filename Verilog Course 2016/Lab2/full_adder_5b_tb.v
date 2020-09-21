/* Chen Grapel. Verilog Course Exercise 2: 5bit ripple carry full adder test bench. Filename: full_adder_5b_tb.v */
`include "full_adder_5b.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module full_adder_5b_tb();

reg [4:0]A,B;
reg CIN;
wire [4:0]S;
wire COUT;

full_adder_5b UUT(A,B,CIN,S,COUT);// instantiation of the 5bit FA

initial
begin
A=5'b00000; B=5'b00000; CIN=1'b0;// initial input values
$monitor($time,"A=%b,B=%b,CIN=%b,S=%b,COUT=%b",A,B,CIN,S,COUT);// System monitoring function
end

always #1 {A,B,CIN}={A+4'b0010,B+4'b0001,CIN+1'b1};// update inputs every 1 time unit

initial 
begin
#35 $finish;// System function - end simulation run 
end

endmodule