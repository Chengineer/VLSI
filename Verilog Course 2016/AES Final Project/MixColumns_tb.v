/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: MixColumns_tb.v */
`include "MixColumns.v" 

module MixColumns_tb();// MixColumns test bench module
	
	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key

	reg [(Nb-1):0] in;// inputs- the stream to mix
	wire [(Nb-1):0] out;// output- the mixed stream

	MixColumns UUT(in,out);// instantiation of the MixColumns module

	initial 
		begin
			// input value:
			in = 128'h632FAFA2EB93C7209F92ABCBA0C0302B;// corresponding expected output: BA75F47A84A48D32E88D060E1B407D5D
			
			$monitor($time,"in=%h, out=%h",in,out);// System monitoring function
			#1 $finish;// system function - end simulation run
		end

endmodule
