/* Chen Grapel. Verilog Course Exercise 2: 1bit full adder. Filename: 1bit_full_adder.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module bit_full_adder (A,B,CIN,S,COUT);// module name and ports list

input A,B,CIN;// input ports - A,B,Carry In
output wire S,COUT;// output ports- Sum, Carry Out
assign S = A^B^CIN; // SUM calculation and assignment to S
assign COUT = (A&B)||(A&CIN)||(B&CIN);// Carry Out calculation and assignment to COUT

endmodule