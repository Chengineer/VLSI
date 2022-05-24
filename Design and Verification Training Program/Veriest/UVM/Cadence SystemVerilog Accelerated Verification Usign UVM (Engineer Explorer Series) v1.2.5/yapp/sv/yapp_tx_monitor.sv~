class yapp_tx_monitor extends uvm_monitor;

	// component utility macro
	`uvm_component_utils(yapp_tx_monitor)

	// virtual interface declaration
	virtual interface yapp_if vif;

	// Collected Data handle
	yapp_packet pkt;

	// Count packets collected
	int num_pkt_col;

	// analysis port object
	uvm_analysis_port #(yapp_packet) item_collected_port;


	// covergroup declaration
	covergroup collected_pkts_cg;
		option.per_instance=1;
		// coverpoint for length (ensure all lengths of packets are sent into the router. Create buckets to detect minimum, maximum short, medium and large packets)
		REQ1_length: coverpoint pkt.length {
			bins MIN = { 1 };
			bins MAX = { 63 };
			bins SMALL = { [2:10] };
			bins MEDIUM = { [11:40] };
			bins LARGE = { [41:62] };
		}
		// coverpoint for address (ensure all addresses received a packet, including the illegal address)
		REQ2_addr: coverpoint pkt.addr {
			bins legal_addr[] = { [0:2] };
			bins illegal_addr = { 3 };
		}
		// coverpoint for bad parity (ensure all size packets were sent to all legal addresses with parity errors)
		bad_parity: coverpoint pkt.parity_type {
      			bins bad = {BAD_PARITY};
      			bins good = default;
    		}
		// cross length and address
    		REQ3_cross_addr_length: cross REQ1_length, REQ2_addr;
    		// cross address and parity
    		REQ3_cross_addr_bad_parity: cross  REQ2_addr, bad_parity;
	endgroup : collected_pkts_cg

	// component constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
		// construct the analysis port in the new function, without using the factory to avoid type overrides
		item_collected_port = new("item_collected_port", this);
		collected_pkts_cg = new();
		collected_pkts_cg.set_inst_name({get_full_name(), ".monitor_pkt"});
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for:", get_full_name()}, UVM_HIGH)
	endfunction
	
  // UVM run() phase
  task run_phase(uvm_phase phase);
    // Look for packets after reset
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin 
      // Create collected packet instance
      pkt = yapp_packet::type_id::create("pkt", this);

      // concurrent blocks for packet collection and transaction recording
      fork
        // collect packet
        vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      join

      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      // analysis write method call
      item_collected_port.write(pkt);
      num_pkt_col++;
      // sample coverage manually
      collected_pkts_cg.sample();
    end
  endtask : run_phase

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

  // connect phase
  function void connect_phase(uvm_phase phase);
    if(!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : connect_phase

endclass

