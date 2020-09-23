
module permutator #(parameter scBusSize=37, parameter cntrlSize=4) (
	input [scBusSize-1:0] in
	,input [cntrlSize-1:0] cntrl
	,output reg [scBusSize-1:0] out
);
	
	// different permutations 
	always @(*) begin
		case(cntrl)
			4'd0:out=~in;
			4'd1:out=in<<1;
			4'd2:out=in>>1;
			4'd3:out=in;
			4'd4:out={37{in[4]}};
			4'd5:out={in[15:0],in[36:20],in[19:16]};
			4'd6:out=in>>>6;
			4'd7:out=in&in;
			4'd8:out=in|in;
			4'd9:out=in^in;
			4'd10:out=in~^in;
			4'd11:out=in[36:0]; 
			4'd12:out=in<<2;
			4'd13:out=in>>2;
			4'd14:out={in[0],in[35:1],in[36]};
			4'd15:out=in<<<5;
		endcase
	end
endmodule



