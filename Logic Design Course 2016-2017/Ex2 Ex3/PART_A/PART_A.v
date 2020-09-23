/* Chen Grapel Logic Design Course Exercise 2+3 (part A): 16 to 1 MUX. Filename:PART_A.v */

`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution
`include "SEC1_C.v"

module Mux #(parameter NUM_LEVELS = 5, WIDTH = 2**(NUM_LEVELS-1))(input [(WIDTH-1):0] in, input [(NUM_LEVELS-2):0] sel, output out);// module name and ports list
	
	genvar i,j;

	generate
	
	// start at the lowest level in the tree
	for(i=0; i<4; i=i+1) begin:gen_levels// i runs on 
		// do nodes at each level
		for(j=0; j<(2**(3-i)); j=j+1) begin:gen_nodes // j runs on the number of 2to1 muxes required at each stage
			// inner wires (2to1 mux):
			wire in_low;// the 0 input of a 2to1 mux
			wire in_high;// the 1 input of a 2to1 mux
			wire out_int;// the output of a 2to1 mux
	
			// at the lowest level, use the module's inputs
			if(i==0) begin
				assign in_low=in[2*j];
				assign in_high=in[2*j+1];
			end
			//otherwise, use the outputs of the lower level
			else begin
				//hierarchical naming
				assign in_low=gen_levels[i-1].gen_nodes[2*j].out_int;
				assign in_high=gen_levels[i-1].gen_nodes[2*j+1].out_int;
			end
			//instantiate the MUX2 module (from exercise 1) with new parameter value: WIDTH=1
			mux8_2C #(1) mux(.a(in_high),.b(in_low),.sel(sel[i]),.out(out_int));
		end
	end
	
	endgenerate

	//output assignment- hierarchical naming of the highest level
	assign out=gen_levels[(NUM_LEVELS-2)].gen_nodes[0].out_int;
	
endmodule
