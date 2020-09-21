/* Chen Grapel. Verilog Course Exercise 6: Finite State Machine test bench. Filename: Garage_Door_tb.v */
`include "Garage_Door.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module Garage_Door_tb();

parameter idle=2'b00; 
parameter movingUp=2'b01;
parameter movingDn=2'b10;
reg up_limit,dn_limit,activate,clk,nrst;
wire motor_up,motor_dn;
reg [500:1] State_msg;

Garage_Door UUT(up_limit,dn_limit,activate,clk,nrst,motor_up,motor_dn);// instantiation of the Garage_Door

initial
begin
up_limit=1'b0; dn_limit=1'b1; activate=1'b0; clk=1'b0; nrst=1'b1;// initial inputs values
$monitor($time,"up_limit=%b,dn_limit=%b,activate=%b,clk=%b,nrst=%b,motor_up=%b,motor_dn=%b",up_limit,dn_limit,activate,clk,nrst,motor_up,motor_dn);// System monitoring function
end

always @(UUT.state)/* creating state strings in order to simplify the waveform reading. since state is an inner signal defined in the module, access it using dot operator */
	begin
		case(UUT.state)
			idle: State_msg="idle";
			movingUp: State_msg="moving UP";
			movingDn: State_msg="moving DOWN";
		endcase
	end

// clock declaration 
always #1 clk = ~clk;// Clock cycle time = 2nSec, i.e clock frequency = 500MHz

initial// creating a waveform similar to the one shown in the exercise ppt
	begin
		#2 nrst=1'b0;
		#2 nrst=1'b1;
		#2 activate=1'b1; 
		#2 activate=1'b0; dn_limit=1'b0;
		#10 up_limit=1'b1; 
		#2 activate=1'b1;
		#2 up_limit=1'b0; activate=1'b0;
		#10 dn_limit=1'b1; 
		#4 nrst=1'b0;
		#4 $finish;
	end

endmodule
