`include "math.sv"
module dpi();
	import "DPI-C" function int system(input string command);
	import "DPI-C" function string getenv(input string name);
	import "DPI-C" function real sin(input real x);

	initial begin
		int ok = system("echo 'Hello World'");
		ok = system("date");
		$display("PATH environmental variable: %s", getenv("PATH"));
		for (int i = 0; i<8; i = i+1)
			begin
				$display("sin(%f) = %f", i*(`M_PI_4),sin(i*(`M_PI_4)) );
			end
	end

endmodule
