/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: keyExpansion_tb.v */

`include "keyExpansion.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module Key_Expansion_tb();// key expansion test bench module

	// parameters definition:
	localparam BYTE=8;// One byte contains 8 bits
	localparam WORD=BYTE*4;// One word contains 32 bits (4*8)
	localparam ROUNDNUMREPBITS=4;// Number of bits required to represent the round number (0 to 10) is 4
	localparam Nb=128;// key's number of bits 

	reg [((Nb)-1):0] roundKey;// input- the current round key
	reg [(ROUNDNUMREPBITS-1):0] roundNumber;// input- the current round number	
	wire [((Nb)-1):0] nextRoundKey;// output- the next round key genereated by the key expansion module	

	Key_Expansion UUT(roundKey,roundNumber,nextRoundKey);// instantiation of the Key_Expansion module

	initial
		begin
			roundKey=128'h5468617473206D79204B756E67204675; roundNumber=4'd1;// initial input values
			$monitor($time,"roundKey=%h,roundNumber=%d,nextRoundKey=%h",roundKey,roundNumber,nextRoundKey);// System monitoring function
		end

	initial
		begin
			// checking the next round key generation for each round, according to the list below
			#1 roundKey=128'hE232FCF191129188B159E4E6D679A293; roundNumber=4'd2;
			#1 roundKey=128'h56082007C71AB18F76435569A03AF7FA; roundNumber=4'd3;
			#1 roundKey=128'hD2600DE7157ABC686339E901C3031EFB; roundNumber=4'd4;
			#1 roundKey=128'hA11202C9B468BEA1D75157A01452495B; roundNumber=4'd5;
			#1 roundKey=128'hB1293B3305418592D210D232C6429B69; roundNumber=4'd6;
			#1 roundKey=128'hBD3DC287B87C47156A6C9527AC2E0E4E; roundNumber=4'd7;
			#1 roundKey=128'hCC96ED1674EAAA031E863F24B2A8316A; roundNumber=4'd8;
			#1 roundKey=128'h8E51EF21FABB4522E43D7A0656954B6C; roundNumber=4'd9;
			#1 roundKey=128'hBFE2BF904559FAB2A16480B4F7F1CBD8; roundNumber=4'd10;
			#1 $finish;// system function - end simulation run			
		end

endmodule

// the list from the AES-example file:
// (round0-the initial key) roundKey=128'h5468617473206D79204B756E67204675;// input for round no. 1
// (round1) roundKey=128'hE232FCF191129188B159E4E6D679A293;// output of round no. 1, input for round no. 2
// (round2) roundKey=128'h56082007C71AB18F76435569A03AF7FA;// output of round no. 2, input for round no. 3
// (round3) roundKey=128'hD2600DE7157ABC686339E901C3031EFB;// output of round no. 3, input for round no. 4
// (round4) roundKey=128'hA11202C9B468BEA1D75157A01452495B;// output of round no. 4, input for round no. 5
// (round5) roundKey=128'hB1293B3305418592D210D232C6429B69;// output of round no. 5, input for round no. 6
// (round6) roundKey=128'hBD3DC287B87C47156A6C9527AC2E0E4E;// output of round no. 6, input for round no. 7
// (round7) roundKey=128'hCC96ED1674EAAA031E863F24B2A8316A;// output of round no. 7, input for round no. 8
// (round8) roundKey=128'h8E51EF21FABB4522E43D7A0656954B6C;// output of round no. 8, input for round no. 9
// (round9) roundKey=128'hBFE2BF904559FAB2A16480B4F7F1CBD8;// output of round no. 9, input for round no. 10
// (round10-the final key) roundKey=128'h28FDDEF86DA4244ACCC0A4FE3B316F26;// output of round no. 10
