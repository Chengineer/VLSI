/* Chen Grapel. Verilog Course Exercise 7:CarLights controller Finite State Machine test bench. Filename: CarLights_tb.v */
`include "CarLights.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module CarLights_tb();

localparam nolights=3'd0;
localparam right=3'd1;
localparam left=3'd2;
localparam hazard=3'd3;
localparam brakes=3'd4;
reg [2:0] choice;
reg ignite,clk;
wire [5:0] lights;
reg [100:1] choice_msg;

CarLights UUT(choice,ignite,clk,lights);// instantiation of the FSM

initial
begin
choice=3'd0; ignite=1'd0; clk=1'd0;// initial inputs values
$monitor($time,"choice=%b,ignite=%b,clk=%b,lights=%b",choice,ignite,clk,lights);// System monitoring function
end

always @(choice)// creating choice strings in order to simplify the waveform reading
	begin
		case(choice)
			nolights: choice_msg="lights off";
			right: choice_msg="right";
			left: choice_msg="left";
			hazard: choice_msg="hazard";
			brakes: choice_msg="brakes";
		endcase
	end

// clock declaration 
always #1 clk = ~clk;// Clock cycle time = 2nSec, i.e clock frequency = 500MHz

initial// creating a waveform similar to the one shown in the exercise ppt
	begin
		#1 ignite=1'b1;// start the engine
		#4 choice=3'd1;// turn right
		#6 choice=3'd2;// turn left
		#11 choice=3'd3;// hazard before left lights finished their "routine"
		#6 choice=3'd4;// brakes 
		#3 choice=3'd1;// turn right
		#4 choice=3'd0;// lights off before right lights finished their "routine"
		#4 choice=3'd2;// turn left 
		#2 ignite=1'b0;// shut the engine
		#2 $finish;
	end

endmodule
