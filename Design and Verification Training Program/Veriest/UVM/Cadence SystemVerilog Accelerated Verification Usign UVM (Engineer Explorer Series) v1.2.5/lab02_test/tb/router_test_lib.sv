class base_test extends uvm_test;

	// component macro
	`uvm_component_utils(base_test)
	
	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	// router_tb class handle
	router_tb tb;

	// UVM build_phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		tb = new("tb", this); // construct the instance of router_tb class
		`uvm_info("MSG", "Test build_phase executed", UVM_HIGH)
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology(); // print hierarchy of our components
	endfunction

endclass

class test2 extends base_test;
	
	// component macro
	`uvm_component_utils(test2)
	
	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction	

endclass
