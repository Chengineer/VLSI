/* Chen Grapel. Verilog Course Exercise 8:OTN FAS detector, finds if and where there's a match to F628(hex). Filename: OTN_FAS_detector.v */
`include "comparator.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module OTN_FAS_detector(din,offset,match,result);// module name and ports list

localparam ZERO=16'b0000000000000001;
localparam ONE=16'b0000000000000010;
localparam TWO=16'b0000000000000100;
localparam THREE=16'b0000000000001000;
localparam FOUR=16'b0000000000010000;
localparam FIVE=16'b0000000000100000;
localparam SIX=16'b0000000001000000;
localparam SEVEN=16'b0000000010000000;
localparam EIGHT=16'b0000000100000000;
localparam NINE=16'b0000001000000000;
localparam TEN=16'b0000010000000000;
localparam ELEVEN=16'b0000100000000000;
localparam TWELVE=16'b0001000000000000;
localparam THIRTEEN=16'b0010000000000000;
localparam FOURTEEN=16'b0100000000000000;
localparam FIFTEEN=16'b1000000000000000;

input wire [31:0] din;// input port- 32-bit data in
output reg [4:0] offset;// output port- the offset of matching part selection
output reg match;// output port- match is 1 if the 
output reg [7:0] result;// output port- the result of the multiplication. in case of mismatch: high Z 
reg [15:0] detect;// inner reg
wire [16:0]equal;// inner wire 
integer j;

initial
assign detect=16'b1111011000101000;// F628

genvar i;// create an array of 16 comparators. the array index is i:
generate
	for(i=0;i<17;i=i+1)
		begin
			comparator COMP(din[(i+15):i],equal[i]);
		end
endgenerate		

always @(*)
	begin
		match= (equal!=17'b0)?1'b1:1'b0;// check if one of the comparators found F628 in din
		if(match)
			begin
				for(j=0;j<8;j=j+1)// implement the multiplication
					begin
						result[j]=(detect[j])*(detect[15-j]);/* each bit is multiplied by his "mirror bit", and the result is assigned as a bit of "result" this way: MSB*LSB->result[0], MSB-1*LSB+1->result[1]..and so on.. */
					end
				case(equal)// check the offset value using the localparams 
					ZERO:
						offset=5'd0;
					ONE:
						offset=5'd1;
					TWO:
						offset=5'd2;
					THREE:
						offset=5'd3;
					FOUR:
						offset=5'd4;
					FIVE:
						offset=5'd5;
					SIX:
						offset=5'd6;
					SEVEN:
						offset=5'd7;
					EIGHT:
						offset=5'd8;
					NINE:
						offset=5'd9;
					TEN:
						offset=5'd10;
					ELEVEN:
						offset=5'd11;
					TWELVE:
						offset=5'd12;
					THIRTEEN:
						offset=5'd13;
					FOURTEEN:
						offset=5'd14;
					FIFTEEN:
						offset=5'd15;
				endcase
			end
		else
			begin
				result=8'bZ;// result is shown only if a match has been detected
				offset=5'bZ;// offset is shown only if a match has been detected
			end
	end

endmodule
