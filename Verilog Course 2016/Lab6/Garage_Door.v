/* Chen Grapel. Verilog Course Exercise 6: Finite State Machine. Filename: Garage_Door.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module Garage_Door(up_limit,dn_limit,activate,clk,nrst,motor_up,motor_dn);// module name and ports list

// coding each state (actually, "define" each state's code)
parameter idle=2'b00; 
parameter movingUp=2'b01;
parameter movingDn=2'b10;
input wire up_limit,dn_limit,activate,clk,nrst;/* input port - motor limits received from sensors, activation of motor operation, clock, not reset */
output reg motor_up,motor_dn;// output port- motor operations: move up or move down
reg [1:0] next_state,state;// inner ports- next state and current state

initial
	begin
		state=2'b00; next_state=2'b00;// initialize inner ports
	end


always @(posedge clk or negedge nrst)
	begin
		if(!nrst)// reset
			begin
				state<=idle;
				motor_up<=0;
				motor_dn<=0;	
			end
		else
			state<=next_state;// if not reset, assign next state into current state
	end

always @(state or activate or dn_limit or up_limit)// implementing the state diagram (flow..transitions..)
	begin	
		case(state)
				idle:// idle state
					begin
						if(activate&dn_limit&(!up_limit))
							next_state<=movingUp;
						else
							begin
								if(activate&up_limit&(!dn_limit))
									next_state<=movingDn;
							end
					end
				movingUp:// moving up state
					begin
						if(up_limit&(!dn_limit))
							next_state<=idle;
						else
							begin
								if(dn_limit&(!up_limit))
									next_state<=movingUp;
							end
					end
				movingDn:// moving down state
					begin
						if(dn_limit&(!up_limit))
							next_state<=idle;
						else
							begin
								if(up_limit&(!dn_limit))
									next_state<=movingDn;
							end
					end
				default:// default state is idle
					next_state<=idle;
			endcase
	end

always @(state)// defining the output signals for each state
	begin
		case(state)
			idle:
				begin
					motor_up=1'b0;
					motor_dn=1'b0;
				end
			movingUp:
				begin
					motor_up=1'b1;
					motor_dn=1'b0;
				end
			movingDn:
				begin
					motor_up=1'b0;
					motor_dn=1'b1;
				end
			default:
				begin
					motor_up=1'b0;
					motor_dn=1'b0;
				end
		endcase
	end

endmodule
