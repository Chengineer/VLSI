module counter #(parameter WIDTH = 5)(
				     output logic [WIDTH-1:0] count,
				     input logic [WIDTH-1:0] data,
				     input rst_,
				     input clk,
				     input load,
				     input enable
				     );
   timeunit 1ns;
   timeprecision 100ps;

   always_ff @(posedge clk or negedge rst_)
     begin
	priority if(!rst_)
	  count <= 0;
	else if(load)
	  count <= data;
	else if(enable)
	  count <= count + 1;
     end

endmodule // counter
