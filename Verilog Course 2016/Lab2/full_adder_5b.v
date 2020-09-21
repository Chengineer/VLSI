/* Chen Grapel. Verilog Course Exercise 2: 5bit ripple carry full adder. Filename: full_adder_5b.v */
`include "1bit_full_adder.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module full_adder_5b (A,B,CIN,S,COUT);// module name and ports list

input [4:0]A,B;// input ports - A,B
input CIN;// input ports - Carry In
output wire [4:0]S;// output port- Sum
output wire COUT;// output port-Carry Out
wire C0,C1,C2,C3;// "inner" ports- Carry in of the 3rd adder is the Carry out of the 2nd adder..and so on

// calculating all 5 bits of sum, and carry out bit, using the 1bit_full_adder file
bit_full_adder FBA0(A[0],B[0],CIN,S[0],C0);
bit_full_adder FBA1(A[1],B[1],C0,S[1],C1);
bit_full_adder FBA2(A[2],B[2],C1,S[2],C2);
bit_full_adder FBA3(A[3],B[3],C2,S[3],C3);
bit_full_adder FBA4(A[4],B[4],C3,S[4],COUT);

endmodule