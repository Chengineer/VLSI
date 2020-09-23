
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution				

module dtop #(parameter scBusSize=37,parameter cntrlBusSize=8) (
	 input [scBusSize-1:0] scin
	,input [cntrlBusSize-1:0] cntrl
	,output [scBusSize-1:0] scout		
);	
	// inner signals (the communication between embed and permutator):
	wire [scBusSize-1:0] ins;
	wire [scBusSize-1:0] ous;
	
	// wiring the entire system:
	permutator Permutator1(.in(scin),.cntrl(cntrl[3:0]),.out(ins));// instantiation of the first permutator module
	embed Embed(.ins(ins),.ous(ous));
	permutator Permutator2(.in(ous),.cntrl(cntrl[7:4]),.out(scout));// instantiation of the second permutator module

endmodule
