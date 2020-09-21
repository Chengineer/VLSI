/* Chen Grapel. Verilog Course Exercise 2: 4bit carry look ahead adder test bench. Filename: abc_adder_tb.v */
`include "abc_adder.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module abc_adder_tb();

reg [3:0]A,B;
reg CIN;
wire [3:0]S;
wire COUT;

abc_adder UUT(A,B,CIN,S,COUT);// instantiation of the 4bit CLA adder

initial
begin
A=4'b0000; B=4'b0000; CIN=1'b0;// initial input values
$monitor($time,"A=%b,B=%b,CIN=%b,S=%b,COUT=%b",A,B,CIN,S,COUT);// System monitoring function
end

always #1 {A,B,CIN}={A+1'b1,B+1'b1,CIN+1'b1};// update inputs every 1 time unit
 
initial 
begin
#35 $finish;// System function - end simulation run 
end

endmodule