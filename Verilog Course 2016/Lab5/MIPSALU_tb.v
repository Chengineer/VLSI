/* Chen Grapel. Verilog Course Exercise 5:MIPS ALU test bench . Filename: MIPSALU_tb.v */
`include "MIPSALU.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module MIPS_ALU_tb();// module name and ports list

parameter inoutLength=32;
parameter opLength=4;
// signed operations
parameter Addi=4'b0000;// 0 
parameter sub=4'b0001;// 1
parameter beq=4'b0010;// 2
parameter bne=4'b0011;// 3
// unsigned operations
parameter lw=4'b0100;// 4
parameter sw=4'b0101;// 5
parameter AND=4'b0110;// 6
parameter ANDi=4'b0111;// 7
parameter XOR=4'b1000;// 8
parameter slt=4'b1001;// 9
parameter slti=4'b1010;// 10
parameter NOP=4'b1011;// 11
reg [inoutLength-1:0] in1,in2,InstC;
reg [opLength-1:0] ALUop;
wire [inoutLength-1:0] result;
wire br_taken;
reg [500:1] ALU_msg;
integer i;

MIPS_ALU UUT(in1,in2,InstC,ALUop,result,br_taken);// instantiation of the DataRAM1

initial
	begin
		in1=32'b0; in2=32'b0; InstC=32'b0; ALUop=4'b0;// initial input values
		$monitor($time,"in1=%b,in2=%b,InstC=%b,ALUop=%b,result=%b,br_taken=%b",in1,in2,InstC,ALUop,result,br_taken);// System monitoring function
	end

always @(ALUop)
	begin
		case(ALUop)
			Addi: ALU_msg="Addi";
			sub: ALU_msg="sub";
			beq: ALU_msg="beq";
			bne: ALU_msg="bne";
			lw: ALU_msg="lw";
			sw: ALU_msg="sw";
			AND: ALU_msg="AND";
			ANDi: ALU_msg="ANDi";
			XOR: ALU_msg="XOR";
			slt: ALU_msg="slt";
			slti: ALU_msg="slti";
			NOP: ALU_msg="NOP";
		endcase
	end

initial
	begin
		#2 ALUop=4'd3;
		#2 in1=32'd105; in2=32'd34; InstC=32'd318;
     		#2 ALUop=4'd14;//
     		for(i=0;i<12;i=i+1)
			begin
				ALUop=i;
				#2;
			end
		#2 in1=32'd5; in2=32'd5; 
		#2 ALUop=4'd3; 
		#2 ALUop=4'd2;
		#2 $finish;
	end

endmodule


