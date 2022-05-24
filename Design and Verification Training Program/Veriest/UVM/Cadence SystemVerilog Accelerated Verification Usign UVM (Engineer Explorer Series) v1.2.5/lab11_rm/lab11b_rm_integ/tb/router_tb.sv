class router_tb extends uvm_env;

	// register model handle
	yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5  yapp_rm;
	// HBUS adapter handle
	hbus_reg_adapter reg2hbus;

	// field automation macro for the register model
	`uvm_component_utils_begin(router_tb)
		`uvm_field_object(yapp_rm, UVM_ALL_ON)
	`uvm_component_utils_end

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
		// register model
		// create, build and lock model
		yapp_rm = yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5::type_id::create("yapp_rm",this);
		yapp_rm.build();
		yapp_rm.lock_model();
		// set the topmost hierarchical pathname for backdoor access to the DUT (set the root of the HDL path)
		yapp_rm.set_hdl_path_root("hw_top.dut"); 
		// set auto (implicit) prediction for the model 
		yapp_rm.default_map.set_auto_predict(1);
		// create the HBUS adapter instance for front-door access
		reg2hbus = hbus_reg_adapter::type_id::create("reg2hbus", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		// virtual sequencer connections (connect its UVC sequencer handles to the actual UVC sequencer instances via hierarchial pathnames. these pathnames are not string, se we can't use wildcards, and they are also handle names, not instance names)
		mcseqr.hbus_seqr = hbus.masters[0].sequencer;
		mcseqr.yapp_seqr = env.tx_agent.sequencer;
		// set the sequencer and adapter for the model address map
		// hbus is the instantiation name for the HBUS UVC in the testbench
		// (set the sequencer for the default address map of the model, and define the adapter)
		yapp_rm.default_map.set_sequencer(hbus.masters[0].sequencer, reg2hbus);
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for:", get_full_name()}, UVM_HIGH)
	endfunction
	
endclass
