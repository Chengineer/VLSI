/* Chen Grapel, Guy Marcus, Verilog Course Final Project: AES implementation. Filename: SubstitutionBox_tb.v */
`include "SubstitutionBox.v" 

module SubstitutionBox_tb();// SubstitutionBox test bench module
	
	// parameter definition:
	localparam Nb=128;// number of bits of the data and the key

	reg [(Nb-1):0] in;// inputs- the stream to substitute
	wire [(Nb-1):0] out;// output- the substituted stream

	SubstitutionBox UUT(in,out);// instantiation of the SubstitutionBox module

	initial 
		begin
			// input value:
			in = 128'h001F0E543C4E08596E221B0B4774311A;// corresponding expected output: 63C0AB20EB2F30CB9F93AF2BA092C7A2
			
			$monitor($time,"in=%h, out=%h",in,out);// System monitoring function
			#1 $finish;// system function - end simulation run
		end

endmodule
