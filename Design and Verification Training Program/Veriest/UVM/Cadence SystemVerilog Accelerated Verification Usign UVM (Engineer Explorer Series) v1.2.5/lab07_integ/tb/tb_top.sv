/*-----------------------------------------------------------------
File name     : tb_top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;
// import the UVM library
	import uvm_pkg::*;
// include the UVM macros
	`include "uvm_macros.svh"
// we import UVC packages before the testbench include, as the testbench uses the UVC package declarations.
// import the YAPP package
	import yapp_pkg::*;
// import the Channel UVC package
	import channel_pkg::*;
// import the clock and reset UVC package
	import clock_and_reset_pkg::*;
// import the HBUS UVC package
	import hbus_pkg::*;
// include the testbench and test library file
	`include "router_tb.sv"
	`include "router_test_lib.sv"


	initial begin
		yapp_vif_config::set(null,"uvm_test_top.tb.env.tx_agent.*","vif",hw_top.in0); // the interface has to be set in advance of building the UVC
		hbus_vif_config::set(null, "*.tb.hbus.*", "vif", hw_top.hif);
		// set the HBUS, Channel and clock and reset UVC virtual interfaces to the correct interface. (the UVC header files contain typedefs for each interface). we need a set call for each UVC instance to connect the interfaces. pathnames contain the UVC instance names we used in the testbench, and then a wildcard * to hit everything under the UVC top level instance.
		// since we created the YAPP, we know the interfaces are only used in driver and monitor under the agent. however third-party UVCs may, rarely, access the interface in other parts of the hierarchy, so it's safer just to select the top level instance.
		// the field name should match that used in the get. all our UVCs use vif as the field name, but in reality, you should always confirm which field name is used. ideally this is documented, but we may need to open the driver and monitor code to check.
		// the interface instance names we used in the hw_top module are accessed via a hierarchical pathname.
		channel_vif_config::set(null, "*.tb.ch0.*", "vif", hw_top.ch0if);
		channel_vif_config::set(null, "*.tb.ch1.*", "vif", hw_top.ch1if);
		channel_vif_config::set(null, "*.tb.ch2.*", "vif", hw_top.ch2if);
		clock_and_reset_vif_config::set(null, "*.tb.clock_and_reset.*", "vif", hw_top.clk_rst_if);
		run_test("base_test"); // initiate phasing
	end
	
endmodule : tb_top
