/* Chen Grapel Logic Design Course Exercise 2+3 (part C): ALU. Filename:PART_C.v */

`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module ALU(in1,in2,imm,sh,ALUop,result);// module name and ports list
	
	parameter InOutLength=32;
	parameter ImmediateBits=InOutLength/2;
	parameter ShiftBits=5;
	parameter ALUopBits=3;
	// decoding ALUop states
	// signed operations:
	localparam ADD=3'b000;// (arithmetic) add: result=in1+in2
	localparam SUB=3'b001;// (arithmetic) subtract: result=in1-in2
	localparam ADDI=3'b010;// (arithmetic) add immediate: result=in1+imm
	// unsigned operations:
	localparam OR=3'b011;// (logical) bitwise or: result=in1|in2
	localparam ORI=3'b100;// (logical) bitwise or immediate: result=in1|imm
	localparam SLL=3'b101;// (bitwise shift) shift left logical: result=in2<<sh
	localparam SRL=3'b110;// (bitwise shift) shift right logical: result=in2>>sh
	localparam SRA=3'b111;// (bitwise shift) shift right arithmetic: result=in2>>>sh
	
	input signed [InOutLength-1:0] in1,in2;// ALU input ports- 32-bit data-in 
	input signed [ImmediateBits-1:0] imm;// ALU input ports - 16-bit immediate
	/* ^to perform signed arithmetic, both operands must be signed */
	input [ShiftBits-1:0] sh;// ALU input ports- 5-bit shift amount
	input [ALUopBits-1:0] ALUop;// ALU input ports- 2-bit ALU Operations code
	output [InOutLength-1:0] result;// ALU output port- 32-bit computation result
	wire signed [InOutLength-1:0] ImmExt;// immediate extension

	assign ImmExt=(ALUop==ADDI)?({{16{imm[15]}},imm[15:0]}):({{16{1'b0}},imm[15:0]});/* if ALUop==ADDI imm is sign-extended, else (used only for ORI) zero-extended */
	
	assign result=
			(ALUop==ADD)?(in1+in2):
			(ALUop==SUB)?(in1-in2):
			(ALUop==ADDI)?(in1+ImmExt):
			(ALUop==OR)?$unsigned(in1|in2):
			(ALUop==ORI)?$unsigned(in1|ImmExt):
			(ALUop==SLL)?$unsigned(in2<<sh):
			(ALUop==SRL)?$unsigned(in2>>sh):
			(ALUop==SRA)?$unsigned(in2>>>sh):
			32'b0;// default=NOP
	
endmodule
