class router_tb extends uvm_env;

	// YAPP UVC class handle
	yapp_env env;

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
		//env = new("env", this);
		env = yapp_env::type_id::create("env", this); // factory create call for instances
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for:", get_full_name()}, UVM_HIGH)
	endfunction
	
endclass
