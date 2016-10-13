#!/usr/bin/perl
use strict;
my %chr;
my @lineA;
my $i;
#my $startOrEndOnly=shift;
#print "heloo roy\n";
while(<>){
 chomp;
 @lineA=split /\s+/,$_;
 if ((length($lineA[0])>0) &&  !exists($chr{$lineA[0]})){
 	$chr{$lineA[0]}=1;
  	#print "$lineA[0]\n";
    print "variableStep chrom=$lineA[0] span=1\n";
 }
 $i=$lineA[1]+1;
 print "$i\t$lineA[4]\n";
}
 
