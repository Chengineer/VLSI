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
		uvm_config_int::set(this, "*", "recording_detail", 1);
		
		//tb = new("tb", this); // construct the instance of router_tb class
		tb = router_tb::type_id::create("tb", this);// factory create call
		`uvm_info("MSG", "Test build_phase executed", UVM_HIGH)
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology(); // print hierarchy of our components
	endfunction

	function void check_phase(uvm_phase phase);
		// configuration checker
		check_config_usage();
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

class short_packet_test extends base_test;
	
	// component macro
	`uvm_component_utils(short_packet_test)
	
	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction	

	function void build_phase(uvm_phase phase);
		set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
		uvm_config_wrapper::set(this, "tb.env.tx_agent.sequencer.run_phase",
"default_sequence",
yapp_5_packets::get_type());
		super.build_phase(phase);
	endfunction

endclass

class set_config_test extends base_test;
	
	// component macro
	`uvm_component_utils(set_config_test)
	
	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		uvm_config_int::set(this, "tb.env.tx_agent", "is_active", UVM_PASSIVE);
		super.build_phase(phase);
	endfunction	

endclass

class incr_payload_test extends base_test;
	
	// component macro
	`uvm_component_utils(incr_payload_test)
	
	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); // sets the type override for short_yapp_packet
		uvm_config_wrapper::set(this, "tb.env.tx_agent.sequencer.run_phase",
"default_sequence",
yapp_incr_payload_seq::type_id::get()); // sets the default sequence of the YAPP sequencer to be yapp_incr_payload_seq
		super.build_phase(phase);
	endfunction	

endclass

class exhaustive_seq_test extends base_test;
	
	// component macro
	`uvm_component_utils(exhaustive_seq_test)
	
	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); // sets the type override for short_yapp_packet
		uvm_config_wrapper::set(this, "tb.env.tx_agent.sequencer.run_phase",
"default_sequence",
yapp_exhaustive_seq::type_id::get()); // sets the default sequence of the YAPP sequencer to be yapp_incr_payload_seq
		super.build_phase(phase);
	endfunction	

endclass