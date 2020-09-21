/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: keyExpansion.v */
`include "RotWord.v"
`include "SubWord.v"
`include "RCON.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module Key_Expansion(roundKey,roundNumber,nextRoundKey);/* Key Expansion module produces the keys for all rounds using a given main key. */

	// parameters definition:
	localparam BYTE=8;// one byte contains 8 bits
	localparam BYTESPERWORD=4;// one word contains 4 bytes
	localparam WORD=BYTE*BYTESPERWORD;// one word contains 32 bits (4*8)
	localparam ROUNDNUMREPBITS=4;// number of bits required to represent the round number (1 to 10) is 4
	localparam Nb=128;// key's number of bits 

	input wire [((Nb)-1):0] roundKey;// 128-bits input-the current round key 
	input wire [(ROUNDNUMREPBITS-1):0] roundNumber;// 4-bits input- the current round number from 1 to 10	
	output wire [((Nb)-1):0] nextRoundKey;// 128-bits output- the next round key 	
	wire [(WORD-1):0] rotated,substituted,rconOut;// 32-bits inner wires- the outputs of the inner modules

	// inner modules instantiation
	RotWord rw(roundKey[(WORD-1):0],rotated);/* roundKey[127:96] -> RotWord input..RotWord operation..RotWord output -> rotated */
	SubWord sw(rotated,substituted);/* rotated -> SubWord input..SubWord operation..SubWord output -> substituted */ 
	RCON rc(roundNumber,rconOut);/* roundNumber -> RCON input..RCON operation..RCON output -> rconOut */ 

	assign nextRoundKey[((Nb)-1):(WORD*3)]=(rconOut^substituted)^(roundKey[((Nb)-1):(WORD*3)]);/* calculating the next round key MSB word: nextRoundKey[127:96]=(rconOut^substituted)^roundKey[127:96] */

	genvar i;
	generate
		for(i=0; i<(BYTESPERWORD-1); i=i+1)/* calculating next round key words- for i=0: LSB word, for i=1: LSB+1, for i=2: MSB-1 */
			begin: NRK
				assign nextRoundKey[((Nb-((i+1)*WORD))-1):(WORD*(2-i))]=(nextRoundKey[((Nb-(i*WORD))-1):(WORD*(3-i))])^(roundKey[((Nb-((i+1)*WORD))-1):(WORD*(2-i))]);
			end
	/*
	nextRoundKey[95:64]=nextRoundKey[127:96]^roundKey[95:64] //MSB-1
	nextRoundKey[63:32]=nextRoundKey[95:64]^roundKey[63:32] //LSB+1
	nextRoundKey[31:0]=nextRoundKey[63:32]^roundKey[31:0]  //LSB
	*/
	endgenerate

endmodule


