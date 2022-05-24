package router_module_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	// import YAPP package for visibility of YAPP data item
	import yapp_pkg::*;
	// import Channel package for visibility of channel data item
	import channel_pkg::*;
	// import HBUS package for visibility of HBUS data item
	import hbus_pkg::*;
	`include "router_scoreboard.sv"
	`include "router_reference.sv"
	`include "router_module_env.sv"

endpackage
