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

	task run_phase(uvm_phase phase);
		uvm_objection obj = phase.get_objection();
		obj.set_drain_time(this, 200ns); // drain time allows packets to pass through the router before simulation ends. allows propagation delay of data through the DUT.
	endtask

endclass

//class test2 extends base_test;
	
//	// component macro
//	`uvm_component_utils(test2)
	
//	// component constructor
//	function new(string name, uvm_component parent);
//		super.new(name, parent);
//	endfunction	
//
//endclass

//class short_packet_test extends base_test;
	
//	// component macro
//	`uvm_component_utils(short_packet_test)
	
//	// component constructor
//	function new(string name, uvm_component parent);
//		super.new(name, parent);
//	endfunction	

//	function void build_phase(uvm_phase phase);
//		set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
//		uvm_config_wrapper::set(this, "tb.env.tx_agent.sequencer.run_phase",
//"default_sequence",
//yapp_5_packets::get_type());
//		super.build_phase(phase);
//	endfunction

//endclass

//class set_config_test extends base_test;
	
//	// component macro
//	`uvm_component_utils(set_config_test)
	
//	// component constructor
//	function new(string name, uvm_component parent);
//		super.new(name, parent);
//	endfunction

//	function void build_phase(uvm_phase phase);
//		uvm_config_int::set(this, "tb.env.tx_agent", "is_active", UVM_PASSIVE);
//		super.build_phase(phase);
//	endfunction	

//endclass

//class incr_payload_test extends base_test;
	
//	// component macro
//	`uvm_component_utils(incr_payload_test)
	
//	// component constructor
//	function new(string name, uvm_component parent);
//		super.new(name, parent);
//	endfunction

//	function void build_phase(uvm_phase phase);
//		yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); // sets the type override for short_yapp_packet
//		uvm_config_wrapper::set(this, "tb.env.tx_agent.sequencer.run_phase",
//"default_sequence",
//yapp_incr_payload_seq::type_id::get()); // sets the default sequence of the YAPP sequencer to be yapp_incr_payload_seq
//		super.build_phase(phase);
//	endfunction	

//endclass

//class exhaustive_seq_test extends base_test;
	
//	// component macro
//	`uvm_component_utils(exhaustive_seq_test)
	
//	// component constructor
//	function new(string name, uvm_component parent);
//		super.new(name, parent);
//	endfunction

//	function void build_phase(uvm_phase phase);
//		yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); // sets the type override for short_yapp_packet
//		uvm_config_wrapper::set(this, "tb.env.tx_agent.sequencer.run_phase",
//"default_sequence",
//yapp_exhaustive_seq::type_id::get()); // sets the default sequence of the YAPP sequencer to be yapp_exhaustive_seq
//		super.build_phase(phase);
//	endfunction	

//endclass

//class short_yapp_012_test extends base_test;
	
//	// component macro
//	`uvm_component_utils(short_yapp_012_test)
	
//	// component constructor
//	function new(string name, uvm_component parent);
//		super.new(name, parent);
//	endfunction

//	function void build_phase(uvm_phase phase);
//		yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); // sets the type override for short_yapp_packet
//		uvm_config_wrapper::set(this, "tb.env.tx_agent.sequencer.run_phase",
//"default_sequence",
//yapp_012_seq::type_id::get()); // sets the default sequence of the YAPP sequencer to be yapp_012_seq
//		super.build_phase(phase);
//	endfunction	

//endclass

class simple_test extends base_test;
	
	// component macro
	`uvm_component_utils(simple_test)
	
	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); // sets the type override for short_yapp_packet
		uvm_config_wrapper::set(this, "tb.env.tx_agent.sequencer.run_phase",
"default_sequence",
yapp_012_seq::type_id::get()); // sets the default sequence of the YAPP sequencer to be yapp_012_seq
		uvm_config_wrapper::set(this, "tb.ch?.rx_agent.sequencer.run_phase",
"default_sequence",
channel_rx_resp_seq::type_id::get()); // sets the default sequence of the Channel UVC to be channel_rx_resp_seq (all three Channel UVCs are set with a single statement, using wildcard ?)
		uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
"default_sequence",
clk10_rst5_seq::type_id::get()); // sets the default sequence of the Clock and Reset UVC to be clk10_rst5_seq
		super.build_phase(phase);
	endfunction	

endclass

class test_uvc_integration extends base_test;
	
	// component macro
	`uvm_component_utils(test_uvc_integration)
	
	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); // sets the type override for short_yapp_packet
		uvm_config_wrapper::set(this, "tb.env.tx_agent.sequencer.run_phase",
"default_sequence",
test_uvc_seq::type_id::get()); // sets the default sequence of the YAPP sequencer to be test_uvc_seq
		uvm_config_wrapper::set(this, "tb.ch?.rx_agent.sequencer.run_phase",
"default_sequence",
channel_rx_resp_seq::type_id::get()); // sets the default sequence of the Channel UVC to be channel_rx_resp_seq (all three Channel UVCs are set with a single statement, using wildcard ?)
		uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
"default_sequence",
clk10_rst5_seq::type_id::get()); // sets the default sequence of the Clock and Reset UVC to be clk10_rst5_seq
		uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.run_phase",
"default_sequence",
hbus_small_packet_seq::type_id::get()); // sets the default sequence of the HBUS UVC to be hbus_small_packet_seq (sets up the router with register field maxpktsize = 20, and enables the router (register field router_en = 1)).
		super.build_phase(phase);
	endfunction	

endclass

class router_mctest extends base_test;
	
	// component macro
	`uvm_component_utils(router_mctest)
	
	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		yapp_packet::type_id::set_type_override(short_yapp_packet::get_type()); // sets the type override for short_yapp_packet
		
		uvm_config_wrapper::set(this, "tb.ch?.rx_agent.sequencer.run_phase",
"default_sequence",
channel_rx_resp_seq::type_id::get()); // sets the default sequence of the Channel UVC to be channel_rx_resp_seq (all three Channel UVCs are set with a single statement, using wildcard ?)

		uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
"default_sequence",
clk10_rst5_seq::type_id::get()); // sets the default sequence of the Clock and Reset UVC to be clk10_rst5_seq

		uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
"default_sequence",
router_simple_mcseq::type_id::get()); // sets the multichannel sequencer to execute our multichannel sequence
		// we do not set a default sequence for the YAPP or HBUS sequencer. control is now solely from the multichannel sequencer

		super.build_phase(phase);
	endfunction	

endclass

class  uvm_reset_test extends base_test;

    uvm_reg_hw_reset_seq reset_seq;

  // component macro
  `uvm_component_utils(uvm_reset_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
"default_sequence",
clk10_rst5_seq::type_id::get()); // sets the default sequence of the Clock and Reset UVC to be clk10_rst5_seq
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     reset_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     reset_seq.start(null);
     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : uvm_reset_test

class  uvm_mem_walk_test extends base_test;

    uvm_mem_walk_seq mem_walk_seq;

  // component macro
  `uvm_component_utils(uvm_mem_walk_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
"default_sequence",
clk10_rst5_seq::type_id::get()); // sets the default sequence of the Clock and Reset UVC to be clk10_rst5_seq
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      mem_walk_seq = uvm_mem_walk_seq::type_id::create("mem_walk_seq");
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     mem_walk_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     mem_walk_seq.start(null);
     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : uvm_mem_walk_test

class  reg_access_test extends base_test;

    // convenience hanle for the register block (the registers are declared in a block under the model handle instantiated in the testbench, so to simplify the calls we can declare a convenience handle for that path. the handle type is the type of the register block and we assign the handle in the connect phase)
    yapp_regs_c yapp_regs; 

  // component macro
  `uvm_component_utils(reg_access_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void connect_phase(uvm_phase phase);
	yapp_regs = tb.yapp_rm.router_yapp_regs;
  endfunction : connect_phase

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
"default_sequence",
clk10_rst5_seq::type_id::get()); // sets the default sequence of the Clock and Reset UVC to be clk10_rst5_seq
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     logic [7:0] rdata, wrdata;
     uvm_status_e status;
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     wrdata = 8'hA5;
     // RW register selected: en_reg
     `uvm_info("ACCESS_TEST", "RW test FDwr/peek/poke/FDrd en_reg", UVM_NONE) // register access reports verbosity is UVM_NONE se we can run a simulation and just see the register reports
     yapp_regs.en_reg.write(status, wrdata); // front-door write a unique value
     `uvm_info("API_TEST", $sformatf("WROTE FD en_reg:0x%0h", wrdata), UVM_NONE)
     yapp_regs.en_reg.peek(status, rdata); // peek and check the DUT value matches the written value
     `uvm_info("API_TEST", $sformatf("PEEK en_reg:0x%0h",rdata), UVM_NONE)
     yapp_regs.en_reg.poke(status, ~wrdata); // poke a new value 8'h5A
     `uvm_info("API_TEST", $sformatf("POKE en_reg:0x%0h", ~wrdata), UVM_NONE)
     yapp_regs.en_reg.read(status, rdata); // front-door read the new value and check it matches
     `uvm_info("API_TEST", $sformatf("READ FD en_reg:0x%0h",rdata), UVM_NONE)
     // RO register selected: addr0_cnt_reg
     `uvm_info("ACCESS_TEST", "RO test poke/FDrd/FDwr/peek addr0_cnt_reg", UVM_NONE)
     yapp_regs.addr0_cnt_reg.poke(status, wrdata); // poke a unique value
     `uvm_info("API_TEST", $sformatf("POKE addr0_cnt_reg:0x%0h", wrdata), UVM_NONE)
     yapp_regs.addr0_cnt_reg.read(status, rdata); // front-door read and check the value matches
     `uvm_info("API_TEST", $sformatf("READ FD addr0_cnt_reg:0x%0h", rdata), UVM_NONE)
     yapp_regs.addr0_cnt_reg.write(status, ~wrdata); // front-door write a new value 8'h5A
     `uvm_info("API_TEST", $sformatf("WROTE FD addr0_cnt_reg:0x%0h", ~wrdata), UVM_NONE)
     yapp_regs.addr0_cnt_reg.peek(status, rdata); // peek and check the DUT value has not changed
     `uvm_info("API_TEST", $sformatf("PEEK addr0_cnt_reg:0x%0h", rdata), UVM_NONE)
     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : reg_access_test

class reg_function_test extends base_test;

    // convenience hanle for the register block (the registers are declared in a block under the model handle instantiated in the testbench, so to simplify the calls we can declare a convenience handle for that path. the handle type is the type of the register block and we assign the handle in the connect phase)
    yapp_regs_c yapp_regs; 

    // YAPP sequencer handle
    yapp_tx_sequencer yapp_seqr;

   // YAPP 012 sequence handle
   yapp_012_seq yapp012;

  // component macro
  `uvm_component_utils(reg_function_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void connect_phase(uvm_phase phase);
	yapp_regs = tb.yapp_rm.router_yapp_regs;
        yapp_seqr = tb.env.tx_agent.sequencer;
  endfunction : connect_phase

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
"default_sequence",
clk10_rst5_seq::type_id::get()); // sets the default sequence of the Clock and Reset UVC to be clk10_rst5_seq
      uvm_config_wrapper::set(this, "tb.ch?.rx_agent.sequencer.run_phase",
"default_sequence",
channel_rx_resp_seq::type_id::get()); // sets the default sequence of the Channel UVC to be channel_rx_resp_seq (all three Channel UVCs are set with a single statement, using wildcard ?)
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      yapp012 = yapp_012_seq::type_id::create("yapp012", this);
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     logic [7:0] rdata;
     uvm_status_e status;
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     yapp_regs.en_reg.write(status, 8'h01); // front-door write to set only the router enable bit (index 0) in en_reg
     `uvm_info("REG_SEQ", "Wrote 8'h01 to en_reg", UVM_NONE )
     yapp_regs.en_reg.read(status, rdata); // read the enable register to check the value
     assert (rdata == 8'h01) // use assert to check the return value, and print an info report with verbosity NONE if the assert passes, and an error report if it fails
      `uvm_info("REG_SEQ", $sformatf("Read %h from en_reg", rdata), UVM_NONE )
     else
      `uvm_error("REG_SEQ", $sformatf("Read %h from en_reg - expected 8'h01", rdata))
     yapp012.start(yapp_seqr); // execute the YAPP 012 sequence instance using a start call (send 3 consecutive packets to addresses 0,1,2)
     // read all four address counter register addr0_cnt_reg to addr3_cnt_reg, and check they have not been incremented (make sure they are 0)
     yapp_regs.addr0_cnt_reg.read(status, rdata); 
     assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr0_cnt_reg", rdata), UVM_NONE )
     else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr0_cnt_reg - expected 8'h00", rdata))
     yapp_regs.addr1_cnt_reg.read(status, rdata); 
     assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr1_cnt_reg", rdata), UVM_NONE )
     else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr1_cnt_reg - expected 8'h00", rdata))
     yapp_regs.addr2_cnt_reg.read(status, rdata); 
     assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr2_cnt_reg", rdata), UVM_NONE )
     else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr2_cnt_reg - expected 8'h00", rdata))
     yapp_regs.addr3_cnt_reg.read(status, rdata); 
     assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr3_cnt_reg", rdata), UVM_NONE )
     else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr3_cnt_reg - expected 8'h00", rdata))
     yapp_regs.en_reg.write(status, 8'hff); // set all the enable bits by writing 8'hff to en_reg (ignoring reserved bit) - enable all the counters
     `uvm_info("REG_SEQ", "Wrote 8'hff to en_reg", UVM_NONE )
     // execute the YAPP 012 sequence instance twice using a start call (send 6 consecutive packets to addresses 0,1,2, cycling the address)
     yapp012.start(yapp_seqr);
     yapp012.start(yapp_seqr);
     // read all four address counter register addr0_cnt_reg to addr3_cnt_reg, and check they have been incremented correctly (check they are 2, except for address 3 which didn't receive any packet)
     yapp_regs.addr0_cnt_reg.read(status, rdata); 
     assert (rdata == 8'h02)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr0_cnt_reg", rdata), UVM_NONE )
     else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr0_cnt_reg - expected 8'h02", rdata))
     yapp_regs.addr1_cnt_reg.read(status, rdata); 
     assert (rdata == 8'h02)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr1_cnt_reg", rdata), UVM_NONE )
     else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr1_cnt_reg - expected 8'h02", rdata))
     yapp_regs.addr2_cnt_reg.read(status, rdata); 
      assert (rdata == 8'h02)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr2_cnt_reg", rdata), UVM_NONE )
     else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr2_cnt_reg - expected 8'h02", rdata))
     yapp_regs.addr3_cnt_reg.read(status, rdata); 
     assert (rdata == 8'h00)
      `uvm_info("REG_SEQ", $sformatf("Read %h from addr3_cnt_reg", rdata), UVM_NONE )
     else
      `uvm_error("REG_SEQ", $sformatf("Read %h from addr3_cnt_reg - expected 8'h00", rdata))
     yapp_regs.parity_err_cnt_reg.read(status, rdata); // check the parity error counter
     `uvm_info("REG_SEQ", $sformatf("Read %h from parity_err_cnt_reg", rdata), UVM_NONE )
     yapp_regs.oversized_pkt_cnt_reg.read(status, rdata); // check the oversized packet counter
     `uvm_info("REG_SEQ", $sformatf("Read %h from oversized_pkt_cnt_reg", rdata), UVM_NONE )
     yapp_regs.mem_size_reg.read(status, rdata); // check the memory size
    `uvm_info("REG_SEQ", $sformatf("Read %h from mem_size_reg", rdata), UVM_NONE )
     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : reg_function_test

class check_on_read_test extends base_test;

    // convenience hanle for the register block (the registers are declared in a block under the model handle instantiated in the testbench, so to simplify the calls we can declare a convenience handle for that path. the handle type is the type of the register block and we assign the handle in the connect phase)
    yapp_regs_c yapp_regs; 

    // YAPP sequencer handle
    yapp_tx_sequencer yapp_seqr;

   // YAPP 012 sequence handle
   yapp_012_seq yapp012;

  // component macro
  `uvm_component_utils(check_on_read_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void connect_phase(uvm_phase phase);
	yapp_regs = tb.yapp_rm.router_yapp_regs;
        yapp_seqr = tb.env.tx_agent.sequencer;
  endfunction : connect_phase

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
"default_sequence",
clk10_rst5_seq::type_id::get()); // sets the default sequence of the Clock and Reset UVC to be clk10_rst5_seq
      uvm_config_wrapper::set(this, "tb.ch?.rx_agent.sequencer.run_phase",
"default_sequence",
channel_rx_resp_seq::type_id::get()); // sets the default sequence of the Channel UVC to be channel_rx_resp_seq (all three Channel UVCs are set with a single statement, using wildcard ?)
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      yapp012 = yapp_012_seq::type_id::create("yapp012", this);
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     logic [7:0] rdata;
     int ok;
     uvm_status_e status;
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     tb.yapp_rm.default_map.set_check_on_read(1); // enable automatic checking of read values against the mirrored value in the register model. we should see errors on reading the RO counters, as the read DUT value does not match the register model value
     yapp_regs.en_reg.write(status, 8'h01); // front-door write to set only the router enable bit (index 0) in en_reg
     `uvm_info("REG_SEQ", "Wrote 8'h01 to en_reg", UVM_NONE )
     yapp_regs.en_reg.read(status, rdata); // read the enable register to check the value
    
     yapp012.start(yapp_seqr); // execute the YAPP 012 sequence instance using a start call (send 3 consecutive packets to addresses 0,1,2)
     // read all four address counter register addr0_cnt_reg to addr3_cnt_reg, and check they have not been incremented (make sure they are 0)
     yapp_regs.addr0_cnt_reg.mirror(status, UVM_CHECK); 
     yapp_regs.addr1_cnt_reg.mirror(status, UVM_CHECK); 
     yapp_regs.addr2_cnt_reg.mirror(status, UVM_CHECK); 
     yapp_regs.addr3_cnt_reg.mirror(status, UVM_CHECK); 
     yapp_regs.en_reg.write(status, 8'hff); // set all the enable bits by writing 8'hff to en_reg (ignoring reserved bit) - enable all the counters
     `uvm_info("REG_SEQ", "Wrote 8'hff to en_reg", UVM_NONE )
     // execute the YAPP 012 sequence instance twice using a start call (send 6 consecutive packets to addresses 0,1,2, cycling the address)
     yapp012.start(yapp_seqr);
     yapp012.start(yapp_seqr);
     // read all four address counter register addr0_cnt_reg to addr3_cnt_reg, and check they have been incremented correctly (check they are 2, except for address 3 which didn't receive any packet)
     ok = yapp_regs.addr0_cnt_reg.predict(8'h02); 
     yapp_regs.addr0_cnt_reg.mirror(status, UVM_CHECK);
     ok = yapp_regs.addr1_cnt_reg.predict(8'h02); 
     yapp_regs.addr1_cnt_reg.mirror(status, UVM_CHECK);
     ok = yapp_regs.addr2_cnt_reg.predict(8'h02); 
     yapp_regs.addr2_cnt_reg.mirror(status, UVM_CHECK);
     ok = yapp_regs.addr3_cnt_reg.predict(8'h00); 
     yapp_regs.addr3_cnt_reg.mirror(status, UVM_CHECK);
     yapp_regs.parity_err_cnt_reg.read(status, rdata); // check the parity error counter
     `uvm_info("REG_SEQ", $sformatf("Read %h from parity_err_cnt_reg", rdata), UVM_NONE )
     yapp_regs.oversized_pkt_cnt_reg.read(status, rdata); // check the oversized packet counter
     `uvm_info("REG_SEQ", $sformatf("Read %h from oversized_pkt_cnt_reg", rdata), UVM_NONE )
     ok = yapp_regs.mem_size_reg.predict(8'h2e); // check the memory size
     yapp_regs.mem_size_reg.mirror(status, UVM_CHECK);
     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : check_on_read_test

class introspection_test extends base_test;

    // convenience hanle for the register block (the registers are declared in a block under the model handle instantiated in the testbench, so to simplify the calls we can declare a convenience handle for that path. the handle type is the type of the register block and we assign the handle in the connect phase)
    yapp_regs_c yapp_regs; 

  // component macro
  `uvm_component_utils(introspection_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void connect_phase(uvm_phase phase);
	yapp_regs = tb.yapp_rm.router_yapp_regs;
  endfunction : connect_phase

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     uvm_status_e status;
     uvm_reg qreg[$], rwregs[$], roregs[$]; // queues of type uvm_reg
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     yapp_regs.get_registers(qreg); // get_registers extracts all the registers from the model into the queue qreg
     foreach (qreg[i])
       `uvm_info("ALLREG",$sformatf("%s",qreg[i].get_name()),UVM_NONE) // print qreg with a foreach loop, using get_name to print each register name
     // filter qreg by access rights
     foreach (qreg[i])
       if (qreg[i].get_rights() == "RO") // extract all registers with a read-only access policy
          roregs.push_back(qreg[i]); // push them to the queue roregs 
     foreach (roregs[i])
       `uvm_info("ROREG",$sformatf("%s",roregs[i].get_name()),UVM_NONE) // and check via a print
     rwregs = qreg.find(i) with (i.get_rights() =="RW"); // SV array locator methods usage. the find method extracts all elements of qreg where the with condition is true. namely access rights are read-write. i is an iterator for the queue contents.
     foreach (rwregs[i])
       `uvm_info("RWREG",$sformatf("%s",rwregs[i].get_name()),UVM_NONE) // print the rwregs queue for checking
     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
     
  endtask

endclass : introspection_test






