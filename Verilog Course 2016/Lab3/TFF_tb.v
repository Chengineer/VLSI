/* Chen Grapel. Verilog Course Exercise 3: T-Flip Flop test bench. Filename: TFF_tb.v */
`include "TFF.v"
`timescale 1ns / 100ps// result evaluated every 1nsec with 100psec resolution

module TFF_tb();// module name and ports list

reg t,nrst,clk;
wire q;

task expect(input xq);// check if q has the wrong value   
	if (q!==xq)
	begin      
		$display("TEST FAILED");// print to the console screen       
		$display("time=%0d t=%b nrst=%b q=%b",$time,t,nrst,q);     
		$display("q should be %b",xq);      
		$finish;// finish the program if q has the wrong value   
	end  
endtask  

TFF UUT(t,nrst,clk,q);// instantiation of the TFF

initial
begin
t=1'b0; nrst=1'b0; clk=1'b0; // initial input values
$monitor($time,"t=%b,nrst=%b,clk=%b,q=%b",t,nrst,clk,q);// System monitoring function
end

initial 
clk=1;

initial repeat (8) 
begin// setting the clock phases 
 #1 clk=0; 
 #1 clk=1; 
 end  
 
initial @(posedge clk) /* at every positive edge of the clock, go to the task with the appropriate argument */
begin     
{t,nrst}=2'b10; @(posedge clk) expect (0);  
{t,nrst}=2'b01; @(posedge clk) expect (0);    
{t,nrst}=2'b11; @(posedge clk) expect (1);    
{t,nrst}=2'b00; @(posedge clk) expect (0);    
$display("TEST PASSED");// print to the console screen     
$finish;// finish the program after passing all tests  
end

endmodule


