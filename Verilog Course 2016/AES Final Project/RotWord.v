/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: RotWord.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module RotWord(roundKeyMSBs,rotated);/* RotWord module performs a cyclic rotation of the MSB word (32-bits) of the round key, as part of the AES key expansion implementation.*/

	// parameters definition:
	localparam BYTE=8;// one byte contains 8 bits
	localparam WORD=BYTE*4;// one word contains 32 bits (4*8)

	input wire [(WORD-1):0] roundKeyMSBs;// 32-bits input-the 32 MSB bits of the current round key: {a0,a1,a2,a3}
	output wire [(WORD-1):0] rotated;// 32-bits output- the roundKeyMSBs after a cyclic rotation of one byte size: {a1,a2,a3,a0} 

	assign rotated[(BYTE-1):0]=roundKeyMSBs[(WORD-1):(3*BYTE)];// assign the MSB byte of roundKeyMSBs into the LSB byte of rotated  
	assign rotated[(WORD-1):BYTE]=roundKeyMSBs[(WORD-BYTE-1):0];// left shift of 8 bits, so the (MSB-1) byte of roundKeyMSBs becomes the MSB byte of rotated
	

endmodule

