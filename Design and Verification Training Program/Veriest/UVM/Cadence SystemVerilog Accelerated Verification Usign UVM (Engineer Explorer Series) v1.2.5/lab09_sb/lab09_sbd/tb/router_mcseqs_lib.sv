class router_simple_mcseq extends uvm_sequence;
	
	// object macro
	`uvm_object_utils(router_simple_mcseq)
	// macro to create the handle to the sequencer on which this sequence run. gives access the multichannel sequencer references
	`uvm_declare_p_sequencer(router_mcsequencer)

	// YAPP packets sequences
	yapp_012_seq yapp_012; // we need six packets so we can call it twice (it generates three)
	six_yapp_seq six_yapp; // random sequence of six YAPP packets

	// HBUS sequences
	hbus_small_packet_seq hbus_small_pkt; // max packet length=20, enable router
	hbus_read_max_pkt_seq hbus_rd_maxpkt; // read maxpktsize register
	hbus_set_default_regs_seq hbus_large_pkt; // max packet size=63


	// constructor
	function new(string name = "router_simple_mcseq");
		super.new(name);
	endfunction
	
	// objection handling
	// we only have one multichannel sequence, so we could call raise and drop objection methods directly in task body.
	task pre_body();
    		uvm_phase phase;
   		`ifdef UVM_VERSION_1_2
      		// in UVM1.2, get starting phase from method
      		phase = get_starting_phase();
    		`else
      		phase = starting_phase;
    		`endif
    		if (phase != null) begin
      		phase.raise_objection(this, get_type_name());
      		`uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    		end
  	endtask : pre_body

  	task post_body();
    		uvm_phase phase;
    		`ifdef UVM_VERSION_1_2
      		// in UVM1.2, get starting phase from method
      		phase = get_starting_phase();
    		`else
      		phase = starting_phase;
    		`endif
    		if (phase != null) begin
      		phase.drop_objection(this, get_type_name());
      		`uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    		end
  	endtask : post_body

	// in the body we use `uvm_do_on to execute UVC sequences on the correct sequencer handle from the multichannel sequencer (and we make sure the sequence matches the sequencer. e.g. we won't run HBUS sequences on the YAPP sequencer handle-that will give us some very strange error messages from the UVM library)
	virtual task body();
		`uvm_info("router_simple_mcseq", "Executing router_simple_mcseq", UVM_LOW)
		// configure for small packets
		`uvm_do_on(hbus_small_pkt, p_sequencer.hbus_seqr)
		// read the YAPP MAXPKTSIZE register 
		`uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
		// sequence stores read value in property max_pkt_reg
		//(if we check hbus_read_max_pkt_seq carefully, we can see that the read value is stored in a sequence variable max_pkt_reg and reported with HIGH verbosity. in our multichannel sequence, we can read that variable using the sequence handle and report the value using a LOW verbosity for better visibility)
		`uvm_info(get_type_name(), $sformatf("router MAXPKTSIZE register read: %0h", hbus_rd_maxpkt.max_pkt_reg), UVM_LOW)
		// send 6 consecutive packets to addresses 0,1,2, cycling the address
		`uvm_do_on(yapp_012, p_sequencer.yapp_seqr) 
		`uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
		// configure for large packets (default)
		`uvm_do_on(hbus_large_pkt, p_sequencer.hbus_seqr)
		// read the YAPP MAXPKTSIZE register (address 0)
		`uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
		// sequence stores read value in property max_pkt_reg
		`uvm_info(get_type_name(), $sformatf("router MAXPKTSIZE register read: %0h", hbus_rd_maxpkt.max_pkt_reg), UVM_LOW)
		// send 6 random packets
		`uvm_do_on(six_yapp, p_sequencer.yapp_seqr)
		
	endtask

	


endclass: router_simple_mcseq
