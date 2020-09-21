/* Chen Grapel. Verilog Course Exercise 3: T-Flip Flop. Filename: TFF.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module TFF(t,nrst,clk,q);// module name and ports list

input wire t,nrst,clk;// input ports- Toggle, not-reset, clock
output reg q;// output port- q
reg d;// "inner" input port for the data 

always @(posedge clk or negedge nrst)
	begin
		if(nrst==0)
			q=0;// reset
		else
			begin// T-FF
				d = q^t;
				q = d;
			end
	end
	
endmodule
