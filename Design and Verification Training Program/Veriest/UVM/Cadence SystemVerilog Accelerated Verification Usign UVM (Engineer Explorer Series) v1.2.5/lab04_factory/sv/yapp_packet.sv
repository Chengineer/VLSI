/*-----------------------------------------------------------------
File name     : yapp_packet.sv
Description   : lab01_data YAPP UVC packet template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

// Define your enumerated type(s) here
typedef enum bit {BAD_PARITY, GOOD_PARITY} parity_type_e;

class yapp_packet extends uvm_sequence_item;

// Follow the lab instructions to create the packet.
// Place the packet declarations in the following order:

  // Define protocol data
	rand	bit [1:0] 	addr;
	rand 	bit [5:0] 	length;
	rand 	bit [7:0] 	payload[];
		bit [7:0] 	parity;

  // Define control knobs
	rand 	parity_type_e	parity_type;
	rand 	int 		packet_delay;

  // Enable automation of the packet's fields
	`uvm_object_utils_begin(yapp_packet)
		`uvm_field_int(addr, UVM_DEFAULT)
		`uvm_field_int(length, UVM_DEFAULT)
		`uvm_field_array_int(payload, UVM_DEFAULT)
		`uvm_field_int(parity, UVM_DEFAULT + UVM_BIN)
		`uvm_field_enum(parity_type_e, parity_type, UVM_DEFAULT)
		`uvm_field_int(packet_delay, UVM_DEFAULT + UVM_NOCOMPARE + UVM_DEC)
	`uvm_object_utils_end

  // Define packet constraints
	constraint valid_address {addr != 2'b11;}
	constraint packet_length {length >= 1; length <= 63;}
	constraint payload_size {payload.size() == length;}
	constraint parity_dist {parity_type dist {GOOD_PARITY := 5, BAD_PARITY := 1};}
	constraint pckt_delay {packet_delay >= 1; packet_delay <= 20;}

  // Add methods for parity calculation and class construction
	function new(string name = "yapp_packet");
		super.new(name);
	endfunction

	function bit [7:0] calc_parity();
		bit [7:0] temp_parity = {length, addr};
		foreach (payload[i])
			begin
				temp_parity = temp_parity ^ payload[i];
			end
		calc_parity = temp_parity;
	endfunction

	function void set_parity();
		parity = calc_parity();
		if(parity_type == BAD_PARITY)
			parity = ~parity;
	endfunction

	function void post_randomize();
		set_parity();
	endfunction

endclass: yapp_packet

class short_yapp_packet extends yapp_packet;

	`uvm_object_utils(short_yapp_packet)

	function new(string name = "short_yapp_packet");
		super.new(name);
	endfunction

	constraint short_length { length < 15; }
	constraint short_address { addr != 2'b10; }

endclass: short_yapp_packet
