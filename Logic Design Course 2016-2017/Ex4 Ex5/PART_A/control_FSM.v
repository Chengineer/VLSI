/* Chen Grapel Logic Design Course Exercise 4+5 (part A): control FSM. Filename:control_FSM.v */

`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution


module controlFSM (In_ready,B_eq_0,A_lessThan_B,Result_taken,clk,nrst,Asel,Aen,Bsel,Ben);// module name and ports list
	
	localparam bits=2;// number of bits required to represent 3 states, and mux-A input options
	// state encoding:
	localparam IDLE=2'd0;
	localparam COMPUTE=2'd1;
	localparam DONE=2'd2;
	// input ports:
	input In_ready;// external control
	input B_eq_0;// data path status
	input A_lessThan_B;// data path status
	input Result_taken;// external control
	input clk;// clock
	input nrst;// external control
	// output ports:
	output reg [bits-1:0] Asel;// data path control
	output reg Aen;// data path control
	output reg Bsel;// data path control
	output reg Ben;// data path control
	// inner signals:
	reg [bits-1:0] state;
	reg [bits-1:0] next_state;
	
	// sequential block- define the state registers
	always @(posedge clk or negedge nrst) begin
		if(!nrst)
			state<=IDLE;
		else
			state<=next_state;
	end
	
	// combinational block- compute the nest state
	always @(*) begin
		next_state=IDLE;// default assignment
		case(state)
			IDLE: begin
				next_state=(In_ready)?COMPUTE:IDLE;
			end
			COMPUTE: begin
				next_state=(B_eq_0)?DONE:COMPUTE;
			end
			DONE: begin
				next_state=(Result_taken)?IDLE:DONE;
			end
			default: begin
				next_state=2'bx;
			end
		endcase
	end
	
	// combinational block- output generations
	always @(*) begin
		Asel=2'd0;// default assignment
		Bsel=1'd1;// default assignment
		Aen=1'b0;// default assignment
		Ben=1'b0;// default assignment
		case(state)
			IDLE: begin
				Asel=2'd0;// muxA:In_A
				Bsel=1'd1;// muxB:In_B
				if(In_ready) begin// enable FFs
					Aen=1'b1;
					Ben=1'b1;
				end	
				else begin// disable FFs
					Aen=1'b0;
					Ben=1'b0;
				end
			end
			COMPUTE: begin
				if(!B_eq_0) begin
					if(A_lessThan_B) begin// swap A and B
						Asel=2'd2;// muxA:q_B
						Bsel=1'd0;// muxB:q_A
						Aen=1'b1;// enable A FF
						Ben=1'b1;// enable B FF
					end
					else begin// A=A-B
						Asel=2'd1;// muxA:sub_result
						Aen=1'b1;// enable A FF
						Ben=1'b0;// disable B FF
					end
				end
				else if(B_eq_0) begin// disable FFs
					Aen=1'b0;
					Ben=1'b0;
				end
			end
			DONE: begin// disable FFs
				Aen=1'b0;
				Ben=1'b0;
			end
			default: begin
				$display("%t: State machine not initialized\n",$time);// display message
			end
		endcase	
	end
	
endmodule
