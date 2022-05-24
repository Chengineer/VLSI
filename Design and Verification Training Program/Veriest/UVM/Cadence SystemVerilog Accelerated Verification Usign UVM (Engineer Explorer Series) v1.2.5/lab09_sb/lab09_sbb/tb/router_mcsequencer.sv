class router_mcsequencer extends uvm_sequencer;

	// component macro
	`uvm_component_utils(router_mcsequencer) 

	// references for the HBUS and YAPP UVC sequencer classes, that we wish 	to 		control
	// we know the YAPP sequencer type, as we wrote it, but we will need to 	use a topology report or open the file to find the type of the HBUS 		sequencer.
	// (The Channel UVCs continuously execute a single response sequence, so 	 they do not need to be controlled by the multichannel sequencer.
	//The Clock and Reset UVC could be controlled by the multichannel 		sequencer if, for example, we wanted to initiate reset during packet 		transmission. However, for simplicity we’ll leave Clock and Reset out of 	 the multichannel sequencer).
	hbus_master_sequencer	hbus_seqr;
	yapp_tx_sequencer	yapp_seqr;

	// constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	

endclass: router_mcsequencer 
