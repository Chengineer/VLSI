/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: AES_cipher.v */
`timescale 1ns / 10ps// result evaluated every 1nsec with 10psec resolution
`include "SubstitutionBox.v"
`include "ShiftRows.v"
`include "MixColumns.v"
`include "KeysExp.v"

module AES_cipher(clk,Reset,key,Plain_Text,Cipher_Text);/* AES cipher module integrates the encryption sub-modules. */

	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key
	localparam NUMKEYS=10;// number of keys
	localparam CONKEYS=NUMKEYS*Nb;// number of bits of 10 concatenated keys (10*128=1280)

	input wire clk, Reset;// inputs- clock signal, reset signal
	input wire [(Nb-1):0] key, Plain_Text;// inputs- the initial key, the plain text to be encrypted
	output reg [(Nb-1):0] Cipher_Text;// output- the encrypted plain text

	reg [(Nb-1):0] keyReg;// inner register- key for calculating the current encryption
	reg [(Nb-1):0] PlainTextReg;// inner register- text for calculating the current encryption
	wire [(Nb-1):0] SubBoxI [(NUMKEYS-1):0];// inner wire bus- for linking between the rounds
	wire [(Nb-1):0] SubBoxO [8:0];// inner wire- for connecting the sub units to the shift unit in all the rounds
	wire [(Nb-1):0] ShiftRO [8:0];// inner wire- for connecting the shift units to the mix unit in all the rounds
	wire [(Nb-1):0] MixColO [8:0];// inner wire- for connecting the mix units to the add-round-key unit in all the rounds
	wire [(CONKEYS-1):0] expandedKs;// inner wire- containing all the round keys
	wire [(Nb-1):0] PreRTin, PreRTk, PreRTout;// inner wires- as the ports of the add-round-key unit before the rounds start
	wire [(Nb-1):0] PostSBin, PostSBout;// inner wires- as the ports of the substitution unit on the last round
	wire [(Nb-1):0] PostSRin, PostSRout;// inner wires- as the ports of the shift unit on the last round
	wire [(Nb-1):0] PostRTin, PostRTk, PostRTout;// inner wires- as the ports of the add-round-key unit on the last round

	// sub-modules instantiation
	ARK PreRT(PreRTin,PreRTk,PreRTout);/* PreRTin,PreRTk -> ARK input..ARK operation..ARK output -> PreRTout */
	SubstitutionBox PostSB(PostSBin,PostSBout);/* PostSBin -> SubstitutionBox input..SubstitutionBox operation..SubstitutionBox output -> PostSBout */
	ShiftRows PostSR(PostSRin,PostSRout);/* PostSRin -> ShiftRows input..ShiftRows operation..ShiftRows output -> PostSRout */
	ARK PostRT(PostRTin,PostRTk,PostRTout);/* PostRTin,PostRTk -> ARK input..ARK operation..ARK output -> PostRTout */
	KeysExp Kexp(PreRTk,expandedKs);/* PreRTk -> KeysExp input..KeysExp operation..KeysExp output -> expandedKs */
	
	always @(posedge clk)
		begin
			PlainTextReg=Plain_Text;// updating the plain text input register
			keyReg=key;// updating the key input register
			if(Reset)
				Cipher_Text=128'b0;// reset the output in a case of, well, reset
			else
				Cipher_Text=PostRTout;// updating the cipher text input register
		end

	assign PreRTin=PlainTextReg;// send the text to start being encrypted
	assign PreRTk=keyReg;// send the key to start encrypt with
	assign SubBoxI[0]=PreRTout;//

	genvar j;
	generate 
		for (j=0; j<(NUMKEYS-1); j=j+1)// all the rounds:
			begin: Round
				SubstitutionBox gSB(.in(SubBoxI[j]),.out(SubBoxO[j]));//
				ShiftRows gSR(.in(SubBoxO[j]),.out(ShiftRO[j]));//
				MixColumns gMC(.in(ShiftRO[j]),.out(MixColO[j]));//
				ARK gARK(.in(MixColO[j]),.k(expandedKs[j*(Nb)+(Nb-1):j*(Nb)]),.out(SubBoxI[j+1]));//
			end 
	endgenerate

	assign PostSBin=SubBoxI[(NUMKEYS-1)];// link from the identical rounds to the last rather different one
	assign PostSRin=PostSBout;// after last substitution
	assign PostRTin=PostSRout;// after last shift-row
	assign PostRTk=expandedKs[(CONKEYS-1):(CONKEYS-Nb)];// after last round - the final result

endmodule

module ARK(in,k,out);/* Add Round Key module adds a round key to the state by a simple bitwise XOR operation.  */

	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key

	input [(Nb-1):0] in,k;// inputs- the state and the round key 
	output [(Nb-1):0] out;// output- add round key result

	assign out=in^k;// add a round key to the state, and assign the result into "out" 

endmodule
