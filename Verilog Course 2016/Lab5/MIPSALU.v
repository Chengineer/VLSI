/* Chen Grapel. Verilog Course Exercise 5:MIPS ALU . Filename: MIPSALU.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module MIPS_ALU(in1,in2,InstC,ALUop,result,br_taken);// module name and ports list

parameter inoutLength=32;// define number of bits for the inputs and the result
parameter opLength=4;// define number of bits for the opcode field
// signed operations
parameter Addi=4'b0000;// (arithmetic) add immediate: result=in1+InstC
parameter sub=4'b0001;// (arithmetic) subtract: result=in1-in2
parameter beq=4'b0010;// (conditional branch) branch if in1==in2: result=InstC
parameter bne=4'b0011;// (conditional branch) branch if not in1!=in2: result=InstC
// unsigned operations
parameter lw=4'b0100;// (data transfer) load word: result=in1+InstC
parameter sw=4'b0101;// (data transfer) store word: result=in1+InstC
parameter AND=4'b0110;// (logical) AND: result=in1&in2
parameter ANDi=4'b0111;// (logical) AND immediate: result=in1&InstC
parameter XOR=4'b1000;// (logical) XOR: result=in1^in2
parameter slt=4'b1001;// (logical) set less than: result=(in1<in2)
parameter slti=4'b1010;// (logical) set less than immediate: result=(in1<in3)
parameter NOP=4'b1011;// no operation: 32-bit zeros
// in/out:
input wire signed [inoutLength-1:0] in1,in2,InstC;// input port- 32-bit data in
input wire [opLength-1:0] ALUop;// input port- 5-bit address
output wire [inoutLength-1:0] result;// output port- 32-bit data out for read operation
output wire br_taken;// output port- branch taken flag

// implementing a combinational ALUop unit
assign result=
	(ALUop==Addi)?(in1+InstC):
	(ALUop==sub)?(in1-in2):
	((ALUop==beq)&&(in1==in2))?(InstC):
	((ALUop==bne)&&(in1!=in2))?(InstC):
	(ALUop==lw)?(in1+InstC):
	(ALUop==sw)?(in1+InstC):
	(ALUop==AND)? $unsigned(in1&in2):
	(ALUop==ANDi)? $unsigned(in1&InstC):
	(ALUop==XOR)? $unsigned(in1^in2):
	(ALUop==slt)? $unsigned((in1<in2)):
	(ALUop==slti)? $unsigned((in1<InstC)):
	(32'b0);// default: NOP

assign br_taken=// if a branching has occured, branch taken flag is high 
	((ALUop==beq)&&(in1==in2))?(1'b1):
	((ALUop==bne)&&(in1!=in2))?(1'b1):
	(1'b0);
	
endmodule
