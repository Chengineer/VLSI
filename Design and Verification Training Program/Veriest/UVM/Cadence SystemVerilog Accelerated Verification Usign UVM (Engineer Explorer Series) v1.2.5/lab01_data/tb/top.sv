/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
// import the UVM library
	import uvm_pkg::*;
// include the UVM macros
	`include "uvm_macros.svh"
// import the YAPP package
	import yapp_pkg::*;

	yapp_packet p1, p2, p3;
	
	int ok;

// generate 5 random packets and use the print method
// to display the results
	initial begin
		repeat(5) begin
			p1 = new("p1");
			ok = p1.randomize();
			p1.print(); // table view
			p1.print(uvm_default_tree_printer);
			p1.print(uvm_default_line_printer);
		end

		p2 = new("p2");
		p2.copy(p1);
		p1.print();
		p2.print();
		
		$cast(p3, p1.clone()); // copy p1 including instance name
		p3.print();

		if(p1.compare(p2))
			$display("p1 == p2");
		else
			$display("p1 != p2");
		
		ok = p3.randomize();
		if(p1.compare(p3))
			$display("p1 == p3");
		else
			$display("p1 != p3");
		
	end
// experiment with the copy, clone and compare UVM method
endmodule : top
