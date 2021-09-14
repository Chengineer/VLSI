module register #(parameter WIDTH = 8)(
				       input logic [WIDTH-1:0] data,
				       input  clk,
				       input  enable,
				       input  rst_,
				       output logic [WIDTH-1:0] out
				       );
   timeunit 1ns;
   timeprecision 100ps;
   
   always_ff @(posedge clk or negedge rst_)
     begin
	if(!rst_)
	  out <= 0;
	else if (enable)
	  out <= data;
     end

endmodule
	  