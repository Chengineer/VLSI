/* Chen Grapel Logic Design Course Exercise 2+3 (part C): ALU test bench. Filename: PART_C_TB.v */

`include "PART_C.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module ALU_tb();

	parameter InOutLength=32;
	parameter ImmediateBits=InOutLength/2;
	parameter ShiftBits=5;
	parameter ALUopBits=3;
	// decoding ALUop states
	// signed operations:
	localparam ADD=3'b000;// 0
	localparam SUB=3'b001;// 1
	localparam ADDI=3'b010;// 2
	// unsigned operations:
	localparam OR=3'b011;// 3
	localparam ORI=3'b100;// 4
	localparam SLL=3'b101;// 5
	localparam SRL=3'b110;// 6
	localparam SRA=3'b111;// 7
	
	reg signed [InOutLength-1:0] In1,In2;
	reg signed [ImmediateBits-1:0] Imm;
	reg [ShiftBits-1:0] Sh;
	reg [ALUopBits-1:0] ALUop;
	wire [InOutLength-1:0] Result;
	reg [500:1] ALU_msg;// will display the current ALUop 
	integer i;

	ALU UUT(.in1(In1),.in2(In2),.imm(Imm),.sh(Sh),.ALUop(ALUop),.result(Result));// instantiation of the ALU module

	initial
		begin
			In1=32'b0; In2=32'b0; Imm=16'b0; Sh=5'b0; ALUop=SUB;// initial input values
			$monitor($time,"\nIn1=%b,\nIn2=%b,\nImm=%b,\nUUT.ImmExt=%b,\nSh=%d,\nALU_msg=%s,\nALUop=%d,\nResult=%b\n",In1,In2,Imm,UUT.ImmExt,Sh,ALU_msg,ALUop,Result);// System monitoring function
		end

	always @(ALUop)
		begin
			case(ALUop)
				ADD: ALU_msg="ADD";
				SUB: ALU_msg="SUB";
				ADDI: ALU_msg="ADDI";
				OR: ALU_msg="OR";
				ORI: ALU_msg="ORI";
				SLL: ALU_msg="SLL";
				SRL: ALU_msg="SRL";
				SRA: ALU_msg="SRA";
				default: ALU_msg="NOP";
			endcase
		end

	initial 
		begin
			#2 In1=32'sd5; In2=-32'sd3; Imm=-16'sd12; Sh=2;
	     	#2 for(i=0;i<8;i=i+1)
				begin
					ALUop=i;
					#2;
				end
				#2 $finish; 
			end

endmodule
