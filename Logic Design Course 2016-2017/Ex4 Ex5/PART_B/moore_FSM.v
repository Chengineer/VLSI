/* Chen Grapel Logic Design Course Exercise 4+5 (part B): moore FSM. Filename:moore_FSM.v */

`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution


module MooreFSM (x,clk,nrst,y);// module name and ports list
	
	//input ports:
	input x;
	input clk;
	input nrst;
	//output port:
	output reg y;
	// inner registers:
	reg [1:0] state;
	reg [1:0] next_state;
	
	// sequential block- define the state registers
	always @(posedge clk or negedge nrst) begin
		if(!nrst)
			state<=2'b00;
		else
			state<=next_state;
	end
	
	// combinational block- compute the nest state
	always @(*) begin
		case(state)
			2'b00: begin
				next_state=(x)?2'b01:2'b00;
			end
			2'b01: begin
				next_state=(x)?2'b10:2'b00;
			end
			2'b10: begin
				next_state=(x)?2'b00:2'b11;
			end
			2'b11: begin
				next_state=(x)?2'b00:2'b11;
			end
			default: begin
				next_state=2'bx;
			end
		endcase
	end
	
	// combinational block- output generations
	always @(*) begin
		case(state)
			2'b00: begin
				y=1'b0;
			end
			2'b01: begin
				y=1'b0;
			end
			2'b10: begin
				y=1'b0;
			end
			2'b11: begin
				y=1'b1;
			end
			default: begin
				y=1'bz;
			end
		endcase
	end
	
endmodule
