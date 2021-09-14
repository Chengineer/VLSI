///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : control.sv
// Title       : Control Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Control module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

// import SystemVerilog package for opcode_t and state_t

module control import typedefs::*;
	(
	output logic      load_ac ,
	output logic      mem_rd  ,
	output logic      mem_wr  ,
	output logic      inc_pc  ,
	output logic      load_pc ,
	output logic      load_ir ,
	output logic      halt    ,
	input  opcode_t opcode  , // opcode type name must be opcode_t
	input             zero    ,
	input             clk     ,
	input             rst_   
	);
// SystemVerilog: time units and time precision specification
timeunit 1ns;
timeprecision 100ps;

state_t state;

always_ff @(posedge clk or negedge rst_)
	begin
		if (!rst_)
			state <= 0;
		else
			state <= state.next();
	end


always_comb
	begin
		unique case (state)
			0: 
				begin
					mem_rd = 0;
					load_ir = 0;
					halt = 0;
					inc_pc = 0;
					load_ac = 0;
					load_pc = 0;
					mem_wr = 0;	  
				end
			1: 
				begin
					mem_rd = 1;
					load_ir = 0;
					halt = 0;
					inc_pc = 0;
					load_ac = 0;
					load_pc = 0;
					mem_wr = 0;
				end
			2:
				begin
					mem_rd = 1;
					load_ir = 1;
					halt = 0;
					inc_pc = 0;
					load_ac = 0;
					load_pc = 0;
					mem_wr = 0;
				end
			3:
				begin
					mem_rd = 1;
					load_ir = 1;
					halt = 0;
					inc_pc = 0;
					load_ac = 0;
					load_pc = 0;
					mem_wr = 0;
				end
			4:
				begin
					mem_rd = 0;
					load_ir = 0;
					if (opcode == HLT)
						halt = 1;
					else
						halt = 0;	      
					inc_pc = 1;
					load_ac = 0;
					load_pc = 0;
					mem_wr = 0;
				end
			5:
				begin
					if ((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA))
						mem_rd = 1;
					else
						mem_rd = 0;
					load_ir = 0;
					halt = 0;
					inc_pc = 0;
					load_ac = 0;
					load_pc = 0;
					mem_wr = 0;
				end
			6:
				begin
					if ((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA))
						begin
							mem_rd = 1;
							load_ac = 1;
						end
					else
						begin
							mem_rd = 0;
							load_ac = 0;
						end
					load_ir = 0;
					halt = 0;
					if ((opcode == SKZ) && (zero == 1))
						inc_pc = 1;
					else
						inc_pc = 0;
					if (opcode == JMP)
						load_pc = 1;
					else
						load_pc = 0;
					mem_wr = 0;
				end
			7:
				begin
					if ((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA))
						begin
							mem_rd = 1;
							load_ac = 1;
						end
					else
						begin
							mem_rd = 0;
							load_ac = 0;
						end
					load_ir = 0;
					halt = 0;
					if (opcode == JMP)
						begin
							load_pc = 1;
							inc_pc = 1;
						end
					else
						begin
							load_pc = 0;
							inc_pc = 0;
						end
					if (opcode == STO)
						mem_wr = 1;
					else
						mem_wr = 0;
				end
			default: 
				begin
					mem_rd = 'x;
					load_ir = 'x;
					halt = 'x;
					inc_pc = 'x;
					load_ac = 'x;
					load_pc = 'x;
					mem_wr = 'x;
				end
		endcase // case begin
	end

endmodule
