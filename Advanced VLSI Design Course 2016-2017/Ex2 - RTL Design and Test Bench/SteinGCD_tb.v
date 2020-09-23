/* Chen Grapel. Digital VLSI design course. Exercise 2: Stein's GCD algorithm FSM test bench. File name: SteinGCD_tb.v*/

`include "/projects/kits/tsmc/tsmc65LP/dig_libs/CORE/TSMCHOME/digital/Front_End/verilog/tcbn65lp_200a/tcbn65lp.v"
`include "../exports/my_netlist.v"
`timescale 1ns / 100ps

module SteinGCD_tb();

	localparam INIT=3'd0;
	localparam EVENEVEN=3'd1;
	localparam EVENODD=3'd2;
	localparam ODDODD=3'd3;
	localparam FINALGCD=3'd4;
	parameter usize=6;
	parameter vsize=5;

	reg [usize-1:0] u;
	reg [vsize-1:0] v;
	reg clk;
	reg nrst;
	wire [usize-1:0] gcd;

	reg [500:0] state_msg;
	reg [500:0] get_rid_of;
	reg [usize-1:0] gcdFromTextFile;
	integer i;
	integer j;
	integer data_file;// input file
	integer test_file;// output file

	SteinGCD UUT(.u(u),.v(v),.clk(clk),.rst_n(nrst),.gcd(gcd));// instantiation of SteinGCD module

	initial begin	
		u=6'd0;v=5'd0;clk=1'b0;nrst=1'b1;j=0;
		$monitor($time,"u=%d,v=%d,clk=%b,nrst=%b,gcd=%d",u,v,clk,nrst,gcd);
	end

	always @(UUT.state) begin// assign state_msg register with a string that describes each state 
		case(UUT.state)
			INIT: state_msg="start";
 			EVENEVEN: state_msg="u & v even";
		 	EVENODD: state_msg="u even,v odd or u odd,v even";
	 		ODDODD: state_msg="u & v odd";
			FINALGCD: state_msg="GCD result";
		endcase
	end

	always #1 clk=~clk;// clock declaration. cycle time=2ns

	initial begin
		data_file=$fopen("grapelc1-gcd.txt","r");// open the file grapelc1-gcd.txt for reading
		if(data_file==0)// if data_file is not found
			begin
				$display("data_file handle was NULL");
				$finish;
			end

		test_file=$fopen("grapelc1-gcd-irun.txt","w");// open a file: grapelc1-gcd-irun.txt for writing
		if(test_file==0)// if test_file is not found
			begin
				$display("test_file handle was NULL");
				$finish;
			end

		for(i=0;i<4;i=i+1)// "get rid" of the first 4 lines written in grapelc1-gcd.txt (read them into an inner register)
			begin
				$fgets(get_rid_of,data_file);
			end
	end

	always begin
		if(!$feof(data_file))// if not reaching the end of data_file
			begin
				$fscanf(data_file,"%d %d %d\n",u,v,gcdFromTextFile);// read u,v and gcd values from the current line of grapelc1-gcd.txt
				j=j+1;// the current line number of grapelc1-gcd-irun.txt
				nrst=1'b0;// reset to "prepare" the FSM for a new calculation
				#1 nrst=1'b1;// start a new calculation
				#24 
				if(gcd==gcdFromTextFile)/* if GCD result calculated in the SteinGCD module is equivalent to the GCD result taken from the grapelc1-gcd.txt, write into grapelc1-gcd-irun.txt: */
					$fwrite(test_file,"%d:\tU = %d\t\tV = %d\t\tGCD = %d\t\tGCD from text file = %d\t\t-> PASS\n",j,u,v,gcd,gcdFromTextFile);
				else
					$fwrite(test_file,"%d:\tU = %d\t\tV = %d\t\tGCD = %d\t\tGCD from text file = %d\t\t-> FAIL\n",j,u,v,gcd,gcdFromTextFile);
			end
		else
			begin
				#24 nrst=1'b0;
				#2 nrst=1'b1;// repeat the last calculation
				#8 nrst=1'b0;// reset before getting a result
				#24 $finish;
				$fclose(data_file);// close grapelc1-gcd.txt 
				$fclose(test_file);// close test_grapelc1-gcd.txt
			end	
	end
	
endmodule
