class router_tb extends uvm_env;

	// component macro
	`uvm_component_utils(router_tb)

	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	// UVM build_phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("MSG", "Testbench build_phase executed", UVM_HIGH)
	endfunction
	
endclass
