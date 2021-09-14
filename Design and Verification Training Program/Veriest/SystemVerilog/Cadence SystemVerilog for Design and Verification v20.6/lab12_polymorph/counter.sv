///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : counter.sv
// Title       : Simple class
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Simple counter class
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass;

// add counter class here  
virtual class counter;
	protected int count;
	protected int max;
	protected int min;

	function new(input int max, min, init = 0);
		count = init;
		this.max = max;
		this.min = min;	
		check_limit(max, min);
		check_set(init);
	endfunction

	function void load(input int val);
		count = val;
		check_set(val);
	endfunction

	function int getcount();
		return count;
	endfunction

	function void check_limit(input int arg1, arg2);
		if (arg1 > arg2)
			begin
				max = arg1;
				min = arg2;
			end
		else
			begin
				max = arg2;
				min = arg1;
			end
	endfunction

	function void check_set(input int set);
		if (set <= max && set >= min)
			count = set;
		else
			begin
				count = min;
				$display("Warning message: set is not within limits");
			end
	endfunction

	virtual function void next();
		$display("Counter Class");
	endfunction

endclass  

class upcounter extends counter;
	
	bit carry;
	static int cre_count;
	
	function new(input int max, min, init);
		super.new(max, min, init);
		carry = 0;
		cre_count++;
	endfunction

	function void next();
		if (count < max)
			begin
				count++;
				carry = 0;
			end
		else if (count == max)
			begin
				count = min;
				carry = 1;
			end
		$display("count after up = %0d", count);
	endfunction

	static function int get_create_count();
		return cre_count;
	endfunction

endclass

class downcounter extends counter;

	bit borrow;
	static int cre_count;

	function new(input int max, min, init);
		super.new(max, min, init);
		borrow = 0;
		cre_count++;
	endfunction

	function void next();
		if (count > min)
			begin
				count--;
				borrow = 0;
			end
		else if (count == min)
			begin
				count = max;
				borrow = 1;
			end
		$display("count after down = %0d", count);
	endfunction

	static function int get_create_count();
		return cre_count;
	endfunction

endclass

class timer;
	
	local upcounter hours;
	local upcounter minutes;
	local upcounter seconds;

	function new(input int hour = 0, minute = 0, second = 0);
		hours = new(23, 0, hour);
		minutes = new(59, 0, minute);
		seconds = new(59, 0, second);
	endfunction

	function void load(input int hr, min, sec);
		hours.load(hr);
		minutes.load(min);
		seconds.load(sec);
	endfunction

	function void showval();
		$display("hours = %2d", hours.getcount());
		$display("minutes = %2d", minutes.getcount());
		$display("seconds = %2d", seconds.getcount());
	endfunction

	function void next();
		seconds.next();
		if (seconds.carry == 1)
			begin
				minutes.next();
				if (minutes.carry == 1)
					hours.next();
			end
		showval();
	endfunction

endclass

counter c1;
upcounter u1 = new(1,5,3);
upcounter u2;


//int cnt_val;
//counter c1 = new(5,2,9);
//counter c2 = new(5,2,3);
//upcounter c3 = new(8,1,4);
//downcounter c4 = new(1,8,9);
//upcounter c5 = new(8,1,4);
//timer c6 = new;

initial
	begin
		
		c1 = u1;
		c1.next();
		$cast(u2, c1);
		u2.next();

//		$display("c1 count = %0d", c1.getcount());
//		c1.load(8);
//		cnt_val = c1.getcount();
//		$display("c1 count = %0d", cnt_val);
//		$display("c2 count = %0d", c2.getcount());
//		$display("c3 count = %0d", c3.getcount());
//		$display("c4 count = %0d", c4.getcount());
//		c3.next();
//		c4.next();
//		$display("c3 count = %0d", c3.getcount());
//		$display("c4 count = %0d", c4.getcount());
//		c3.load(9);
//		c4.load(6);
//		$display("c3 count = %0d", c3.getcount());
//		$display("c4 count = %0d", c4.getcount());
//		c4.load(2);
//		$display("c4 count = %0d", c4.getcount());
//		c4.next();
//		$display("c4 count = %0d", c4.getcount());
//		$display("borrow = %0b", c4.borrow);
//		c4.next();
//		$display("c4 count = %0d", c4.getcount());
//		$display("borrow = %0b", c4.borrow);
//		c3.load(7);
//		$display("c3 count = %0d", c3.getcount());
//		c3.next();
//		$display("c3 count = %0d", c3.getcount());
//		$display("carry = %0b", c3.carry);
//		c3.next();
//		$display("c3 count = %0d", c3.getcount());
//		$display("carry = %0b", c3.carry);
//		$display("number of upcounter instances that have been created = %0d", c3.cre_count);
//		$display("number of downcounter instances that have been created = %0d", c4.cre_count);
//		$display("number of upcounter instances that have been created = %0d", upcounter::cre_count);
//		$display("number of downcounter instances that have been created = %0d", downcounter::cre_count);
//		c6.load(00,00,59);
//		c6.showval();
//		c6.next();
//		c6.load(00,59,59);
//		c6.showval();
//		c6.next();
//		c6.next();
//		c6.next();
//		c6.load(23,59,59);
//		c6.showval();
//		c6.next();
//		c6.next();
	end

endmodule
