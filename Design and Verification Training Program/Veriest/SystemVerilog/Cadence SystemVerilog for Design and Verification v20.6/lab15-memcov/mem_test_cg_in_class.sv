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
typedef enum bit [1:0] {ascii, uppercase, lowercase, uplow} control_knob;  


class randclass;
	rand bit [4:0] address_;
	rand bit [7:0] data_;
	control_knob policy;
	
	//constraint c1 { data_ >= 8'h20; data_ <= 8'h7F; }
	//constraint c2 { data_ inside {[8'h41:8'h5a],[8'h61:8'h7a]}; }
	//constraint c3 { data_ dist {[8'h41:8'h5a]:= 4,[8'h61:8'h7a]:= 1};}

	constraint c {
			policy == ascii		-> data_ inside { [8'h20:8'h7F] };
			policy == uppercase	-> data_ inside { [8'h41:8'h5a] };
			policy == lowercase	-> data_ inside { [8'h61:8'h7a] };
			policy == uplow		-> data_ dist	{[8'h41:8'h5a]:= 4,[8'h61:8'h7a]:= 1};  
			}

	covergroup cg;
	caddr: coverpoint tbus.addr; // automatic bins
	cdatain: coverpoint tbus.data_in {
		bins b1 = {[8'h41:8'h5a]};
		bins b2 = {[8'h61:8'h7a]};
		bins b3 = default;
	}
	cdataout: coverpoint tbus.data_out {
		bins b4 = {[8'h41:8'h5a]};
		bins b5 = {[8'h61:8'h7a]};
		bins b6 = default;
	}
	endgroup:cg

	function new(input bit [4:0] addr, bit [7:0] dt);
		address_ = addr;
		data_ = dt;
		cg = new();
	endfunction

endclass

//cg cg1 =new(); // instantiate the covergroup

randclass my_rand = new(0,0);
 

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
    //cg1.stop(); // stop coverage collection
    my_rand.cg.stop();
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

   //cg1.start(); // start coverage collection
   my_rand.cg.start();
   $display("Random Data Test - UpperCase 80 LowerCase 20");
   my_rand.policy = uplow;
   for (int i = 0; i<32; i++)
     begin
	ok = my_rand.randomize();
        tbus.write_mem(.address(my_rand.address_), .data(my_rand.data_));
        tbus.read_mem(.address(my_rand.address_), .data(rdata), .debug(debug));
	//cg1.sample(); // force an immediate sample
	my_rand.cg.sample();
        if (rdata != my_rand.data_)
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
