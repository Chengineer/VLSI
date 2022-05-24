class yapp_tx_agent extends uvm_agent;

	// component utilities block
	`uvm_component_utils_begin(yapp_tx_agent)
		`uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
	`uvm_component_utils_end
	

	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	// handles for monitor, driver and sequencer
	yapp_tx_monitor monitor;
	yapp_tx_driver driver;
	yapp_tx_sequencer sequencer;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monitor = new("monitor", this);
		if (is_active == UVM_ACTIVE) begin
			driver = new("driver", this);
			sequencer = new("sequencer", this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		if (is_active == UVM_ACTIVE)
			driver.seq_item_port.connect(sequencer.seq_item_export); 
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for:", get_full_name()}, UVM_HIGH)
	endfunction


endclass: yapp_tx_agent
