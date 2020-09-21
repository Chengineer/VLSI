/* Chen Grapel. Verilog Course Exercise 7: CarLights controller Finite State Machine. Filename: CarLights.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module CarLights(choice,ignite,clk,lights);// module name and ports list

// coding each state (actually, "define" each state's code)
localparam nolights=3'd0;// (binary 000)
localparam right=3'd1;// (binary 001)
localparam left=3'd2;// (binary 010)
localparam hazard=3'd3;// (binary 011)
localparam brakes=3'd4;// (binary 100)
localparam right2=4'd5;// (binary 0101)
localparam right3=4'd6;// (binary 0110)
localparam left2=4'd7;// (binary 0111)
localparam left3=4'd8;// (binary 1000)
input wire [2:0] choice;// input port-the driver's choice
input wire ignite,clk;// input port - start/shut the engine, clock
output reg [5:0] lights;// output port- which bulbs are on
reg [3:0] state;// inner port

initial
	begin
		 state=4'd0;// initialize the inner port
	end


always @(posedge clk or negedge ignite)
	begin
		if(!ignite)// the engine is shutted down
			begin
				state<=nolights;
				lights<=6'b0;	
			end
		else// the engine is on
			begin
				case({state,choice})// implementing mealy FSM
					7'b0000000:// state=lights off, choice=lights off
						begin
							state<=nolights;
							lights<=6'b000000;
						end
					7'b0000001:// state=lights off, choice=turn right
						begin
							state<=right;
							lights<=6'b000100;
						end
					7'b0000010:// state=lights off, choice=turn left 
						begin
							state<=left;
							lights<=6'b001000;
						end	
					7'b0000100:// state=lights off, choice=brakes
						begin
							state<=brakes;
							lights<=6'b111111;
						end	
					7'b0000011:// state=lights off, choice=hazard
						begin
							state<=brakes;
							lights<=6'b111111;
						end		
					7'b0100100:// state=brakes, choice=brakes
						begin
							state<=brakes;
							lights<=6'b111111;
						end	
					7'b0100011:// state=brakes, choice=hazard
						begin
							state<=hazard;
							lights<=6'b000000;
						end	
					7'b0100000:// state=brakes, choice=lights off
						begin
							state<=nolights;
							lights<=6'b000000;
						end	
					7'b0100001:// state=brakes, choice=right
						begin
							state<=right;
							lights<=6'b000100;
						end			
					7'b0100010:// state=brakes, choice=left
						begin
							state<=left;
							lights<=6'b001000;
						end					
					7'b0011011:// state=hazard, choice=hazard
						begin
							state<=brakes;
							lights<=6'b111111;
						end			
					7'b0110000: //state=right3, choice=no lights
						begin
							state<=nolights;
							lights<=6'b000000;
						end
					7'b0110001: //state=right3, choice=right
						begin
							state<=right;
							lights<=6'b000100;
						end
					7'b0110010: //state=right3, choice=left
						begin
							state<=left;
							lights<=6'b001000;
						end
					7'b0110011: //state=right3, choice=hazard
						begin
							state<=brakes;
							lights<=6'b111111;
						end
					7'b0110100: //state=right3, choice=brakes
						begin
							state<=brakes;
							lights<=6'b111111;
						end
					7'b1000000: //state=left3, choice=no lights
						begin
							state<=nolights;
							lights<=6'b000000;
						end
					7'b1000010: //state=left3, choice=left
						begin
							state<=left;
							lights<=6'b001000;
						end
					7'b1000001: //state=left3, choice=right
						begin
							state<=right;
							lights<=6'b000100;
						end
					7'b1000011: //state=left3, choice=hazard
						begin
							state<=brakes;
							lights<=6'b111111;
						end
					7'b1000100: //state=left3, choice=brakes
						begin
							state<=brakes;
							lights<=6'b111111;
						end
																											
				endcase
				// handling the special cases of the left and right states
				if(state==left)
					begin
						state<=left2;
						lights<=6'b011000;
					end
				if(state==left2)
					begin
						state<=left3;
						lights<=6'b111000;
					end
				if(state==right)
					begin
						state<=right2;
						lights<=6'b000110;
					end
				if(state==right2)
					begin
						state<=right3;
						lights<=6'b000111;
					end
			end

	end

endmodule
