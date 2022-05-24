class yapp_env extends uvm_env;

	// component utility macro
	`uvm_component_utils(yapp_env)

	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	// tx_agent handle
	yapp_tx_agent tx_agent;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//tx_agent = new("tx_agent", this);
		tx_agent = yapp_tx_agent::type_id::create("tx_agent", this);// factory create call for instances
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for:", get_full_name()}, UVM_HIGH)
	endfunction


endclass: yapp_env
