/* Chen Grapel Logic Design Course Exercise 2+3 (part B 1): Data memory. Filename: PART_B_1.v */

`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module DataMemory(din,addr,wr_rd,en,clk,rst_n,dout);// module name and ports list
	
	// parameters:
	parameter AD=5;
	parameter C=32;
	parameter R=(2**(AD));
	// inputs:
	input [C-1:0] din;// data in
	input [AD-1:0] addr;// memory address
	input wr_rd;// 1 for write mode, 0 for read mode
	input en;// 1 to enable write/read operations, 0 for hold mode (like WL..)
	input clk;// clock signal
	input rst_n;// negative reset
	// output:
	output [C-1:0] dout;// data out
	// inner registers:
	reg [C-1:0] mem [R-1:0];// 32X32 memory array 
	reg [AD-1:0] addrIndex;// 5-bit address that will be used as an index of the reset state

	always @(posedge clk)
		begin
			if(!rst_n)// synchronous negative reset
				begin
					if(addrIndex==5'd31)// resets the last row: 
						begin
							mem[addrIndex]<=32'b0;// reset the last row
							addrIndex<=5'd0;// ready for next reset session of the entire array
						end
					else// resets rows except from the last one:
						begin
							mem[addrIndex]<=32'b0;// reset the current row
							addrIndex<=addrIndex+5'd1;// update the address index to be the next row to reset on the next posedge
						end
				end
			else
				begin
				 	addrIndex<=5'd0;// out of reset mode, initialize addrIndex to get ready for next reset session
					if((en)&&(wr_rd))	
						mem[addr]<=din;// synchronous write
				end
		end
	assign dout=((en)&&(!wr_rd)&&(rst_n))?mem[addr]:32'bz;// asynchronous read. for hold/write/reset mode, data out is high z.

endmodule
