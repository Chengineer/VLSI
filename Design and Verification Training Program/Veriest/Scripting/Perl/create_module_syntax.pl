#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $file_name = $ARGV[0];
my $module_name = $ARGV[1];
my $module_param_name = $ARGV[2];
my $module_param_value = $ARGV[3];
open (FH, '<', $file_name) or die "Couldn't open file";
my @lines = <FH>; # load lines from text file
#print "@lines \n";
my @temp;
@temp = split(/[=]+/, $lines[0]);
#print "@temp \n";
$temp[1] =~ s/\s+//g; # remove all white spaces of the temp[1] string (dict)
$temp[1] =~ s/'+//g; # remove all " ' " of the temp[1] string (dict)
#print "$temp[1] \n";
substr($temp[1], 0, 1, ''); # remove first char ({)
substr($temp[1], -1, 1, ''); # remove last char (})
#print "$temp[1] \n";

@lines = split(/[{ \s\ }]+/, $temp[1]); # split string by "{" and "}"
#print "@lines \n";
my $index;
for ($index = 1; $index <= $#lines; $index = $index + 4){
    splice @lines, $index, 0, '{'; # insert "{" as array element at the "{" split points of the string
    splice @lines, $index + 2, 0, '}';  # insert "}" as array element at the "}" split points of the string
}
#print "@lines \n";

my @new_lines;
my $item;
foreach $item (@lines){
    push @new_lines, split(/[, \s\ :]+/, $item); # split strings in lines array by "," and ":"
}
#print "@new_lines \n\n";
@new_lines = grep /\S/, @new_lines; # remove empty elements from new_lines array
#print "@new_lines \n\n";

my %signals_hash;
for ($index = 0; $index <= $#new_lines; $index++){
    if ($new_lines[$index] eq '{'){
	my %signals;
	my $i = 1;
	while ($new_lines[$index + $i] ne '}'){
	    $signals{$new_lines[$index + $i]} = $new_lines[$index + $i + 1];
	    $i = $i + 2;
	}
	$signals_hash{$new_lines[$index - 1]} = \%signals;
    }
}
#print Dumper(\%signals_hash);

my $key;
my $k;
foreach $key (keys %signals_hash){
    foreach $k (keys %{$signals_hash{$key}}){
	if ($signals_hash{$key}{$k} eq "Null"){
	    delete $signals_hash{$key}{$k}; # remove "Null" values from hash
	}
    }
}
#print Dumper(\%signals_hash);

my $file = $module_name . ".sv";
open (FILE, '>'.$file) or die "Couldn't open file";
print FILE "module " . $module_name . "\n";
print FILE "\t" . "#(parameter " . $module_param_name . " = " . $module_param_value . ")\n";
print FILE "\t(\n";
foreach $key (keys %signals_hash){
    foreach $k (sort keys %{$signals_hash{$key}}){
	if (($key eq (keys %signals_hash)[-1]) && ($k eq (keys %{$signals_hash{$key}}))[-1]){ # if the current item is the very last item in the nested hashes
	    print FILE "\t$key\t$signals_hash{$key}{$k}\n";
	} else {
	    print FILE "\t$key\t$signals_hash{$key}{$k},\n";
	}
    }
}
print FILE "\t);\n";
print FILE "\n\nendmodule";
close FILE;

open (FH, $file) or die "Couldn't open file";
while (<FH>)
{
	print $_;
}
close;
