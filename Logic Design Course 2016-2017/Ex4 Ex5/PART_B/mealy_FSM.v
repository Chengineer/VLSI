/* Chen Grapel Logic Design Course Exercise 4+5 (part B): control FSM. Filename: mealy_FSM.v */

`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution


module MealyFSM (x,clk,nrst,y);// module name and ports list

	//input ports:
	input x;
	input clk;
	input nrst;
	//output port:
	output reg y;
	// inner register:
	reg [1:0] state;
	
	// sequential block- define the state registers and the output
	always @(posedge clk or negedge nrst) begin
		if(!nrst)
			{state,y}<=3'b000;
		else begin
			case(state)
				2'b00: begin
					{state,y}<=(x)?3'b010:3'b000;
				end
				2'b01: begin
					{state,y}<=(x)?3'b100:3'b000;
				end
				2'b10: begin
					{state,y}<=(x)?3'b000:3'b111;
				end
				2'b11: begin
					{state,y}<=(x)?3'b000:3'b111;
				end
				default: begin
					{state,y}<=3'bxxz;
				end
			endcase
		end
	end
	
endmodule
