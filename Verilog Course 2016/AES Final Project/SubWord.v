/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: SubWord.v */
`include "Sbox.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module SubWord(rotated,substituted);/* SubWord module applies the Sbox to each of the four bytes of the 32-bit word it gets from the output of the RotWord module, as part of the AES key expansion implementation.*/

	// parameters definition:
	localparam BYTE=8;// one byte contains 8 bits
	localparam BYTESPERWORD=4;// one word contains 4 bytes
	localparam WORD=BYTE*BYTESPERWORD;// one word contains 32 bits (4*8)

	input wire [(WORD-1):0] rotated;// 32-bits input- the output of the RotWord module
	output wire [(WORD-1):0] substituted;// 32-bits output- input word (rotated) after being substituted in the SB module	

	genvar i;
	generate
		for(i=0; i<BYTESPERWORD; i=i+1)
			begin: s
				SB sbox(rotated[((BYTE*(i+1))-1):(BYTE*i)],substituted[((BYTE*(i+1))-1):(BYTE*i)]);
			end
	endgenerate
	/*
	applies the Sbox module to each byte of the input word, and assigns the Sbox'es output into the corresponding byte of the output word:
	for i=0: rotated[7:0] -> sbox input..sbox operation..sbox output -> substituted[7:0]
	for i=1: rotated[15:8] -> sbox input..sbox operation..sbox output -> substituted[15:8]
	for i=2: rotated[23:16] -> sbox input..sbox operation..sbox output -> substituted[23:16]
	for i=3: rotated[31:24] -> sbox input..sbox operation..sbox output -> substituted[31:24]
	*/

endmodule
