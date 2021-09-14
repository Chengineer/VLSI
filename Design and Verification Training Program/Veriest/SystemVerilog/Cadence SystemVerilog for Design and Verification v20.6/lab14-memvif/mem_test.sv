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
		 mem_interface.for_test tbus,
		 mem_interface.for_test mbus
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
	virtual interface mem_interface memvif;
	bit [7:0] rdata;
	
	//constraint c1 { data_ >= 8'h20; data_ <= 8'h7F; }
	//constraint c2 { data_ inside {[8'h41:8'h5a],[8'h61:8'h7a]}; }
	//constraint c3 { data_ dist {[8'h41:8'h5a]:= 4,[8'h61:8'h7a]:= 1};}

	constraint c {
			policy == ascii		-> data_ inside { [8'h20:8'h7F] };
			policy == uppercase	-> data_ inside { [8'h41:8'h5a] };
			policy == lowercase	-> data_ inside { [8'h61:8'h7a] };
			policy == uplow		-> data_ dist	{[8'h41:8'h5a]:= 4,[8'h61:8'h7a]:= 1};  
			}

	function new(input bit [4:0] addr, bit [7:0] dt);
		address_ = addr;
		data_ = dt;
	endfunction

	task write_mem (
		  input bit debug = 0
		  );
	      begin
		 @(negedge memvif.clk)
		   begin
		      memvif.addr <= address_;
		      memvif.data_in <= data_;
		      memvif.read <= 0;
		      memvif.write <= 1;
		   end
		  @(negedge memvif.clk)
		   begin
		      memvif.write <= 0;
		   end
		 if (debug == 1)
		   $display("write address: %h, data: %c",address_,data_);
	       end      
	   endtask // write_mem

	   task read_mem (
			  input bit debug = 0
			  );
	      begin
		 @(negedge memvif.clk)
		   begin
		      memvif.addr <= address_;
		      memvif.write <= 0;
		      memvif.read <= 1;
		   end
		 @(negedge memvif.clk)
		   begin
		      memvif.read <= 0;
		   end
		 rdata = memvif.data_out;
		 if (debug == 1)
		   $display("read  address: %h, data: %c",address_,data_);
	      end
	   endtask // read_mem
	   
	function void configure (input virtual interface mem_interface mvif);
		memvif = mvif;
		if (memvif == null) $display ("configure error");
	endfunction
endclass

randclass my_rand = new(0,0);
randclass mem_rand = new(0,0);
   

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

  my_rand.configure(tbus);
  mem_rand.configure(mbus);

   
   

// add read_mem and write_mem tasks
   $display("Random Data Test - ASCII - mem2");
   mem_rand.policy = ascii;
   for (int i = 0; i<32; i++)
     begin
	ok = mem_rand.randomize();
        mem_rand.write_mem(1);
        mem_rand.read_mem(.debug(debug));
        if (mem_rand.rdata != mem_rand.data_)
	   error_status += 1;
     end

   // print results of test
     printstatus(error_status);
     error_status = 0;
  
   $display("Random Data Test - ASCII");
   my_rand.policy = ascii;
   for (int i = 0; i<32; i++)
     begin
	ok = my_rand.randomize();
	
//	ok = randomize(randata) with {randata >= 8'h20; randata <= 8'h7F;};
//     	ok = randomize(randata) with {randata inside {[8'h41:8'h5a],[8'h61:8'h7a]};};
//       	ok = randomize(randata) with {randata dist {[8'h41:8'h5a]:= 4,[8'h61:8'h7a]:= 1};};
        my_rand.write_mem(1);
        my_rand.read_mem(.debug(debug));
        if (my_rand.rdata != my_rand.data_)
	   error_status += 1;
     end

   // print results of test
     printstatus(error_status);
     error_status = 0;

   $display("Random Data Test - UpperCase");
   my_rand.policy = uppercase;
   for (int i = 0; i<32; i++)
     begin
	ok = my_rand.randomize();
        my_rand.write_mem();
        my_rand.read_mem(debug);
        if (my_rand.rdata != my_rand.data_)
	   error_status += 1;
     end
   // print results of test
     printstatus(error_status);
     error_status = 0;

   $display("Random Data Test - LowerCase");
   my_rand.policy = lowercase;
   for (int i = 0; i<32; i++)
     begin
	ok = my_rand.randomize();
        my_rand.write_mem();
        my_rand.read_mem(1);
        if (my_rand.rdata != my_rand.data_)
	   error_status += 1;
     end
   // print results of test
     printstatus(error_status);
     error_status = 0;

   $display("Random Data Test - UpperCase 80 LowerCase 20");
   my_rand.policy = uplow;
   for (int i = 0; i<32; i++)
     begin
	ok = my_rand.randomize();
        my_rand.write_mem();
        my_rand.read_mem(1);
        if (my_rand.rdata != my_rand.data_)
	   error_status += 1;
     end
   // print results of test
     printstatus(error_status);
     error_status = 0;
     
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
