# Recursive implementation of Stein's GCD algorithm:
proc SteinGCD { u v } {

	; # STEP 1: Simple cases
	; # If SteinGCD(u,u) is called 
	if { $u == $v } {
	; # The largest number that divides a number is that number.
		return $u
	}
	
	; # If SteinGCD(0,v) is called
	if { $u == 0 } {
	; # Everything divides zero, and v is the largest number that divides v. 
		return $v
	}
	
	; # If SteinGCD(u,0) is called
	if { $v == 0 } {
	; # Everything divides zero, and u is the largest number that divides u. 
		return $u
	}
	
	; # Bitwise AND (&) between a number and 1 imposes 0's at the result's [MSB,...,LSB+1] bits. Here the number will be bitwise-inverted before calculating the AND, so the result can be either 1 if the number is even (i.e. its LSB is 0), or 0 if the number is odd (i.e. its LSB is 1). 
	; # Shifting right (>>) by 1 bit is equivalent to dividing by 2 using integer division. 
	; # Shifting left (<<) by 1 bit is equivalent to multiplying by 2. 
	
	; # If u is even
	if { [ expr [ expr ~$u ] & 1 ] } {
		; # STEP 2: If u and v are even
		if { [expr [ expr ~$v ] & 1 ] } {
			; # Call SteinGCD(u/2,v/2) and return its result multiplied by 2.
			return [ expr [ SteinGCD [ expr $u >> 1 ] [ expr $v >> 1 ] ] << 1 ]
		; # STEP 3: If u is even and v is odd	
		} else { 
			; # Call SteinGCD(u/2,v) and return its result.
			return [ SteinGCD [ expr $u >> 1 ] $v ] 
		}
	}
	
	; # STEP 3: If u is odd and v is even
	if { [ expr [ expr ~$v ] & 1 ] } {
		; # Call SteinGCD(u,v/2) and return its result.
		return [ SteinGCD $u [ expr $v >> 1 ] ]
	}
	
	; # STEP 4: If u and v are odd, and u>v
	if { $u > $v } {
		; # Call SteinGCD((u-v)/2,v) and return its result.
		return [ SteinGCD [ expr [expr $u - $v] >> 1 ] $v ]
	}
	
	; # STEP 4: If u and v are odd, and u<v
	; # Call SteinGCD((v-u)/2,u) and return its result.
	return [ SteinGCD [ expr [expr $v - $u] >> 1 ] $u ]

};

# Test Bench:
; # Initialize the running variable (which represents a pair's "serial number") of the while loop condition.
set pair 1
; # Open an output file called grapelc1-gcd.txt for writing.
set fh [ open "grapelc1-gcd.txt" w ]
; # Write my details to the first line of the output file.
puts $fh "Chen Grapel\n"
; # Write column headings to the third line of the output file.
puts $fh "First Number\tSecond Number\t\tGCD"
; # Write dashes to the fourth line of the output file.
puts $fh "------------\t-------------\t\t---"
; # Repeat the following commands 100 times in order to have 100 random integer pairs and their GCDs written in the output file.
while { $pair <= 100 } {
	; # Set a random integer value between 0 and 50, into "FirstNumber" variable.  
	set FirstNumber [ expr {int(rand()*50)} ]
	; # Set a random integer value between 0 and 30, into "SecondNumber" variable. 
	set SecondNumber [ expr {int(rand()*30)} ]
	; # Call SteinGCD procedure with the random values, and set the returned value into "GCD" variable.
	set GCD [ SteinGCD $FirstNumber $SecondNumber ]
	; # Write the random numbers and their GCD to the ($pair+4) line of the output file.
	puts $fh "$FirstNumber\t\t\t$SecondNumber\t\t\t\t$GCD"
	; # Update the running variable to the serial number of the next pair.
	set pair [ expr {$pair+1} ]
}
; # Close the output file.
close $fh
	

