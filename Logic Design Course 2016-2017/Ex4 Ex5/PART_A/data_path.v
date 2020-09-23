/* Chen Grapel Logic Design Course Exercise 4+5 (part A): data path. Filename: data_path.v */

`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution


module datapath (In_A,In_B,clk,Asel,Aen,Bsel,Ben,Result,B_eq_0,A_lessThan_B);// module name and ports list
	
	parameter numOfBits=5;// size of data in&out 
	localparam bits=2;// number of bits required to represent mux-A input options
	// input ports:
	input [numOfBits-1:0] In_A;// data in
	input [numOfBits-1:0] In_B;// data in
	input clk;// clock
	input [bits-1:0] Asel;// data path control
	input Aen;// data path control
	input Bsel;// data path control
	input Ben;// data path control
	// output ports:
	output [numOfBits-1:0] Result;// data out
	output B_eq_0;// data path status
	output A_lessThan_B;// data path status
	// inner signals:
	wire [numOfBits-1:0] sub_result;// subtraction result
	reg [numOfBits-1:0] d_A;// FF A input
	reg [numOfBits-1:0] d_B;// FF B input
	reg [numOfBits-1:0] q_A;// FF A output
	reg [numOfBits-1:0] q_B;// FF B output
	
	// MUX A:
	always @(*) begin
		case(Asel)
			2'd0: begin
				d_A=In_A;
			end
			2'd1: begin
				d_A=sub_result;
			end
			2'd2: begin
				d_A=q_B;
			end
			default: begin
				d_A=1'bx;
			end
		endcase
	end
	
	// MUX B:
	always @(*) begin
		case(Bsel)
			1'd0: begin
				d_B=q_A;
			end
			1'd1: begin
				d_B=In_B;
			end
			default: begin
				d_B=1'bx;
			end
		endcase
	end
	
	// FF A:
	always @(posedge clk) begin
		if(Aen)
			q_A<=d_A;
	end
	
	// FF B:
	always @(posedge clk) begin
		if(Ben)
			q_B<=d_B;
	end
	

	assign B_eq_0=(!(q_B))?1'b1:1'b0;// comparator (=0)

	assign A_lessThan_B=((q_A)<(q_B))?1'b1:1'b0;// comparator (A<B)

	assign sub_result=(q_A)-(q_B);// subtractor

	assign Result=q_A;// output
	
endmodule
