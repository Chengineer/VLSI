/* Chen Grapel Logic Design Course Exercise 4+5 (part A): control FSM test bench. Filename: control_FSM_TB.v */

`include "control_FSM.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module controlFSM_tb();

	localparam bits=2;
	localparam IDLE=2'd0;
	localparam COMPUTE=2'd1;
	localparam DONE=2'd2;	
	reg In_ready;
	reg B_eq_0;
	reg A_lessThan_B;
	reg Result_taken;
	reg clk;
	reg nrst;
	wire [bits-1:0] Asel;
	wire Aen;
	wire Bsel;
	wire Ben;
	reg [500:1] State_msg;

	controlFSM UUT(.In_ready(In_ready),.B_eq_0(B_eq_0),.A_lessThan_B(A_lessThan_B),.Result_taken(Result_taken),.clk(clk),.nrst(nrst),.Asel(Asel),.Aen(Aen),.Bsel(Bsel),.Ben(Ben));// instantiation of the Mux module

	initial
		begin
			In_ready=1'b0;B_eq_0=1'b0;A_lessThan_B=1'b0;Result_taken=1'b0;clk=1'b0;nrst=1'b1;// initial input values
			$monitor($time,"In_ready=%b,B_eq_0=%b,A_lessThan_B=%b,Result_taken=%b,clk=%b,nrst=%b,Asel=%d,Aen=%b,Bsel=%b,Ben=%b",In_ready,B_eq_0,A_lessThan_B,Result_taken,clk,nrst,Asel,Aen,Bsel,Ben);// System monitoring function
		end

	always @(UUT.state) begin/* creating state strings in order to simplify the waveform reading. since state is an inner signal defined in the module, access it using dot operator */
		case(UUT.state)
			IDLE: State_msg="IDLE";
			COMPUTE: State_msg="COMPUTE";
			DONE: State_msg="DONE";
		endcase
	end

	always #1 clk=~clk;// clock generation

	initial 
		begin
			#1 nrst=1'b0;
			#2 nrst=1'b1;
			#2 In_ready=1'b1;
			#2 In_ready=1'b0;
			#2 A_lessThan_B=1'b1;
			#2 A_lessThan_B=1'b0;
			#1 A_lessThan_B=1'b1; B_eq_0=1'b1;
			#2 Result_taken=1'b1;
			#2 Result_taken=1'b0;
			#0.5 In_ready=1'b1;
			#2 In_ready=1'b1; B_eq_0=1'b0;
			#2 A_lessThan_B=1'b0;
			#2 nrst=1'b0;
			#2 $finish;// System function - end simulation run    
		end

endmodule
