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

module mem_test (
		 mem_interface.for_test tbus
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking
logic [7:0] randata;
bit 	    ok;
   
   

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
      tbus.write_mem(.address(i), .data(0));
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
	 tbus.read_mem(.address(i), .data(rdata));
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
      tbus.write_mem(.address(i), .data(i));
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
	 tbus.read_mem(.address(i), .data(rdata), .debug(debug));
       // check each memory location for data = address
	 if (rdata != i)
	   error_status += 1;
      end

   // print results of test
     printstatus(error_status);
     error_status = 0;
     

   

// add read_mem and write_mem tasks
  
   $display("Random Data Test");
   for (int i = 0; i<32; i++)
     begin
//	ok = randomize(randata) with {randata >= 8'h20; randata <= 8'h7F;};
//     	ok = randomize(randata) with {randata inside {[8'h41:8'h5a],[8'h61:8'h7a]};};
       	ok = randomize(randata) with {randata dist {[8'h41:8'h5a]:= 4,[8'h61:8'h7a]:= 1};};
        tbus.write_mem(.address(i), .data(randata));
        tbus.read_mem(.address(i), .data(rdata), .debug(debug));
        if (rdata != randata)
	   error_status += 1;
     end

   // print results of test
     printstatus(error_status);
     
 $finish;
  end   
  	         

// add result print function
   function void printstatus (input int status);
      if (status == 0)
	$display("Test PASSED");
      else
	$display("Test FAILED, %0d Errors", status);
   endfunction // printstatus
   

endmodule
