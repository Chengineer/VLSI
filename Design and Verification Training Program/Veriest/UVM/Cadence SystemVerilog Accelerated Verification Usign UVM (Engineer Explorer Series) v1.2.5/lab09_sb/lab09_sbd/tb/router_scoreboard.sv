// enum type for comparer policy 
typedef enum bit {EQUALITY, UVM} comp_t;

class router_scoreboard extends uvm_scoreboard;

	// variable for comparer policy
	comp_t compare_policy = UVM;

	// component utility macro
	`uvm_component_utils_begin(router_scoreboard)
		`uvm_field_enum(comp_t, compare_policy, UVM_ALL_ON)
	`uvm_component_utils_end

	// TLM port declarations
	`uvm_analysis_imp_decl(_yapp)
	`uvm_analysis_imp_decl(_chan0)
	`uvm_analysis_imp_decl(_chan1)
	`uvm_analysis_imp_decl(_chan2)

	// handles declarations for the subsequent subclasses
	uvm_analysis_imp_yapp #(yapp_packet, router_scoreboard) sb_yapp_in;
	uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) sb_chan0;
	uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) sb_chan1;
	uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) sb_chan2;

	// Scoreboard Packet Queues
	yapp_packet sb_queue0[$];
	yapp_packet sb_queue1[$];
	yapp_packet sb_queue2[$];
   
	// Scoreboard Statistics
	int packets_in,  in_dropped;
	int packets_ch0, compare_ch0, miscompare_ch0, dropped_ch0;
	int packets_ch1, compare_ch1, miscompare_ch1, dropped_ch1;
	int packets_ch2, compare_ch2, miscompare_ch2, dropped_ch2;

	// constructor
	function new(string name="", uvm_component parent=null);
		super.new(name, parent);
		// construct instances using direct constructor calls
		sb_yapp_in = new("sb_yapp_in", this);
		sb_chan0 = new("sb_chan0", this);
		sb_chan1 = new("sb_chan1", this);
		sb_chan2 = new("sb_chan2", this);
	endfunction

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
    // we call compare_field off a uvm_comparer instance, either passed as an argument, or created locally. the required arguments are a string name used to report mismatches, the two fields to be compared and the number of bits to compare.
    comp_uvm = comparer.compare_field("addr", yp.addr, cp.addr,2);
    comp_uvm &= comparer.compare_field("length", yp.length, cp.length,6);
    // we use a foreach loop for the payload. we declare a string variable str and use the string method itoa to convert the foreach loop variable into a string for concatenation into the name argument, so we can report which, if any, payload locations do not match. we also use the name of the function to store the return value.
    foreach (yp.payload [i]) begin
      str.itoa(i);
      comp_uvm &= comparer.compare_field({"payload[",str,"]"}, yp.payload[i], cp.payload[i],8);
    end
    comp_uvm &= comparer.compare_field("parity", yp.parity, cp.parity,8);
  endfunction
	// clone the received YAPP packet, increment the packets_in counter, and then push the clone to the correct queue based on its address.
	virtual function void write_yapp(yapp_packet packet);
		yapp_packet sb_packet;
		// make a clone for storing in scoreboard
		$cast(sb_packet, packet.clone()); // clone returns uvm_object type
		packets_in++;
		// push the clone to the correct queue based on its address
		case (sb_packet.addr)
			2'b00:	begin
					sb_queue0.push_back(sb_packet);
					`uvm_info(get_type_name(), "Added packet to Scoreboard Queue 0", UVM_HIGH)
				end
			2'b01:	begin
					sb_queue1.push_back(sb_packet);
					`uvm_info(get_type_name(), "Added packet to Scoreboard Queue 1", UVM_HIGH)
				end
			2'b10:	begin
					sb_queue2.push_back(sb_packet);
					`uvm_info(get_type_name(), "Added packet to Scoreboard Queue 2", UVM_HIGH)
				end
			// illegal address 3 packets are separately counted and reported with a UVM_LOW verbosity
			default: begin
					`uvm_info(get_type_name(), $sformatf("Packet Dropped: Bad Address=%d\n%s", sb_packet.addr, sb_packet.sprint()), UVM_LOW)
					in_dropped++;
				 end
		endcase
	endfunction

	// channel 0 packet check (write) implementation
	virtual function void write_chan0(input channel_packet packet);
		bit pktcompare;
		yapp_packet sb_packet;
		packets_ch0++; // increment the channel counter
		if(sb_queue0.size() == 0) begin // check if the queue is empty
			`uvm_error(get_type_name(), $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_0 Packet!\n%s", packet.sprint()))
			dropped_ch0++;
			return;
		end
		// compare the yapp_packet at the front of the queue with the channel_packet, using the selected comparison function
		if(compare_policy == UVM)
			// use custom comparer with UVM methos
			pktcompare = comp_uvm(sb_queue0[0], packet);
		else
			// use custom comparer with equality operators
			pktcompare = comp_equal(sb_queue0[0], packet);
		// for a match, we remove the yapp_packet from the queue and increment the match counter
		if(pktcompare) begin
			void'(sb_queue0.pop_front());
			`uvm_info(get_type_name(), $sformatf("Scoreboard Compare Match: Channel_0 Packet\n%s", packet.sprint()), UVM_MEDIUM)
			compare_ch0++;
		end
		// for a mismatch, we raise an error, increment a mismatch counter and leave the yapp_packet in the queue
		// we are hoping that if the stored yapp_packet doesn't match the current channel_packet, then it might match the next one. but normally a mismatch indicates a serious problem. we could report a FATAL, but more information, perhaps over multiple mismatches, may help debug the problem. so we continue the simulation. 
		else begin
			sb_packet = sb_queue0[0];
			`uvm_warning(get_type_name(), $sformatf("Scoreboard Error [MISCOMPARE]: Received Channel_0 Packet:\n%s\nExpected Channel_0 Packet:\n%s", packet.sprint(), sb_packet.sprint()))
        		miscompare_ch0++;
		end
	endfunction

	// channel 1 packet check (write) implementation
	virtual function void write_chan1(input channel_packet packet);
		bit pktcompare;
		yapp_packet sb_packet;
		packets_ch1++;
		if(sb_queue1.size() == 0) begin
			`uvm_error(get_type_name(), $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_1 Packet!\n%s", packet.sprint()))
			dropped_ch0++;
			return;
		end
		if(compare_policy == UVM)
			// use custom comparer with UVM methos
			pktcompare = comp_uvm(sb_queue1[0], packet);
		else
			// use custom comparer with equality operators
			pktcompare = comp_equal(sb_queue1[0], packet);
		if(pktcompare) begin
			void'(sb_queue1.pop_front());
			`uvm_info(get_type_name(), $sformatf("Scoreboard Compare Match: Channel_1 Packet\n%s", packet.sprint()), UVM_MEDIUM)
			compare_ch1++;
		end
		else begin
			sb_packet = sb_queue1[0];
			`uvm_warning(get_type_name(), $sformatf("Scoreboard Error [MISCOMPARE]: Received Channel_1 Packet:\n%s\nExpected Channel_1 Packet:\n%s", packet.sprint(), sb_packet.sprint()))
        		miscompare_ch1++;
		end
	endfunction

	// channel 2 packet check (write) implementation
	virtual function void write_chan2(input channel_packet packet);
		bit pktcompare;
		yapp_packet sb_packet;
		packets_ch2++;
		if(sb_queue2.size() == 0) begin
			`uvm_error(get_type_name(), $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_2 Packet!\n%s", packet.sprint()))
			dropped_ch2++;
			return;
		end
		if(compare_policy == UVM)
			// use custom comparer with UVM methos
			pktcompare = comp_uvm(sb_queue2[0], packet);
		else
			// use custom comparer with equality operators
			pktcompare = comp_equal(sb_queue2[0], packet);
		if(pktcompare) begin
			void'(sb_queue2.pop_front());
			`uvm_info(get_type_name(), $sformatf("Scoreboard Compare Match: Channel_2 Packet\n%s", packet.sprint()), UVM_MEDIUM)
			compare_ch2++;
		end
		else begin
			sb_packet = sb_queue2[0];
			`uvm_warning(get_type_name(), $sformatf("Scoreboard Error [MISCOMPARE]: Received Channel_2 Packet:\n%s\nExpected Channel_2 Packet:\n%s", packet.sprint(), sb_packet.sprint()))
        		miscompare_ch2++;
		end
	endfunction

	// UVM check_phase - checks if the queues are empty, reports an error if not
	function void check_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "Checking Router Scoreboard", UVM_LOW)
		if(sb_queue0.size() || sb_queue1.size() || sb_queue2.size())
			  `uvm_error(get_type_name(), $sformatf("Check:\n\n   WARNING: Router Scoreboard Queue's NOT Empty:\n     Chan 0: %0d\n     Chan 1: %0d\n     Chan 2: %0d\n", sb_queue0.size(), sb_queue1.size(), sb_queue2.size()))

		else
			`uvm_info(get_type_name(), "Check:\n\n   Router Scoreboard Empty!\n", UVM_LOW)
	endfunction

	// UVM report phase - summarizes the scoreboard results.
	// prints all our counters for: packets received, dropped, matching or mismatching. then prints a definitive pass or fail message.
	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(), $sformatf("Report:\n\n   Scoreboard: Packet Statistics \n     Packets In:   %0d     Packets Dropped: %0d\n     Channel 0 Total: %0d  Pass: %0d  Miscompare: %0d  Dropped: %0d\n     Channel 1 Total: %0d  Pass: %0d  Miscompare: %0d  Dropped: %0d\n     Channel 2 Total: %0d  Pass: %0d  Miscompare: %0d  Dropped: %0d\n\n", packets_in, in_dropped, packets_ch0, compare_ch0, miscompare_ch0, dropped_ch0, packets_ch1, compare_ch1, miscompare_ch1, dropped_ch1, packets_ch2, compare_ch2, miscompare_ch2, dropped_ch2), UVM_LOW)
		if ((miscompare_ch0 + miscompare_ch1 + miscompare_ch2 + dropped_ch0 + dropped_ch1 + dropped_ch2) > 0)
    `uvm_error(get_type_name(),"Status:\n\nSimulation FAILED\n")
		else
    `uvm_info(get_type_name(),"Status:\n\nSimulation PASSED\n", UVM_NONE)
	endfunction

endclass: router_scoreboard
