/* Chen Grapel. Verilog Course Exercise 8:OTN FAS detector test bench. Filename: OTN_FAS_detector_tb.v */
`include "OTN_FAS_detector.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module OTN_FAS_detector_tb();

reg [31:0] din;
wire[4:0] offset;
wire match;
wire [7:0] result; 

OTN_FAS_detector UUT(din,offset,match,result);// instantiation of the detector module

initial
begin
din=32'b0; // initial input value
$monitor($time,"din=%h,offset=%d,match=%b,result=%h",din,offset,match,result);// System monitoring function
end

initial// changing the input in order to check the module operation
	begin
		#2 din=32'h777F628;
		#2 din=32'h0;
		#2 din=32'h123A321;
		#2 din=32'hF628A53;
		#2 din=32'hD552130;
		#2 din=32'hFF628F0;
		#2 din=32'h1236287;
		#2 $finish;
	end

endmodule
