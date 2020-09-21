/* Chen Grapel. Verilog Course Exercise 8: 16-bit comparator . Filename: comparator.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module comparator(din,equal);// module name and ports list

input wire [15:0] din;// input port - data in
output reg equal;// output port- if data in is equal to F628(hex), equal is 1, else 0

always @(*)// the implementation
	begin
		if(din==16'hF628)
			equal=1'b1;
		else
			equal=1'b0;
	end

endmodule
