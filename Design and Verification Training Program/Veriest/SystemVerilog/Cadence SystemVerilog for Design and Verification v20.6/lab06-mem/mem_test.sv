///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module mem_test ( input logic clk, 
                  output logic read, 
                  output logic write, 
                  output logic [4:0] addr, 
                  output logic [7:0] data_in,     // data TO memory
                  input  wire [7:0] data_out     // data FROM memory
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;

    $display("Clear Memory Test");

    for (int i = 0; i< 32; i++)
       // Write zero data to every address location
      write_mem(.address(i), .data(0));
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
	 read_mem(.address(i), .data(rdata));
       // check each memory location for data = 'h00
	 if(rdata != 'h00)
	     error_status += 1;
      end

   // print results of test
     printstatus(error_status);
     error_status = 0;

    $display("Data = Address Test");

    for (int i = 0; i< 32; i++)
       // Write data = address to every address location
       write_mem(.address(i), .data(i));
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
	 read_mem(.address(i), .data(rdata), .debug(debug));
       // check each memory location for data = address
	 if (rdata != i)
	   error_status += 1;
      end

   // print results of test
     printstatus(error_status);
     

    $finish;
  end

// add read_mem and write_mem tasks
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
	   $display("write address: %h, data: %h",addr,data_in);
       end      
   endtask // read_mem

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
	   $display("read  address: %h, data: %h",addr,data);
      end
   endtask // read_mem
   
	      
   

// add result print function
   function void printstatus (input int status);
      if (status == 0)
	$display("Test PASSED");
      else
	$display("Test FAILED, %0d Errors", status);
   endfunction // printstatus
   

endmodule
