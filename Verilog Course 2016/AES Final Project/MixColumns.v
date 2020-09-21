/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: MixColumns.v */

module MixColumns(in,out);/* mix columns module replaces each byte of a column by two times that byte, plus three times the next byte, plus the byte that comes next, plus the byte that follows. */

	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key
	localparam WORD=32;// one word contains 32 bits
	localparam Nc=4;// number of columns
	localparam BYTE=8;// One byte contains 8 bits

	input [(Nb-1):0] in;// input- the state array
	output [(Nb-1):0] out;// output- the state array after mixing all columns

	genvar j;
	generate 
		for (j=0; j<Nc; j=j+1)
			begin: mixing
				MC mix(.c(in[j*WORD+(WORD-1):j*WORD]),.mc(out[j*WORD+(WORD-1):j*WORD]));
				/*
				apply MC module to each of the 4 columns:
				j=0: MC mix(.c(in[31:0]),.mc(out[31:0])); // right column
				j=1: MC mix(.c(in[63:32]),.mc(out[63:32])); // second right column
				j=2: MC mix(.c(in[95:64]),.mc(out[95:64])); // second left column 
				j=3: MC mix(.c(in[127:96]),.mc(out[127:96])); // left column
				*/
			end 
	endgenerate

endmodule

module MC(c,mc);

	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key
	localparam WORD=32;// one word contains 32 bits 	
	localparam BYTE=8;// one byte contains 8 bits
	localparam BYTESPERWORD=4;// one word contains 4 bytes

	input [(WORD-1):0] c;// input- one column	
	output reg [(WORD-1):0] mc;// output- the input column after mixing

	reg [(WORD-1):0] d;// inner register- a column which is a concatenation of multiplied bytes

	genvar j;
	generate 
		for (j=0; j<BYTESPERWORD; j=j+1)
			begin: multiply
				always @(*)
					begin
						if(!c[j*BYTE+(BYTE-1)])// if the MSB of a byte is 0
							d[j*BYTE+(BYTE-1):j*BYTE]={c[j*BYTE+(BYTE-2):j*BYTE],1'b0};// shift left (multiply by 2)
						else// if the MSB of a byte is 1
							d[j*BYTE+(BYTE-1):j*BYTE]=(8'h1b)^{c[j*BYTE+(BYTE-2):j*BYTE],1'b0};// shift left, and XOR with {1B} hexa (multiply by 3)
						/*
						j=0: if(!c[7])
							d[7:0]={c[6:0],1'b0};
						     else
							d[7:0]=(8'h1b)^{c[6:0],1'b0};
						j=1: if(!c[15])
							d[15:8]={c[14:8],1'b0};
						     else
							d[15:8]=(8'h1b)^{c[14:8],1'b0};
						j=2: if(!c[23])
							d[23:16]={c[22:16],1'b0};
						     else
							d[23:16]=(8'h1b)^{c[22:16],1'b0};
						j=3: if(!c[31])
							d[31:24]={c[30:24],1'b0};
						     else
							d[31:24]=(8'h1b)^{c[30:24],1'b0};
						*/
					end
			end 
	endgenerate

	always @(*)
		begin
			mc[(WORD-1):(3*BYTE)]=d[(WORD-1):(3*BYTE)]^c[((3*BYTE)-1):(2*BYTE)]^d[((3*BYTE)-1):(2*BYTE)]^c[((2*BYTE)-1):BYTE]^c[(BYTE-1):0];
			mc[((3*BYTE)-1):(2*BYTE)]=c[(WORD-1):(3*BYTE)]^d[((3*BYTE)-1):(2*BYTE)]^c[((2*BYTE)-1):BYTE]^d[((2*BYTE)-1):BYTE]^c[(BYTE-1):0];
			mc[((2*BYTE)-1):BYTE]=c[(WORD-1):(3*BYTE)]^c[((3*BYTE)-1):(2*BYTE)]^d[((2*BYTE)-1):BYTE]^c[(BYTE-1):0]^d[(BYTE-1):0];
			mc[(BYTE-1):0]=c[(WORD-1):(3*BYTE)]^d[(WORD-1):(3*BYTE)]^c[((3*BYTE)-1):(2*BYTE)]^c[((2*BYTE)-1):BYTE]^d[(BYTE-1):0];
			/*
			the mix-columns algorithm implementation:
			mc[31:24]=d[31:24]^c[23:16]^d[23:16]^c[15:8]^c[7:0];
			mc[23:16]=c[31:24]^d[23:16]^c[15:8]^d[15:8]^c[7:0];
			mc[15:8]=c[31:24]^c[23:16]^d[15:8]^c[7:0]^d[7:0];
			mc[7:0]=c[31:24]^d[31:24]^c[23:16]^c[15:8]^d[7:0];
			These formulae derived from those provided in the task.
			*/
		end

endmodule
