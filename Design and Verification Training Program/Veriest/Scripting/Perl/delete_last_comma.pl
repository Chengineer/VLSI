#!/usr/bin/perl -w
use strict;

my $file_name = $ARGV[0];
open (FH, '<', $file_name) or die "Couldn't open file";
my @lines = <FH>; # load lines from text file
my $line;
my $i;
my $index;
my $char = ',';
#my $comma;
for ($i = $#lines; $i >= 0; $i--) {# iterate on text lines starting from the last one
    $line = $lines[$i];
    #print "line:\n$i \n"; 
    #print "line $i content:\n$line \n";
    if ($line =~ m/,/){ # if item contains "," (a comma)
	$index = rindex($line, $char); # find the index of the last comma in the current line
	#$comma = substr($line, $index, 1);
	#print "index of the last comma in the line:\n$index \n";
    #print "verify that there is a comma at this index:\n$comma \n";
	pos($line) = $index;
	$line =~ s/\G$char//gc; # remove the last comma from line
	#print "line:\n$line \n";
	$lines[$i] = $line; # replace the old line in the lines array with the new one (without the last comma)
	last;
    }
}

open (FH,'>', $file_name) or die "Couldn't open file"; 
print FH @lines; # write the updated lines array to the file
close FH;