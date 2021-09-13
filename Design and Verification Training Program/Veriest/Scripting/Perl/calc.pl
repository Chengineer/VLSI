#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $math_expr = $ARGV[0];;
#my $math_expr = "12+5*77-30*2+4-9";
my @math_expr_split_mult;
@math_expr_split_mult = split(/[*]+/, $math_expr);
#print "@math_expr_split_mult \n";
my $index;
for ($index = 1; $index <= $#math_expr_split_mult; $index = $index + 2){
    splice @math_expr_split_mult, $index, 0, '*'; # insert "*" as array element at the split points of the string
}
#print "@math_expr_split_mult \n";

my $item;
my @math_expr_split_plus;
foreach $item (@math_expr_split_mult){
    push @math_expr_split_plus, split(/[+]+/, $item);
}
#print "@math_expr_split_plus \n";

my @minus_arr;
my @temp;
my @math_expr_split_minus;
foreach $item (@math_expr_split_plus){
    if ($item =~ m/-/){ # if item contains "-"
        @temp = split(/[-]+/, $item);
        #print("@temp \n");
        @minus_arr = ($temp[0], -$temp[1]); # temp array for minuend, and subtrahend with minus sign
        #print "@minus_arr\n";
        push (@math_expr_split_minus, @minus_arr); # add the minus_arr current items to the end of math_expr_split_minus array
    } else {
        push (@math_expr_split_minus, $item); # add the current item to the end of math_expr_split_minus array
    }
}
#print "@math_expr_split_minus \n";

my @mult;
my @add;
for ($index = 0; $index <= $#math_expr_split_minus; $index++){
    if ($math_expr_split_minus[$index] eq '*'){
         push (@mult, $math_expr_split_minus[$index-1], $math_expr_split_minus[$index+1]); # add the previous and next items to the end of mult array
    } elsif (($math_expr_split_minus[$index-1] ne '*') && ($math_expr_split_minus[$index+1] ne '*')){
        push (@add, $math_expr_split_minus[$index]); # add the current item to the end of add array
    }
}
#print "@mult \n@add \n";
# create hash with keys: '*' and '+':
my %calc = ();
$calc{'*'} = [@mult];
$calc{'+'} = [@add];
#print Dumper(\%calc);

my $little_mult;
my @little_mults;
my $key;
foreach $key (keys %calc)
{
  if ($key eq '*'){
      for ($index = 0; $index < scalar(@{$calc{$key}}); $index = $index + 2){
          $little_mult =  $calc{$key}[$index] * $calc{$key}[$index + 1];
          push (@little_mults, $little_mult); # add the current multiplication result to the end of little_mults array
      }
  }
}
#print "@little_mults \n";
push ((@{$calc{'+'}}), @little_mults); # add multiplications results to value of '+' key
#print Dumper(\%calc);

my $final_result = 0;
foreach $key (keys %calc)
{
  if ($key eq '+'){
      for ($index = 0; $index < scalar(@{$calc{$key}}); $index++){
          $final_result=  $final_result + $calc{$key}[$index]; # calculate final result
      }
  }
}
print "$final_result \n"