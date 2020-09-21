/* Chen Grapel. Verilog Course Exercise 2: 4bit carry look ahead adder. Filename: abc_adder.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module abc_adder (A,B,CIN,S,COUT);// module name and ports list

input [3:0]A;// input port- A
input [3:0]B;// input port - B
input CIN;// input port - Carry In
output wire [3:0]S;// output port- Sum
output wire COUT;// output port- Carry Out
wire [3:1]C;// "inner" input port for the middle Carry-Ins
wire [3:0]P,G;// "inner" output ports for Propagate and Generate

// LSB 
assign P[0]=A[0]^B[0];
assign G[0]=A[0]&B[0];
assign S[0]=P[0]^CIN;// LSB of sum
assign C[1]=G[0]||(P[0]&CIN);
// second bit
assign P[1]=A[1]^B[1];
assign G[1]=A[1]&B[1];
assign S[1]=P[1]^C[1];// second bit of sum
assign C[2]=G[1]||(P[1]&C[1]);
// third bit
assign P[2]=A[2]^B[2];
assign G[2]=A[2]&B[2];
assign S[2]=P[2]^C[2];// third bit of sum
assign C[3]=G[2]||(P[2]&C[2]);
// MSB 
assign P[3]=A[3]^B[3];
assign G[3]=A[3]&B[3];
assign S[3]=P[3]^C[3];// MSB of sum
assign COUT=G[3]||(P[3]&C[3]);// Carry Out

endmodule

