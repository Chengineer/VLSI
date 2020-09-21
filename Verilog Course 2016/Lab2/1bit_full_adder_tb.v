/* Chen Grapel. Verilog Course Exercise 2: 1bit full adder test bench. Filename: 1bit_full_adder_tb.v */
`include "1bit_full_adder.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module bit_full_adder_tb();

reg A,B,CIN;
wire S,COUT;

bit_full_adder UUT(A,B,CIN,S,COUT);// instantiation of the 1bit FA

initial
begin
A=1'b0; B=1'b0; CIN=1'b0;// initial input values
$monitor($time,"A=%b,B=%b,CIN=%b,S=%b,COUT=%b",A,B,CIN,S,COUT);// System monitoring function
end

always #1 {A,B,CIN}={A,B,CIN}+1'b1;// update inputs every 1 time unit

initial 
begin
#35 $finish;// System function - end simulation run 
end

endmodule