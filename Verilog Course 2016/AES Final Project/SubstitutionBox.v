/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: SubstitutionBox.v */
`include "Sbox.v" 

module SubstitutionBox(in,out);/*  applies the Sbox module to the bytes of the state array . */

	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key
	localparam BYTE=8;// one byte contains 8 bits
	localparam NBSA=16;// number of bytes in the state array	

	input [(Nb-1):0] in;// 128-bits input- the state array 
	output [(Nb-1):0] out;// 128-bits output- the state array after substitution of each byte
	
	genvar j;
	generate
		 for (j=0; j<(NBSA); j=j+1) 
			begin: substitution
				SB sub(.Byte(in[(j*(BYTE)+(BYTE-1)):j*(BYTE)]),.SubByte(out[(j*(BYTE)+(BYTE-1)):j*(BYTE)]));
				/*
				applies the Sbox (SB module) to each of the 16 bytes in the state array:
				j=0: SB sub(.Byte(in[7:0]),.SubByte(out[7:0));
				j=1: SB sub(.Byte(in[15:8]),.SubByte(out[15:8]));
				j=2: SB sub(.Byte(in[23:16]),.SubByte(out[23:16]));
				j=3: SB sub(.Byte(in[31:24]),.SubByte(out[31:24]));
				j=4: SB sub(.Byte(in[39:32]),.SubByte(out[39:32]));
				j=5: SB sub(.Byte(in[47:40]),.SubByte(out[47:40]));
				j=6: SB sub(.Byte(in[55:48]),.SubByte(out[55:48]));
				j=7: SB sub(.Byte(in[63:56]),.SubByte(out[63:56]));
				j=8: SB sub(.Byte(in[71:64]),.SubByte(out[71:64]));
				j=9: SB sub(.Byte(in[79:72]),.SubByte(out[79:72]));
				j=10: SB sub(.Byte(in[87:80]),.SubByte(out[87:80]));
				j=11: SB sub(.Byte(in[95:88]),.SubByte(out[95:88]));
				j=12: SB sub(.Byte(in[103:96]),.SubByte(out[103:96]));
				j=13: SB sub(.Byte(in[111:104]),.SubByte(out[111:104]));
				j=14: SB sub(.Byte(in[119:112]),.SubByte(out[119:112]));
				j=15: SB sub(.Byte(in[127:120]),.SubByte(out[127:120]));
				*/
			end 
	endgenerate

endmodule
