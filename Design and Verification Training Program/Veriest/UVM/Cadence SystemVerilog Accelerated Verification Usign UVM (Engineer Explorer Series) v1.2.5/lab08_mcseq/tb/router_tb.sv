class router_tb extends uvm_env;

	// component macro
	`uvm_component_utils(router_tb)

	// YAPP UVC class handle
	yapp_env env;

	// Channel UVC handles
	channel_env ch0;
	channel_env ch1;
	channel_env ch2;

	// HBUS UVC handle
	hbus_env hbus;

	// Clock and Reset UVC handle
	clock_and_reset_env clock_and_reset;

	// multichannel (virtual) sequencer handle
	router_mcsequencer mcseqr;
	
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
		// configure the UVC before creating for safety.
		// Channel UVC
		// set channel_id property of each channel
		uvm_config_int::set(this, "ch0", "channel_id", 0);
		uvm_config_int::set(this, "ch1", "channel_id", 1);
		uvm_config_int::set(this, "ch2", "channel_id", 2);
		// create instances using factory calls
		ch0 = channel_env::type_id::create("ch0", this);
		ch1 = channel_env::type_id::create("ch1", this);
		ch2 = channel_env::type_id::create("ch2", this);
		// HBUS UVC - 1 master and 0 slaves
		// The HBUS UVC has both master and slave agents. For the router testing, we only need the master agent.
		uvm_config_int::set(this, "hbus", "num_masters", 1);
		uvm_config_int::set(this, "hbus", "num_slaves", 0);
		// create instance using factory calls
		hbus = hbus_env::type_id::create("hbus", this);
		// Clock and Reset UVC - requires no configuration
		// create instance using factory calls 
		clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);
		// virtual sequencer instance (handle and instance names match, so we can read the pathname off a topology report)
		mcseqr = router_mcsequencer::type_id::create("mcseqr", this);
		
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		// virtual sequencer connections (connect its UVC sequencer handles to the actual UVC sequencer instances via hierarchial pathnames. these pathnames are not string, se we can't use wildcards, and they are also handle names, not instance names)
		mcseqr.hbus_seqr = hbus.masters[0].sequencer;
		mcseqr.yapp_seqr = env.tx_agent.sequencer;
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for:", get_full_name()}, UVM_HIGH)
	endfunction
	
endclass
