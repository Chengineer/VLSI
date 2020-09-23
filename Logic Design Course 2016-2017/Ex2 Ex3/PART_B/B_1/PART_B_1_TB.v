/* Chen Grapel Logic Design Course Exercise 2+3 (part B 1): Data memory test bench. Filename: PART_B_1_TB.v */

`include "PART_B_1.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module DataMemory_tb();// module name and ports list
	
	parameter AD=5;
	parameter C=32;
	parameter R=(2**(AD));
	
	reg [C-1:0] data_in;
	reg [AD-1:0] address;
	reg write_read;
	reg enable;
	reg clk;
	reg nrst;
	wire [C-1:0] data_out;
	
	DataMemory UUT(.din(data_in),.addr(address),.wr_rd(write_read),.en(enable),.clk(clk),.rst_n(nrst),.dout(data_out));// instantiation of the DataMemory module
	
	initial
		begin
			data_in=32'h0;address=5'd0;write_read=1'b0;enable=1'b0;clk=1'b0;nrst=1'b1;// initial input values
			$monitor($time,"data_in=%h,address=%d,write_read=%b,enable=%b,clk=%b,nrst=%b,data_out=%h",data_in,address,write_read,enable,clk,nrst,data_out);// System monitoring function
			$readmemh("data_RAM.txt",UUT.mem);// load textfile into the memory array
			UUT.addrIndex=5'd0;// initialize addIndex for the fisrt reset session (needed in case the initial level of nrst signal is 0)
		end

	always #1 clk=~clk;// define clock signal to toggle every 1Xtime unit

	initial
		begin
			#2 enable=1'b1;// read mode
			#2 address=5'd1;// read from address 1
			#2 nrst=1'b0;// reset mode (read operation is still enabled but doesn't work during reset)
			#1 write_read=1'b1;// write mode- doesn't work during reset
			#1 data_in=32'hAAAAAAAA;
			#2 write_read=1'b0;// read mode- doesn't work during reset
			#2 nrst=1'b1;// out of reset mode
			#2 address=5'd0;
			#2 write_read=1'b1;
			#2 enable=1'b0;// hold mode (disable w/r operations)
			#2 address=5'd21; data_in=32'hCAD00FAB;// nothing changes in the array..
			#2 write_read=1'b0;// data_out still shows high z
			#2 enable=1'b1;// out of hold mode (enable w/r operations)
			#2 write_read=1'b1;
			#6 $finish;// system function- end simulation run  
		end


endmodule
