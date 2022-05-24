// in this solution, we create a new scoreboard which combines both the reference model and scoreboard functionality of the previous labs

typedef enum bit {EQUALITY, UVM} comp_t;

class router_fifo_scoreboard extends uvm_scoreboard;

	// analysis fifo components - declare analysis FIFO's for the YAPP, HBUS and 3 channel connections
	uvm_tlm_analysis_fifo #(yapp_packet) yapp_fifo;
	uvm_tlm_analysis_fifo #(channel_packet) chan0_fifo, chan1_fifo, chan2_fifo;
	uvm_tlm_analysis_fifo #(hbus_transaction) hbus_fifo;

	// variable for comparer policy
	comp_t compare_policy = UVM;

	// scoreboard statistics - declare counters for statistics
	int packets_in = 0;
	int packets_ch [2:0];
	int compare_ch [2:0];
	int miscompare_ch [2:0];
	int packets_dropped = 0;
	int packets_valid = 0;
	int jumbo_packets = 0;
	int bad_addr_packets = 0;
	int disabled_packets = 0;

	// router registers - declare local copies of the MAXPKTSIZE and router enable registers
	bit [7:0] max_pktsize_reg = 8'h3F;
	bit [7:0] router_enable_reg = 1'b1;

	// constructor
	function new(string name = "", uvm_component parent = null);
		super.new(name, parent);
		// instantiate analysis FIFO's with direct constructor calls
		yapp_fifo = new("yapp_fifo", this);
		chan0_fifo = new("chan0_fifo", this);
		chan1_fifo = new("chan1_fifo", this);
		chan2_fifo = new("chan2_fifo", this);
		hbus_fifo = new("hbus_fifo", this);
	endfunction

	`uvm_component_utils_begin(router_fifo_scoreboard)
		`uvm_field_enum(comp_t, compare_policy, UVM_ALL_ON)
	`uvm_component_utils_end

	// the comparison functions are unchanged from the previous scoreboard labs
	// custom packet compare function using inequality operators
	   function bit comp_equal (input yapp_packet yp, input channel_packet cp);
	      // returns first mismatch only
	      if (yp.addr != cp.addr) begin
		`uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
		return(0);
	      end
	      if (yp.length != cp.length) begin
		`uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
		return(0);
	      end
	      foreach (yp.payload [i])
		if (yp.payload[i] != cp.payload[i]) begin
		  `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
		  return(0);
		end
	      if (yp.parity != cp.parity) begin
		`uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
		return(0);
	      end
	      return(1);
	   endfunction

	   // custom packet compare function using uvm_comparer methods
	  function bit comp_uvm(input yapp_packet yp, input channel_packet cp, uvm_comparer comparer = null);
	    string str;
	    if (comparer == null)
	      comparer = new();
	    comp_uvm = comparer.compare_field("addr", yp.addr, cp.addr,2);
	    comp_uvm &= comparer.compare_field("length", yp.length, cp.length,6);
	    foreach (yp.payload [i]) begin
	      str.itoa(i);
	      comp_uvm &= comparer.compare_field({"payload[",str,"]"}, yp.payload[i], cp.payload[i],8);
	    end
	    comp_uvm &= comparer.compare_field("parity", yp.parity, cp.parity,8);
	  endfunction


	   task run_phase(uvm_phase phase);
	     // the scoreboard can receive HBUS and YAPP transactions simultaneously. therefore, we need a fork-join in the run_phase method to concurrently check YAPP packets in a check_packet task, and HBUS transactions in a update_regr task
	     fork
	       check_packet();
	       update_regr();
	     join
	   endtask 

		// update_regr uses a forever loop to continuously call a blocking get from the get_peek_export of the HBUS analysis FIFO. therefore, when the HBUS monitor writes to the FIFO, it will trigger the get to receive the transaction. we check for a write operation on the control or enable registers and update the local variables accordingly
	   task update_regr();
	     hbus_transaction hb;
	     forever begin
	       // get transaction from hbus
	       hbus_fifo.get_peek_export.get(hb);
	       `uvm_info(get_type_name(), $sformatf("Scoreboard: Received HBUS Transaction: \n%s", hb.sprint()), UVM_MEDIUM)
	       // capture the max_pktsize_reg and router_enable_reg
	       // values whenever a hbus transaction is written
	       if (hb.hwr_rd == HBUS_WRITE)
		 case (hb.haddr)
		   'h1000 : max_pktsize_reg = hb.hdata;
		   'h1001 : router_enable_reg = hb.hdata;
		 endcase
	     end 
	   endtask
	     
           // check_packet calls a blocking get from the get_peek_export of the YAPP analysis FIFO. we check for invalid packets (address 3), over-sized packets or disabled router. if the packet is invalid, we stay inside the do-while loop to get the next packet. if the packet is valid, we drop out of the while loop and call a blocking get on the appropriate channel analysis FIFO. when we have the channel packet, we compare packets and update statistics. the forever loop then takes us back to the top of the task to process the next packet.
	   task check_packet();
	     yapp_packet yapp_pkt;
	     channel_packet chan_pkt;
	     bit valid;
	     bit pktcompare;
	     logic [1:0] paddr;
	     forever begin
	       do begin
		 // get packet from yapp
		 yapp_fifo.get_peek_export.get(yapp_pkt);
		 `uvm_info(get_type_name(), $sformatf("Scoreboard: Packet got from yapp analysis fifo\n%s",yapp_pkt.sprint()), UVM_MEDIUM)
		 packets_in++;
		 // check validity
		 valid = 1'b1;
		 if (yapp_pkt.addr == 3) begin
		   bad_addr_packets++;
		   packets_dropped++;
		   `uvm_info(get_type_name(), "Scoreboard: YAPP Packet Dropped [BAD ADDRESS]", UVM_LOW)
		   valid = 1'b0;
		 end
		 else if ((router_enable_reg == 1) && (yapp_pkt.length > max_pktsize_reg))begin
		   jumbo_packets++;
		   packets_dropped++;
		   `uvm_info(get_type_name(), "Scoreboard: YAPP Packet Dropped [OVERSIZED]", UVM_LOW)
		   valid = 1'b0;
		 end
		 else if (router_enable_reg == 0) begin
		   disabled_packets++;
		   packets_dropped++;
		   `uvm_info(get_type_name(), "Scoreboard: YAPP Packet Dropped [DISABLED]", UVM_LOW)
		   valid = 1'b0;
		 end
	       end
	       while (valid == 1'b0);
	       packets_valid++;
	       packets_ch[yapp_pkt.addr]++;
	       // get packet from channel
	       case (yapp_pkt.addr)
		 0 : chan0_fifo.get_peek_export.get(chan_pkt);
		 1 : chan1_fifo.get_peek_export.get(chan_pkt);
		 2 : chan2_fifo.get_peek_export.get(chan_pkt);
	       endcase
	       `uvm_info(get_type_name(), "Scoreboard: Packet got from chan analysis fifo", UVM_LOW)
	       // compare packets
	       if (compare_policy == UVM)
		 // use custom comparer with UVM methods
		 pktcompare =  comp_uvm(yapp_pkt, chan_pkt);
	       else
		 // use custom comparer with equality operators
		 pktcompare =  comp_equal(yapp_pkt, chan_pkt);
	    
	       if( pktcompare ) begin
		  paddr = chan_pkt.addr;
		  `uvm_info(get_type_name(), $sformatf("Scoreboard Compare Match: Channel_%0d", paddr), UVM_LOW)
		  `uvm_info(get_type_name(), $sformatf("Scoreboard Matched Packet: \n%s", chan_pkt.sprint()), UVM_MEDIUM)
		  compare_ch[paddr]++;
	       end
	       else begin
		  `uvm_warning(get_type_name(), $sformatf("Scoreboard Error [MISCOMPARE]: Received Channel Packet:\n%s\nExpected YAPP Packet:\n%s", chan_pkt.sprint(), yapp_pkt.sprint()))
		   miscompare_ch[paddr]++;
	       end
	     end // forever
	   endtask : check_packet 

	// UVM check_phase - checks for empty scoreboard queues 
	function void check_phase(uvm_phase phase);
	  `uvm_info(get_type_name(), "Scoreboard: Checking Router Scoreboard", UVM_LOW)
	  if (yapp_fifo.is_empty() && chan0_fifo.is_empty() && chan1_fifo.is_empty() && chan2_fifo.is_empty())
	   `uvm_info(get_type_name(), "Check:\n\n   Router Scoreboard Empty!\n", UVM_LOW)
	  else
	  `uvm_error(get_type_name(), $sformatf( { "Check:\n\nWARNING: Router Scoreboard FIFO's NOT Empty:\n", 
	    "     YAPP : %0d     Chan0 : %0d     Chan1 : %0d     Chan2 : %0d" } , 
	    yapp_fifo.size(), chan0_fifo.size(), chan1_fifo.size(), chan2_fifo.size()))
	endfunction : check_phase

	// UVM report_phase - prints the results
	function void report_phase(uvm_phase phase);
	  `uvm_info(get_type_name(), $sformatf( { "Report:\n\n   Scoreboard: Packet Statistics \n     " , 
	    "     Packets In:\t%0d\n" , 
	    "     Packets Dropped:\t%0d\n" , 
	    "       - Address 3 packets:\t%0d\n" ,
	    "       - Oversized packets:\t%0d\n" ,
	    "       - Disabled packets:\t%0d\n" ,
	    "     Packets Valid:\t%0d\n\n" , 
	    "     Channel 0 Total: %0d  Pass: %0d  Miscompare: %0d\n" , 
	    "     Channel 1 Total: %0d  Pass: %0d  Miscompare: %0d\n" , 
	    "     Channel 2 Total: %0d  Pass: %0d  Miscompare: %0d\n\n" }, 
	    packets_in, packets_dropped, bad_addr_packets, jumbo_packets, disabled_packets, packets_valid,
	    packets_ch[0], compare_ch[0], miscompare_ch[0], 
	    packets_ch[1], compare_ch[1], miscompare_ch[1], 
	    packets_ch[2], compare_ch[2], miscompare_ch[2]), UVM_LOW)
	  if ((miscompare_ch[0] + miscompare_ch[1] + miscompare_ch[2]) > 0)
	    `uvm_error(get_type_name(),"Status:\n\nSimulation FAILED\n")
	  else
	    `uvm_info(get_type_name(),"Status:\n\nSimulation PASSED\n", UVM_NONE)
	endfunction : report_phase

endclass : router_fifo_scoreboard
