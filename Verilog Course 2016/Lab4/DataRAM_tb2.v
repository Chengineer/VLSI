/* Chen Grapel. Verilog Course Exercise 4: Data memory with second nrst implementation test bench. Filename: DataRAM_tb2.v */
`include "DataRAM2.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module DataRAM_second_tb();// module name and ports list

parameter C=32;
parameter AD=5;
reg [C-1:0] din;
reg [AD:0] addr;
reg wr,en,clk,nrst;
wire [C-1:0] dout;
reg [C-1:0] data_RAM[(2**(AD))-1:0];


DataRAM_second UUT(din,addr,wr,en,clk,nrst,dout);// instantiation of the DataRAM1

initial
	begin
		din=32'b0; addr=5'b0; wr=1'b0; en=1'b0; clk=1'b0; nrst=1'b1;// initial input values
		$readmemh("Data_RAM.txt ",data_RAM);// load textfile of zeros and initialize the array with it
		$monitor($time,"din=%b,addr=%b,wr=%b,en=%b,clk=%b,nrst=%b,dout=%b",din,addr,wr,en,clk,nrst,dout);// System monitoring function
	end

always #1 clk=~clk;// define clock signal to toggle every 1Xtime unit

initial 
	begin   
		#2 nrst=1'b0;// reset  
		#64 nrst=1'b1;// out of reset after 32 clock cycles. the entire array is initialized with zeros 
		#2 din=32'd50; addr=5'd2;// nothing happens in the memory array yet 
		#2 wr=1'b0; en=1'b1;/* enable read, disable write. enable w/r operations. the value 0(decimal) is read from row number 2(decimal) */
		#4 en=1'b0;// disable w/r operations
		#2 wr=1'b1;// enable write, disable read  
		#2 en=1'b1;// enable w/r operations. the value 50(decimal) is written to row number 2(decimal)  
		#4 din=32'd167; addr=5'd16;// the value 167(decimal) is written to row number 16(decimal) 
		#6 en=1'b0;// disable w/r operations
		#2 din=32'd205; addr=5'd30;// nothing changes in the memory array 
		#2 wr=1'b0;// enable read, disable write
		#2 en=1'b1;// enable w/r operations. the value 0(decimal) is read from row number 30(decimal) 
		#4 din=32'd205; addr=5'd2;// the value 50(decimal) is read from row number 2(decimal)
		#20 addr=5'd16;// the value 167(decimal) is read from row number 16(decimal)
		#8 din=32'd205; addr=5'd30;
		#6 wr=1'b1;// enable write, disable read
		#36 en=1'b1; nrst=1'b0;// reset 
		#20 nrst=1'b1;// stop reset before completing 32 clock cycles. only part of the rows are set to zero
		#2 en=1'b0;// disable w/r operations
		#10 addr=5'd2;// the value 0(decimal) is read from row number 2(decimal).last reset operation has stopped before completing 32 clock cycles, but after completing more than 3 cycles */
		#11 wr=1'b0;// enable read, disable write
		#2 en=1'b1;// enable w/r operations
		#16 addr=5'd30;/* the value 205(decimal) is read from row number 30(decimal). last reset operation has stopped before completing at least 31 clock cycles */
		#10 $finish;// system function- end simulation run  

	end

endmodule


