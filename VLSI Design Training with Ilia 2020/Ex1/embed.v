
module embed(ins,ous);		

	// bus sizing:
	localparam busSize=37;  		

	// input port:
	input [busSize-1:0] ins;		
	// output port:
	output reg [busSize-1:0] ous;		

always @* ous = ins;


endmodule
