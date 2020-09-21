/* Chen Grapel. Verilog Course Exercise 4: Data memory with second nrst implementation. Filename: DataRAM2.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module DataRAM_second(din,addr,wr,en,clk,nrst,dout);// module name and ports list

parameter C=32;// define number of Columns (number of bits per one row)
parameter AD=5;// define number of address bits 
input wire [C-1:0] din;// input port- 32-bit data in
input wire [AD-1:0] addr;// input port- 5-bit address
input wire wr,en,clk,nrst;// input ports- data in,address,write/read,enable,clock,not-reset
output reg [C-1:0] dout;// output port- 32-bit data out for read operation
reg [C-1:0] data_RAM[(2**(AD))-1:0];/* inner port- the memory array: 32 32-bit rows (number of possible addresses (rows) is 2^(number of address bits) */
reg rstFlag,rstDoneFlag;// inner ports- reset and reset-done flags
reg [AD-1:0] addrIndex;// inner port- 5-bit address that will be used as an index of the reset state

initial
	begin// initialize inner ports
		addrIndex= 1'b0;
		rstFlag= 1'b0;
	end 

always @(posedge clk)// implementing a synchronous nrst in a synchronous system, using inner control flags
	begin
		if(nrst==1'b0)// raise the reset flag if not-reset is negative, reset operation will start on next clock posedge
			rstFlag= 1'b1;
		else// not reset- the opposite case
			rstFlag= 1'b0;
	end

always @(posedge clk)// synchronous reset,write,read:
	begin
		if(rstFlag==1'b1)// reset operation
			begin
				if(addrIndex==5'd31)// resets the last row: 
					begin
						data_RAM[addrIndex] = 32'b0;// reset the last row
						addrIndex= 1'b0;// ready for next reset session of the whole array
					end
				else// resets rows except from the last one:
					begin
						data_RAM[addrIndex] = 32'b0;// reset the current row
						addrIndex= addrIndex+5'd1;/* update the address index to be the next row to reset on the next posedge */
					end
				dout= 32'bz;// shows no output during reset state (high z)
			end
		else// the reset state is "off" (reset flag is negative). read/write are allowed to be operated
			begin
				addrIndex= 1'b0;/* makes sure that the next reset session will start from the first row (covers the case that nrst signal has changed its polarity to positive before reset of the last row) */ 
				if(en==1'b1)// it is possible to write/read only if enable signal is positive
					begin
						if(wr==1'b1)// wr=1 : write operation
							begin
								dout= 32'bz;// shows no output when write operation is enabled
								data_RAM[addr] = din;// assign data-in to the selected row (i.e. address)
							end
						else// wr=0 : read operation
							dout = data_RAM[addr];/* extract the selected row (i.e. address), and assign it to data-out */
					end
				else// en==0
					dout= 32'bz;// shows no output when read/write operations are disabled
			end
	end
	
endmodule
