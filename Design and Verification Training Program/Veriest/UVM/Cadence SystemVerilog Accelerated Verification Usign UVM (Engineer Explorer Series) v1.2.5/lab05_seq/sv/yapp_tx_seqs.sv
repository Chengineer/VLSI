/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base yapp sequence - base sequence with objections from which 
// all sequences can be derived
//
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

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

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets

// yapp_1_seq - single packet to address 1
class yapp_1_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_1_seq)

  // Constructor
  function new(string name="yapp_1_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
    `uvm_do_with(req, {req.addr == 2'b01;})
  endtask
  
endclass : yapp_1_seq

// yapp_012_seq - three packets with incrementing addresses
class yapp_012_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_012_seq)

  // Constructor
  function new(string name="yapp_012_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
    `uvm_do_with(req, {req.addr == 2'b00;})
    `uvm_do_with(req, {req.addr == 2'b01;})
    `uvm_do_with(req, {req.addr == 2'b10;})
  endtask
  
endclass : yapp_012_seq

// yapp_111_seq - three packets to address 1
class yapp_111_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_111_seq)

  // Constructor
  function new(string name="yapp_111_seq");
    super.new(name);
  endfunction
  
  // handle for yapp_1_seq sequence (nested sequence)
  yapp_1_seq y1s;

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)
    repeat(3)
        `uvm_do(y1s)
  endtask
  
endclass : yapp_111_seq

// yapp_repeat_addr_seq - two packets to the same (random) address
class yapp_repeat_addr_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_repeat_addr_seq)

  // Constructor
  function new(string name="yapp_repeat_addr_seq");
    super.new(name);
  endfunction
  
  // rand sequence property and constraint
  rand bit [1:0] seqadd;
  constraint c1 {seqadd != 2'b11;}

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq sequence", UVM_LOW)
    repeat(2)
        `uvm_do_with(req, {req.addr == seqadd;}) // use the sequence property inside do macro to define constraint on the address
    // alternative:
    // `uvm_do(req) // create one randomized packet first
    // seqadd = req.addr; // then save the address of that packet into a local variable
    // `uvm_do_with(req, {req.addr == seqadd;}) // then use that variable in a constraint on the second packet, to make sure it has the same address as the first
  endtask
  
endclass : yapp_repeat_addr_seq

// yapp_incr_payload_seq - generate a single packet with incrementing payload data
class yapp_incr_payload_seq extends yapp_base_seq;
  
  int ok;
  // Required macro for sequences automation
  `uvm_object_utils(yapp_incr_payload_seq)

  // Constructor
  function new(string name="yapp_incr_payload_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)
    // `uvm_do_with(req, {foreach (payload[i]) payload[i] == i;})
    `uvm_create(req) // create a handle in req
    ok = req.randomize(); // manually randomize req in order to create a legal packet, where length is equal to the number of values in the payload
    foreach (req.payload[i])
        req.payload[i] = i; // overqrite the contents of the payload to give them incrementing values
    req.set_parity(); // recalculate parity taking into account parity_type
    `uvm_send(req) // send without further randomization, so we dont break the incrementing payload sequence we've just created
  endtask
  
endclass : yapp_incr_payload_seq

// yapp_rnd_seq - generate a random number of packets
class yapp_rnd_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_rnd_seq)

  // Constructor
  function new(string name="yapp_rnd_seq");
    super.new(name);
  endfunction

  // rand sequence property and constraint
  rand int count;
  constraint count_limit {count > 0; count < 11;}

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Executing yapp_rnd_seq sequence %0d times", count), UVM_LOW)
    repeat(count) begin
        `uvm_do(req) 
    end
  endtask
  
endclass : yapp_rnd_seq

// six_yapp_seq - nested sequence yapp_rand_seq with count constrained to six
class six_yapp_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(six_yapp_seq)

  // Constructor
  function new(string name="six_yapp_seq");
    super.new(name);
  endfunction

  yapp_rnd_seq yrands;// handle for previously defined sequence

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing six_yapp_seq sequence", UVM_LOW)
    `uvm_do_with(yrands, {count == 6;}) 
  endtask
  
endclass : six_yapp_seq

// yapp_exhaustive_seq - execute all sequences to test
class yapp_exhaustive_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_exhaustive_seq)

  // Constructor
  function new(string name="yapp_exhaustive_seq");
    super.new(name);
  endfunction

  // handles for all current lab's sequences
  yapp_1_seq y1s;
  yapp_012_seq y012s;
  yapp_111_seq y111s;
  yapp_repeat_addr_seq yRepAddrs;
  yapp_incr_payload_seq yIncPlds;
  yapp_rnd_seq yRands;
  six_yapp_seq ySixs;

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq sequence", UVM_LOW)
    // execute the sequences
    `uvm_do(y1s)
    `uvm_do(y012s)
    `uvm_do(y111s)
    `uvm_do(yRepAddrs)
    `uvm_do(yIncPlds)
    `uvm_do(yRands)
    `uvm_do(ySixs)
  endtask
  
endclass : yapp_exhaustive_seq








