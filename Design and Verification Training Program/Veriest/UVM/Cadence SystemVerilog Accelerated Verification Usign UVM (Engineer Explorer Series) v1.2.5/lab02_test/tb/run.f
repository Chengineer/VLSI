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

// include directories
//*** add incdir include directories here
-incdir ../sv

// compile files
//*** add compile files here
../sv/yapp_pkg.sv
top.sv

// options
//+UVM_TESTNAME=base_test
//+UVM_VERBOSITY=UVM_HIGH
+UVM_VERBOSITY=UVM_LOW
+UVM_TESTNAME=test2
