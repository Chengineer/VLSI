/* Chen Grapel. Verilog Course Exercise 4: Data memory with first nrst implementation test bench. Filename: DataRAM_tb1.v */
`include "DataRAM1.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module DataRAM_first_tb();// module name and ports list

parameter C=32;
parameter AD=5;
reg [C-1:0] din;
reg [AD-1:0] addr;
reg wr,en,clk,nrst;
wire [C-1:0] dout;
reg [C-1:0] data_RAM[(2**(AD))-1:0];

DataRAM_first UUT(din,addr,wr,en,clk,nrst,dout);// instantiation of the DataRAM1

initial
	begin
		din= 32'b0; addr= 5'b0; wr= 1'b0; en= 1'b0; clk= 1'b0; nrst= 1'b1;// initial input values
		$monitor($time,"din=%b,addr=%b,wr=%b,en=%b,clk=%b,nrst=%b,dout=%b",din,addr,wr,en,clk,nrst,dout);// System monitoring function
		$readmemh("Data_RAM.txt ",data_RAM);// load textfile of zeros and initialize the array with it
	end

always #1 clk=~clk;// define clock signal to toggle every 1Xtime unit

initial 
	begin     
		#2 nrst=1'b0;// reset
		#2 nrst=1'b1;/* out of reset after 2xtime unit, but reset operation will continue 32 clock cycles until the entire array is initialized to zeros */ 
		#32 din=32'd50; addr=5'd2;// nothing happens in the memory array yet (still zeros..) 
		#30 en=1'b1;/* enable w/r operations. the value 0(decimal) is read from row number 2(decimal) when reset is finished+ clk posedge */
		#4 en=1'b0;// disable w/r operations.
		#2 wr=1'b1;// enable write, disable read  
		#2 en=1'b1;// enable w/r operations. the value 50(decimal) is written to row number 2(decimal)  
		#2 din=32'd167; addr=5'd16;// the value 167(decimal) is written to row number 16(decimal) 
		#2 en=1'b0;// disable w/r operations.
		#2 din=32'd205; addr=5'd30;// nothing changes in the memory array 
		#2 wr=1'b0;// enable read, disable write
		#2 en=1'b1;// enable w/r operations. the value 0(decimal) is read from row number 30(decimal) 
		#2 din=32'd205; addr=5'd2;// the value 50(decimal) is read from row number 2(decimal)
		#4 addr=5'd16;// the value 167(decimal) is read from row number 16(decimal)
		#4 en=1'b0; nrst=1'b0;// reset the whole array
		#2 en=1'b1; nrst=1'b1;// out of reset.enable w/r operations.reset has not finished yet.cannot cannot read during reset operation*/
		#2 addr=5'd2;// reset has not finished yet. cannot read during reset operation
		#2 addr=5'd30;// reset has not finished yet. cannot read during reset operation
		#4 $finish;// system function- end simulation run  
	end

endmodule


