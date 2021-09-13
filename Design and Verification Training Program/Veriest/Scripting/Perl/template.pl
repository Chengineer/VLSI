#!/usr/bin/perl -w
use strict;


my $module_name = $ARGV[0];
my $module_input = $ARGV[1];
my $module_output = $ARGV[2];
my $module_param_name = $ARGV[3];
my $module_param_value = $ARGV[4];

my $file = $module_name . ".sv";
unless(open FILE, '>'.$file) {die "Couldn't open file"};
print FILE "module " . $module_name . "\n";
print FILE "\t" . "#(parameter " . $module_param_name . " = " . $module_param_value . ")\n";
print FILE "\t(\n";
print FILE "\tinput [" . $module_param_name . "-1:0]\t" . $module_input . ",\n";
print FILE "\toutput [" . $module_param_name . "-1:0]\t" . $module_output . "\n";
print FILE "\t);\n";
print FILE "\n\nendmodule";


close FILE;

open (FH, $file) or die "Couldn't open file";
while (<FH>)
{
	print $_;
}
close;