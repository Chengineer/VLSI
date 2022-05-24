/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;

  // YAPP Interface to the DUT
  yapp_if in0 (clock, reset);

  // Clock and Reset interface instantiation
  // (clock_and_reset UVC does not create the clock directly but supplies control signals to the clkgen instance. clkgen generates the clock, and the clock is passed back into the clock and reset interface to synchronize the reset generation. the clock and reset interface has a clock input port, but reset, run_clock and clock_period output ports. the run_clock and clock_period interface outputs must be connected to the clkgen ports, which were previously hardwired to literal values. this allows clock and reset UVC sequences to control the clock generation.for simplicity, we have declared above local signals to make this connection easier).
  clock_and_reset_if clk_rst_if (
			.clock(clock), 
			.reset(reset), 
			.run_clock(run_clock), 
			.clock_period(clock_period)
  );

  // HBUS interface instantiation
  hbus_if hif (.clock(clock), .reset(reset));

  // Channels interface instantiation
  channel_if ch0if (.clock(clock), .reset(reset));
  channel_if ch1if (.clock(clock), .reset(reset));
  channel_if ch2if (.clock(clock), .reset(reset));

  // CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );

  yapp_router dut(
    .reset(reset),
    .clock(clock),
    .error(),
    // YAPP interface signals connection
    .in_data(in0.in_data),
    .in_data_vld(in0.in_data_vld),
    .in_suspend(in0.in_suspend),
    // Output Channels
    //Channel 0   
    .data_0(ch0if.data),
    .data_vld_0(ch0if.data_vld),
    .suspend_0(ch0if.suspend),
    //Channel 1   
    .data_1(ch1if.data),
    .data_vld_1(ch1if.data_vld),
    .suspend_1(ch1if.suspend),
    //Channel 2   
    .data_2(ch2if.data),  
    .data_vld_2(ch2if.data_vld),
    .suspend_2(ch2if.suspend),
    // Host Interface Signals
    .haddr(hif.haddr),
    .hdata(hif.hdata_w),
    .hen(hif.hen),
    .hwr_rd(hif.hwr_rd));

// Now the reset will be generated by the clock_and_reset UVC, so we don't need that block which generates the reset waveform
//  initial begin
//    reset <= 1'b0;
//    //in0.in_suspend <= 1'b0;
//    @(negedge clock)
//      #1 reset <= 1'b1;
//    @(negedge clock)
//      #1 reset <= 1'b0;
//  end

endmodule
