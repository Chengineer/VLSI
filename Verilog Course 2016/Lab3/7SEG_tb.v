/* Chen Grapel. Verilog Course Exercise 3: 7-segment decoder test bench. Filename: 7SEG_tb.v */
`include "7SEG.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module SEVEN_SEGMENT_tb();
reg [3:0]HexIn;
wire [6:0]SEG;

task expect(input [6:0]xseg);// check if the wrong segments are on/off
	if (SEG!==xseg)
	begin      
		$display("TEST FAILED");// print to the console screen     
		$display("time=%0d HexIn=%h SEG=%b xseg=%b",$time,HexIn,SEG,xseg);      
		$display("SEG should be %h",xseg);      
		$finish;// finish the program if the wrong segments are on/off   
	end  
endtask  

SEVEN_SEGMENT UUT(HexIn,SEG);// instantiation of the SEVEN_SEGMENT

initial
begin
HexIn=4'hF;// initial input value is F (hexadecimal)
$monitor($time,"HexIn=%h,SEG=%b",HexIn,SEG);// System monitoring function
end

initial repeat (16) 
begin  
#1 ;// 1 time unit delay
#1 HexIn=HexIn+4'h1;// every #2 time units,increase the input value by 1
end  

initial @(HexIn)// whenever HexIn changes, go to the task with the appropriate argument
begin  
@(HexIn) expect (7'h3F);
@(HexIn) expect (7'h06);
@(HexIn) expect (7'h5B);
@(HexIn) expect (7'h4F);
@(HexIn) expect (7'h66);
@(HexIn) expect (7'h6D);
@(HexIn) expect (7'h7D);
@(HexIn) expect (7'h07);
@(HexIn) expect (7'h7F);
@(HexIn) expect (7'h6F);
@(HexIn) expect (7'h77);
@(HexIn) expect (7'h7F);
@(HexIn) expect (7'h39);
@(HexIn) expect (7'h3F);
@(HexIn) expect (7'h79);  
@(HexIn) expect (7'h71);
end

initial // finish the program after passing all the tests
begin
#34 $display("TEST PASSED");// print to the console screen   
$finish;  
end

endmodule
