/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: ShiftRows.v */

module ShiftRows(in,out);/* Shift rows module cyclically shifts the last three rows of the state array by different offsets (no. of bytes) . */

	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key

	input wire [(Nb-1):0] in;// 128-bits input- the state array
	output reg [(Nb-1):0] out;// 128-bits output- the shifted input state array

	always @(*)
		begin
			// create the LSB word (right column of the shifted array) 
			out[7:0]=in[39:32];// fourth row is shifted by 3 bytes
			out[15:8]=in[79:72];// third row is shifted by 2 bytes
			out[23:16]=in[119:112];// second row is shifted byone byte
			out[31:24]=in[31:24];// first row is not shifted

			// create the LSB+1 word (second right column of the shifted array)
			out[39:32]=in[71:64];// fourth row is shifted by 3 bytes
			out[47:40]=in[111:104];// third row is shifted by 2 bytes
			out[55:48]=in[23:16];// second row is shifted by one byte
			out[63:56]=in[63:56];// first row is not shifted

			// create the MSB-1 word (second left column of the shifted array)
			out[71:64]=in[103:96];// fourth row is shifted by 3 bytes
			out[79:72]=in[15:8];// third row is shifted by 2 bytes
			out[87:80]=in[55:48];// second row is shifted by one byte
			out[95:88]=in[95:88];// first row is not shifted

			// create the MSB word (left column of the output array)
			out[103:96]=in[7:0];// fourth row is shifted by 3 bytes
			out[111:104]=in[47:40];// third row is shifted by 2 bytes
			out[119:112]=in[87:80];// second row is shifted by one byte
			out[127:120]=in[127:120];// first row is not shifted
		end

endmodule
