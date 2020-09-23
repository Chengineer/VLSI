/* Chen Grapel Logic Design Course Exercise 4+5 (part A): top level test bench. Filename: top_level_TB.v */

`include "top_level.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module toplevel_tb();

	localparam IDLE=2'd0;
	localparam COMPUTE=2'd1;
	localparam DONE=2'd2;	
	parameter numOfBits=5;
	reg [numOfBits-1:0] In_A;
	reg [numOfBits-1:0] In_B;
	reg Clk;
	reg nrst;
	reg In_ready;
	reg Result_taken;
	wire [numOfBits-1:0] Result;
	reg [500:1] State_msg;
	
	toplevel UUT(.In_A(In_A),.In_B(In_B),.Clk(Clk),.nrst(nrst),.In_ready(In_ready),.Result_taken(Result_taken),.Result(Result));// instantiation of the toplevel module

	initial
		begin
			In_A=5'd0;In_B=5'd0;Clk=1'b0;nrst=1'b1;In_ready=1'b0;Result_taken=1'b0;// initial input values
			$monitor($time,"In_A=%d,In_B=%d,Clk=%b,nrst=%b,In_ready=%b,Result_taken=%b,Result=%d",In_A,In_B,Clk,nrst,In_ready,Result_taken,Result);// System monitoring function
		end

	always @(UUT.Control.state) begin/* creating state strings in order to simplify the waveform reading. since state is an inner signal defined in the module, access it using dot operator */
		case(UUT.Control.state)
			IDLE: State_msg="IDLE";
			COMPUTE: State_msg="COMPUTE";
			DONE: State_msg="DONE";
		endcase
	end

	always #1 Clk=~Clk;// clock generation	
	
	always @(In_A or In_B) begin// rise In_ready when there is a new pair of numbers in the data-in inputs
		#1 In_ready=1'b1;
	end
	
	always @(UUT.Control.state) begin// rise Result_taken when in DONE state to indicate that the current result is the GCD of the data-in inputs
		if(UUT.Control.state==DONE)
			Result_taken=1'b1;
		else
			Result_taken=1'b0;
		if(UUT.Control.state==COMPUTE)
			#1 In_ready=1'b0;
	end
		
	initial 
		begin
			#0.5 nrst=1'b0;
			#2 nrst=1'b1;
			#2 In_A=5'd6;In_B=5'd3;
			#16 In_A=5'd2; In_B=5'd7;
			#30 In_A=5'd30; In_B=5'd20;
			#18 In_A=5'd5;In_B=5'd10;
			#16 In_A=5'd3;In_B=5'd21;
			#16 In_A=5'd11;In_B=5'd11;
			#16 In_A=5'd28;In_B=5'd0;
			#16 In_A=5'd4;In_B=5'd2;
			#4 nrst=1'b0;
			#3 $finish;// System function - end simulation run    
		end

endmodule
