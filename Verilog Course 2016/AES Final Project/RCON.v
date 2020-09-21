/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: RCON.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module RCON(roundNumber,rconOut);/* RCON module produces a word by concatenating powers of {02}Hexa (eight-bits MSBs), and 24'h0, as part of the AES key expansion implementation. the current power value is the current round number minus one. */

	// parameters definition:
	localparam BYTE=8;// one byte contains 8 bits
	localparam WORD=BYTE*4;// one word contains 32 bits (4*8)
	localparam ROUNDNUMREPBITS=4;// number of bits required to represent the round number (1 to 10) is 4

	input wire [(ROUNDNUMREPBITS-1):0] roundNumber;// 4-bits input- the current round number from 1 to 10 	
	output wire [(WORD-1):0] rconOut;// 32-bits output- the word produced according to the current round number

	assign rconOut=(roundNumber<9)?({(8'h01<<(roundNumber-1)),24'h0}):({(8'h1B<<(roundNumber-9)),24'h0});
	/*
	left shift 8'h01 by the round number minus one, and then concatenate with 24'h0:
	roundNumber=1: rconOut[31:0]={8'h01,24'h0}  //8'h01=8'b00000001
	roundNumber=2: rconOut[31:0]={8'h02,24'h0}  //8'h02=8'b00000010
	roundNumber=3: rconOut[31:0]={8'h04,24'h0}  //8'h04=8'b00000100
	roundNumber=4: rconOut[31:0]={8'h08,24'h0}  //8'h08=8'b00001000
	roundNumber=5: rconOut[31:0]={8'h10,24'h0}  //8'h10=8'b00010000
	roundNumber=6: rconOut[31:0]={8'h20,24'h0}  //8'h20=8'b00100000
	roundNumber=7: rconOut[31:0]={8'h40,24'h0}  //8'h40=8'b01000000
	roundNumber=8: rconOut[31:0]={8'h80,24'h0}  //8'h80=8'b10000000
	left shift 8'h1B by the round number minus nine, and then concatenate with 24'h0:
	roundNumber=9: rconOut[31:0]={8'h1B,24'h0}  //8'h1B=8'b00011011
	roundNumber=10: rconOut[31:0]={8'h36,24'h0} //8'h36=8'b00110110
	roundNumber=11: rconOut[31:0]={8'h6C,24'h0} //8'h6C=8'b01101100
	we won't have more than 10 rounds, so we didn't consider the next overflow cases in the conditional assignment 
	*/

endmodule
