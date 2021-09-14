interface mem_interface(input logic clk);
   logic read;
   logic write;
   logic [4:0] addr;
   logic [7:0] data_in;
   logic [7:0] data_out;

   timeunit 1ns;
   timeprecision 1ns;

   modport for_test (input data_out, clk, output read, write, addr, data_in);
   modport for_mem (output data_out, input read, write, addr, data_in, clk);
   
  
endinterface 
