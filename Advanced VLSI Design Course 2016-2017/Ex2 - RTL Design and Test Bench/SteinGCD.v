/* Chen Grapel. Digital VLSI design course. Exercise 2: Stein's GCD algorithm FSM. File name: SteinGCD.v */

`timescale 1ns / 100ps				

module SteinGCD(u,v,clk,rst_n,gcd);		

	// state encoding:
	localparam INIT=3'd0;			// starting point of Stein's algorithm
	localparam EVENEVEN=3'd1;		// u and v are even
	localparam EVENODD=3'd2;		// u is even and v is odd, or u is odd and v is even
	localparam ODDODD=3'd3;			// u and v are odd
	localparam FINALGCD=3'd4;		// ending point of Stein's algorithm- the GCD result
	// vector/bus sizing:
	localparam stateBits=3;  		// number of bits required to represent 5 states
	parameter usize=6;			// u is a random number in the 0-50 value range. requires 6 bits to cover all possible values (2^6=64)
	parameter vsize=5;			// v is a random number in the 0-30 value range. requires 5 bits to cover all possible values (2^5=32)
	parameter evenBits=2;			// evenFactor's number of bits

	// input ports:
	input wire [usize-1:0] u;		// the first operand
	input wire [vsize-1:0] v;		// the second operand
	input wire clk;				// clock
	input wire rst_n;			// negative reset
	// output port:
	output reg [usize-1:0] gcd;		// the GCD result

	// inner registers:
	reg [stateBits-1:0] state;
	reg [stateBits-1:0] next_state;
	reg [usize-1:0] inner_u;  
	reg [vsize-1:0] inner_v;
	reg [usize-1:0] next_inner_u; 
	reg [vsize-1:0] next_inner_v;
	reg [evenBits-1:0] evenFactor;		// counts the number of cycles at which the state is EVENEVEN, per GCD calculation 
	reg even;				// 1 if the current state is eveneven, and 0 for any other state
				
	// sequential block- define the registers:
	always @(posedge clk or negedge rst_n)	begin
		if(!(rst_n))// reset mode
			begin
				state<=INIT;
				evenFactor<=2'd0;// initialize the EVENEVEN-state-counter
			end
		else// out of reset mode
			begin
				state<=next_state;
				inner_u<=next_inner_u;
				inner_v<=next_inner_v;
				evenFactor<=evenFactor+((1'd1)*even);// update the EVENEVEN-state-counter
			end
	end
	
	// combinatorial block- compute the next state:
	always @(*) begin
						next_state=INIT;// default assignment 
		case(state)
			// state 0: starting point of Stein's algorithm
			INIT: begin
				if((next_inner_u==0)||(next_inner_v==0)||(next_inner_u==next_inner_v))// [0,v] or [u,0] or [u,u]
						next_state=FINALGCD;
				else begin
					if(((~(next_inner_u))&(6'd1))&&((~(next_inner_v))&(5'd1)))// [even u,even v]
						next_state=EVENEVEN;
					if((((~(next_inner_u))&(6'd1))&&((next_inner_v)&(5'd1)))||((((next_inner_u))&(6'd1))&&((~(next_inner_v))&(5'd1))))// [even u,odd v] or [odd u,even v]
						next_state=EVENODD;
					if((((next_inner_u))&(6'd1))&&(((next_inner_v))&(5'd1)))// [odd u,odd v]
						next_state=ODDODD;
				end
			end
			// state 1: u and v are even
			EVENEVEN: begin
				if(((~(next_inner_u))&(6'd1))&&((~(next_inner_v))&(5'd1)))// [even u,even v]
						next_state=EVENEVEN;
				if((((~(next_inner_u))&(6'd1))&&((next_inner_v)&(5'd1)))||((((next_inner_u))&(6'd1))&&((~(next_inner_v))&(5'd1))))// [even u,odd v] or [odd u,even v]
						next_state=EVENODD;
				if((((next_inner_u))&(6'd1))&&(((next_inner_v))&(5'd1)))// [odd u,odd v]
						next_state=ODDODD;
			end
			// state 2: u/v is even and v/u is odd
			EVENODD: begin
				if(next_inner_u==next_inner_v)// [u,u]
						next_state=FINALGCD;
				else begin
					if((((~(next_inner_u))&(6'd1))&&((next_inner_v)&(5'd1)))||((((next_inner_u))&(6'd1))&&((~(next_inner_v))&(5'd1))))// [even u,odd v] or [odd u,even v]
						next_state=EVENODD;
					if((((next_inner_u))&(6'd1))&&(((next_inner_v))&(5'd1)))// [odd u,odd v]
						next_state=ODDODD;
				end
			end
			// state 3: u and v are odd
			ODDODD: begin
				if(next_inner_u==next_inner_v)// [u,u]
						next_state=FINALGCD;
				else begin
					if((((~(next_inner_u))&(6'd1))&&((next_inner_v)&(5'd1)))||((((next_inner_u))&(6'd1))&&((~(next_inner_v))&(5'd1))))// [even u,odd v] or [odd u,even v]
						next_state=EVENODD;
					if((((next_inner_u))&(6'd1))&&(((next_inner_v))&(5'd1)))// [odd u,odd v]
						next_state=ODDODD;
				end
			end
			// state 4: ending point of Stein's algorithm- the GCD result
			FINALGCD: begin
						next_state=FINALGCD;// stay in FINALGCD state as long as rst_n==1
			end
			// "illegal" state (only 5 states are being used. the default state handles the other three options to encode 3-bit states)
			default: begin
						next_state=3'bx;
			end
		endcase
	end

	// combinatorial block- inner operations and output generation
	always @(*) begin
		// default assignments:
		next_inner_u=inner_u;
		next_inner_v=inner_v;
		even=1'd0;
		gcd=6'bz;// out of FINALGCD state- no result yet. thus, the output is high z 

		case(state)
			// state 0: starting point of Stein's algorithm
			INIT: begin		
				next_inner_u=u;						// assign u and v inputs into [u,v]
				next_inner_v=v;
			end
			// state 1: u and v are even
			EVENEVEN: begin
				even=1'd1;							
				next_inner_u=((inner_u)>>1);				// if [even u,even v]:[(u/2),(v/2)]		
				next_inner_v=((inner_v)>>1);				
			end 
			// state 2: u/v is even and v/u is odd
			EVENODD: begin
				if((~(inner_u))&(6'd1))					// if [even u,odd v]:[(u/2),v]
					next_inner_u=((inner_u)>>1); 
				if((~(inner_v))&(6'd1))					// if [odd u,even v]:[u,(v/2)]
					next_inner_v=((inner_v)>>1); 	
			end 
			// state 3: u and v are odd
			ODDODD: begin
				if((inner_u)>(inner_v))					//  if [odd u,odd v] and u>v:[(u-v)/2,v]
					next_inner_u=(((inner_u)-(inner_v))>>1);
				if((inner_v)>(inner_u))					//  if [odd u,odd v] and v>u:[(v-u)/2,u]
					begin	
						next_inner_v=inner_u;			
						next_inner_u=(((inner_v)-(inner_u))>>1);
					end
			end
			// state 4: ending point of Stein's algorithm- the GCD result
			FINALGCD: begin
				if((inner_u)==0)					// if [0,v]: gcd=v
					gcd=inner_v; 
				if(((inner_v)==0)||(inner_v)==(inner_u))		// if [u,u] or [u,0]: gcd=(u*(2^(evenFactor)))
					gcd=((inner_u)<<(evenFactor));
			end
			// default state
			default: begin
				$display("%t: State machine not initialized\n", $time); 
			end
		endcase		
	end

endmodule
