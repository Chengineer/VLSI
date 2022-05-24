class yapp_tx_driver extends uvm_driver #(yapp_packet);
	
	// component utility macro
	`uvm_component_utils(yapp_tx_driver) 

	// component constructor - required syntax for UVM automation and utilities
	function new(string name, uvm_component parent); 
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		// gets packets from the sequencer and passes them to the driver
		forever begin
			// get new item from the sequencer
			seq_item_port.get_next_item(req);
			// drive the item
			send_to_dut(req);
			// communicate item done to the sequencer
			seq_item_port.item_done();
		end
	endtask

	// gets a packet and drives it into the DUT
	task send_to_dut(yapp_packet packet); // print the packet
		`uvm_info(get_type_name(), $sformatf("Packet is \n%s", packet.sprint()), UVM_LOW)
		#10ns; // delay for easier dubegging	
	endtask

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for:", get_full_name()}, UVM_HIGH)
	endfunction

endclass: yapp_tx_driver
