///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mux.sv
// Title       : MUX module 
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the mux module 
// Notes       :
//
///////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ns

module mux
(
  input  logic       clock  ,
  input  logic [3:0] ip1    ,
  input  logic [3:0] ip2    ,
  input  logic [3:0] ip3    ,
  input  logic       sel1   ,
  input  logic       sel2   ,
  input  logic       sel3   ,
  output logic [3:0] mux_op  
) ;

always @(posedge clock)
  if (sel1 == 1)
    mux_op <= ip1 ;
  else
    if (sel2 == 1)
      mux_op <= ip2 ;
    else
      if (sel3 == 1)
        mux_op <= ip3 ;

// assertions go here
//#### edit ###
property P1;
	@(posedge clock) (sel1 == 1'b1) |=> (mux_op == $past(ip1,1));
endproperty

property P2;
	@(posedge clock) (sel2 == 1'b1) |=> (mux_op == $past(ip2,1));
endproperty

property P3;
	@(posedge clock) (sel3 == 1'b1) |=> (mux_op == $past(ip3,1));
endproperty


A1 : assert property (P1)
	else
		$warning("P1 failed");

A2 : assert property (P2)
	else
		$warning("P2 failed");

A3 : assert property (P3)
	else
		$warning("P3 failed");


//#### end of edit ###
endmodule
