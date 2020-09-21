/* Chen Grapel. Verilog Course Exercise 3: 7-segment decoder. Filename: 7SEG.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module SEVEN_SEGMENT(HexIn,SEG);// module name and ports list
input wire [3:0]HexIn;/* input port - the number (from 0 to 9)/the capital letter (from A to F) we wish to display with 7-segment */
output wire [6:0]SEG;/* output port- the bits to be turning on/off the matching segments */

assign/* conditional assignment of the bitstream that turns on/off the matching segments according to the exercise's ppt, for each possible input */
SEG=
( HexIn==4'h0 )? 7'b0111111 :
( HexIn==4'h1 )? 7'b0000110 :
( HexIn==4'h2 )? 7'b1011011 :
( HexIn==4'h3 )? 7'b1001111 :
( HexIn==4'h4 )? 7'b1100110 :
( HexIn==4'h5 )? 7'b1101101 :
( HexIn==4'h6 )? 7'b1111101 :
( HexIn==4'h7 )? 7'b0000111 :
( HexIn==4'h8 )? 7'b1111111 :
( HexIn==4'h9 )? 7'b1101111 :
( HexIn==4'hA )? 7'b1110111 :
( HexIn==4'hB )? 7'b1111111 :
( HexIn==4'hC )? 7'b0111001 :
( HexIn==4'hD )? 7'b0111111 :
( HexIn==4'hE )? 7'b1111001 :
7'b1110001 ;/* default value: if the last option for 4bit-hexa, i.e. F, is inserted as an input */

endmodule
