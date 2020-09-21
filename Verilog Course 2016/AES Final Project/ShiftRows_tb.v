/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: ShiftRows_tb.v */
`include "ShiftRows.v" 

module ShiftRows_tb();// ShiftRows test bench module
	
	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key

	reg [(Nb-1):0] in;// inputs- the rows to shift
	wire [(Nb-1):0] out;// output- the shifted rows

	ShiftRows UUT(in,out);// instantiation of the ShiftRows module

	initial 
		begin
			// input value:
			in = 128'h63C0AB20EB2F30CB9F93AF2BA092C7A2;// corresponding expected output: 632FAFA2EB93C7209F92ABCBA0C0302B
			
			$monitor($time,"in=%h, out=%h",in,out);// System monitoring function
			#1 $finish;// system function - end simulation run
		end

endmodule
