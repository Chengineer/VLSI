/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: AES_cipher_tb.v */
`include "AES_cipher.v" 

module AES_cipher_tb();// AES cipher test bench module
	
	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key

	reg clk, Reset;// inputs- clock and reset
	reg [(Nb-1):0] key, Plain_Text;// inputs- the initial key, and the plain text to be encrypted
	wire [(Nb-1):0] Cipher_Text;// output- the encrypted plain text

	AES_cipher UUT(clk, Reset, key, Plain_Text, Cipher_Text);// instantiation of the AES_cipher module

	always #1 clk = ~clk;// clock generation. cycle time = 2nSec, i.e clock frequency = 500MHz

	initial 
		begin
			// initial input values:
			clk = 1;
		    Reset = 0;
			key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
			Plain_Text = 128'h3243f6a8885a308d313198a2e0370734;

			$monitor($time,"clk=%b, Reset=%b, key=%h, Plain_Text=%h, Cipher_Text=%h",clk,Reset,key,Plain_Text,Cipher_Text);// System monitoring function
		end
	initial
		begin
			#3 key = 128'h000102030405060708090a0b0c0d0e0f;	Plain_Text = 128'h00112233445566778899aabbccddeeff;// the second test
			#5 Reset = 1;
			#2 $finish;// system function - end simulation run
		end 

endmodule
