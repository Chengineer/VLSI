class yapp_tx_monitor extends uvm_monitor;

	// component utility macro
	`uvm_component_utils(yapp_tx_monitor)

	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	// UVM run phase
	task run_phase(uvm_phase phase);
		`uvm_info(get_type_name(), $sformatf("You are in the monitor's run_phase"), UVM_LOW)
	endtask

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for:", get_full_name()}, UVM_HIGH)
	endfunction


endclass: yapp_tx_monitor
