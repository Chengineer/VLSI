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

	// router module UVC
	router_env router_mod;
	
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
		// router module UVC
		router_mod = router_env::type_id::create("router_mod", this);
		
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		// virtual sequencer connections (connect its UVC sequencer handles to the actual UVC sequencer instances via hierarchial pathnames. these pathnames are not string, se we can't use wildcards, and they are also handle names, not instance names)
		mcseqr.hbus_seqr = hbus.masters[0].sequencer;
		mcseqr.yapp_seqr = env.tx_agent.sequencer;
		// connect the TLM ports from the YAPP and Channel UVCs to the scoreboard
		// connect the YAPP and Channel monitor ports to the scoreboard imps using hierarchical pathnames. 
		// REMEMBER an unconnected analysis port is not an error, so make sure you connect everything
		// we modify the connect calls so that the UVC monitor ports connect to the exports of the router module rather than directly down to the reference model and scoreboard imps
		env.tx_agent.monitor.item_collected_port.connect(router_mod.yapp_in); // the YAPP monitor ia now connected to the YAPP imp of the reference model under the router module
		hbus.masters[0].monitor.item_collected_port.connect(router_mod.hbus_in); // the HBUS monitor analysis port is connected to the HBUS imp of the reference model
		// the Channels are still connected to the scoreboard imps, but now the scoreboard instance is under the router module, so we need to add that level to the pathname
		ch0.rx_agent.monitor.item_collected_port.connect(router_mod.sb_chan0);
		ch1.rx_agent.monitor.item_collected_port.connect(router_mod.sb_chan1);
		ch2.rx_agent.monitor.item_collected_port.connect(router_mod.sb_chan2);
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for:", get_full_name()}, UVM_HIGH)
	endfunction
	
endclass
