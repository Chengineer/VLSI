/* Chen Grapel. Verilog Course Exercise 1: 4bits Counter
   Filename: 4bit.v */
`timescale 1ns / 100ps					// result evaluated every 1nsec with 100psec resolution

module cntr_4b (clk, nrst, up , dout) ;		// module name and ports list
	input up, clk, nrst;					// input ports - clock and active-low reset
	output reg [3:0] dout ;				// counter output port
	
always @ (posedge clk or negedge nrst) 	// if "or negedge nrst" deleted - synchronous reset 
	begin
		if (!nrst)						// Asynchronous reset
			begin
				dout = 4'b0 ;
			end
		else		// Out of reset - normal operation
			begin
				if (up)
					dout = dout + 1 ;			// if -1, down counter
				else
					dout = dout - 1;
			end
	end
endmodule
