interface mem_interface(input logic clk);
   logic read;
   logic write;
   logic [4:0] addr;
   logic [7:0] data_in;
   logic [7:0] data_out;

   timeunit 1ns;
   timeprecision 1ns;

   modport for_test (input data_out, clk, output read, write, addr, data_in, import read_mem, write_mem);
   modport for_mem (output data_out, input read, write, addr, data_in, clk);
   
    task write_mem (
		  input logic [4:0] address,
		  input logic [7:0] data,
		  input bit debug = 0
		  );
      begin
	 
	 @(negedge clk)
	   begin
	      addr <= address;
	      data_in <= data;
	      read <= 0;
	      write <= 1;
	   end
	  @(negedge clk)
	   begin
	      write <= 0;
	   end
	 if (debug == 1)
	   $display("write address: %h, data: %c",addr,data_in);
       end      
   endtask // write_mem

   task read_mem (
		  input logic [4:0] address,
		  output logic [7:0] data,
		  input bit debug = 0
		  );
      begin
	 @(negedge clk)
	   begin
	      addr <= address;
	      write <= 0;
	      read <= 1;
	   end
	 @(negedge clk)
	   begin
	      read <= 0;
	   end
	 data = data_out;
	 if (debug == 1)
	   $display("read  address: %h, data: %c",addr,data);
      end
   endtask // read_mem
   
endinterface 