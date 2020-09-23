/* Chen Grapel. Logic Design Course Exercise 1 (part A section D): 1-bit mux. Filename: SEC1_D.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module mux1(input a,b,sel,output out);// module name and ports list

	wire not_sel,and_a,and_b;// inner wiring signals
	// implementation of 1bit wide mux using Verilog's generic gates (instantiation by position):
	not U1(not_sel,sel);
	and U2(and_a,a,sel);
	and U3(and_b,b,not_sel);
	or U4(out,and_a,and_b);
	
endmodule

// implementation of 8-bit mux using the 1-bit mux module (instantiation by name)
module mux8_2D #(parameter WIDTH=8)(input [(WIDTH-1):0]a,b,input sel,output [(WIDTH-1):0]out);// module name and ports list

	genvar i;
	generate
		for(i=0;i<WIDTH;i=i+1)
			begin:mux
				mux1 MUX8(.a(a[i]),.b(b[i]),.sel(sel),.out(out[i]));
			end
	endgenerate

endmodule


