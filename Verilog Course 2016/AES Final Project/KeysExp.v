/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: KeysExp.v */
`include "keyExpansion.v"

module KeysExp(cipherK,AllRoundKeys);/* KeysExp module creates a vector which contains the concatenation of all generated round keys. */

	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key
	localparam NUMKEYS=10;// number of keys and rounds
	localparam CONKEYS=NUMKEYS*Nb;// number of bits of 10 concatenated keys (10*128=1280)

	input [(Nb-1):0] cipherK;// input- the initial key
	output [(CONKEYS-1):0] AllRoundKeys;// output- all generated round keys concatenated
	
	wire [3:0] rndN [(NUMKEYS-1):0];// inner wire- 10 rounds that each is represented by 4 bits

	assign rndN[0] = 4'b0001;// the first round
	Key_Expansion firstRK(.roundKey(cipherK),.roundNumber(rndN[0]),.nextRoundKey(AllRoundKeys[(Nb-1):0]));// generate the first round key, and assign into the first 128-bits of AllRoundKeys
	// Key_Expansion firstRK(.roundKey(cipherK),.roundNumber(rndN[0]),.nextRoundKey(AllRoundKeys[127:0])); 

	genvar j;
	generate 
		for (j=0; j<(NUMKEYS-1); j=j+1)
			begin: roundKey
				assign rndN[j+1] = j+2;
				Key_Expansion rk(.roundKey(AllRoundKeys[(j*Nb+(Nb-1)):(j*Nb)]),.roundNumber(rndN[j+1]),.nextRoundKey(AllRoundKeys[(j*Nb+((2*Nb)-1)):(j*Nb+Nb)]));
			end 
			/*
			generate the 2 to 10 round keys,and assign into the corresponding part-selection of AllRoundKeys:
			j=0: assign rndN[1] = 2;
				Key_Expansion rk(.roundKey(AllRoundKeys[127:0]),.roundNumber(rndN[1]),.nextRoundKey(AllRoundKeys[255:128]));
			j=1: assign rndN[2] = 3;
				Key_Expansion rk(.roundKey(AllRoundKeys[255:128]),.roundNumber(rndN[2]),.nextRoundKey(AllRoundKeys[383:256]));
			j=2: assign rndN[3] = 4;
				Key_Expansion rk(.roundKey(AllRoundKeys[383:256]),.roundNumber(rndN[3]),.nextRoundKey(AllRoundKeys[511:384]));
			j=3: assign rndN[4] = 5;
				Key_Expansion rk(.roundKey(AllRoundKeys[511:384]),.roundNumber(rndN[4]),.nextRoundKey(AllRoundKeys[639:512]));
			j=4: assign rndN[5] = 6;
				Key_Expansion rk(.roundKey(AllRoundKeys[639:512]),.roundNumber(rndN[5]),.nextRoundKey(AllRoundKeys[767:640]));
			j=5: assign rndN[6] = 7;
				Key_Expansion rk(.roundKey(AllRoundKeys[767:640]),.roundNumber(rndN[6]),.nextRoundKey(AllRoundKeys[895:768]));
			j=6: assign rndN[7] = 8;
				Key_Expansion rk(.roundKey(AllRoundKeys[895:768]),.roundNumber(rndN[7]),.nextRoundKey(AllRoundKeys[1023:896]));
			j=7: assign rndN[8] = 9;
				Key_Expansion rk(.roundKey(AllRoundKeys[1023:896]),.roundNumber(rndN[8]),.nextRoundKey(AllRoundKeys[1151:1024]));
			j=8: assign rndN[9] = 10;
				Key_Expansion rk(.roundKey(AllRoundKeys[1151:1024]),.roundNumber(rndN[9]),.nextRoundKey(AllRoundKeys[1279:1152]));
			*/
	endgenerate

endmodule
