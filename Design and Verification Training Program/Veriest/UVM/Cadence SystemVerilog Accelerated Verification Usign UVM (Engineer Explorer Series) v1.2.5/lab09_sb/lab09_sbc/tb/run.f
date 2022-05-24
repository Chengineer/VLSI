/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64

-uvmhome $UVMHOME

// default timescale
-timescale 1ns/1ns

// uncomment for gui
// -gui
// +access+rwc

// include directories
//*** add incdir include directories here
// we need an incdir to the sv directory of the UVCs to resolve includes used in the package
-incdir ../../yapp/sv
// compile files
//*** add compile files here
../../yapp/sv/yapp_pkg.sv
../../yapp/sv/yapp_if.sv
-incdir ../../channel/sv
../../channel/sv/channel_pkg.sv
../../channel/sv/channel_if.sv
-incdir ../../clock_and_reset/sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../clock_and_reset/sv/clock_and_reset_if.sv
-incdir ../../hbus/sv
../../hbus/sv/hbus_pkg.sv
../../hbus/sv/hbus_if.sv
-incdir ../sv
../sv/router_module_pkg.sv


clkgen.sv
hw_top.sv
tb_top.sv
../../router_rtl/yapp_router.sv



// options
//+UVM_TESTNAME=base_test
//+UVM_VERBOSITY=UVM_HIGH
//+UVM_VERBOSITY=UVM_LOW
//+UVM_TESTNAME=test2
//+UVM_TESTNAME=short_packet_test
//+UVM_TESTNAME=set_config_test
//+UVM_TESTNAME=incr_payload_test
+UVM_VERBOSITY=UVM_FULL
//+UVM_TESTNAME=exhaustive_seq_test
//+UVM_TESTNAME=short_yapp_012_test
//+UVM_TESTNAME=simple_test
//+UVM_TESTNAME=test_uvc_integration
+UVM_TESTNAME=router_mctest
