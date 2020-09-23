/* Chen Grapel. Logic Design Course Exercise 1 (part A section B): 8-bit mux. Filename: SEC1_B.v */
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

// "..once with an if.."
module mux8_2B #(parameter WIDTH=8)(input [(WIDTH-1):0]a,b,input sel,output reg [(WIDTH-1):0]out);// module name and ports list
 
	always @(*)
		begin
			if(sel)// if select bit=1:out=a
				out=a;
			else// if select bit=0:out=b
				out=b;
		end

endmodule

// "..once with a case."
module mux8_2B2 #(parameter WIDTH=8)(input [(WIDTH-1):0]a,b,input sel,output reg [(WIDTH-1):0]out);// module name and ports list

	always @(*)
		begin
			case(sel)
				1'd0:// if select bit=0:out=b
					begin
						out=b;
					end
				1'd1:// if select bit=1:out=a
					begin
						out=a;
					end
			endcase// valid "sel" assumption (ommiting default case)
		end

endmodule
