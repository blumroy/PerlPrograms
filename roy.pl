#!/usr/bin/perl -w
use strict;

my %carType;
print "\n";
$carType{'suzuki'} = {
	'name'=> "Suzuki_Japan",
	'price'=> "40,000",
	'speed'=> "130"
};

$carType{'pontiack'} = {
	'name'=> "Pontiack_USA",
	'price'=> "80,000",
	'speed'=> "230"
};

$carType{'folkswagen'} = {
	'name'=> "Folkswagen_Germany",
	'price'=> "50,000",
	'speed'=> "150"
};


foreach my $item(my @items = ("folkswagen","pontiack","suzuki")){
	print "\n\n$item\n";
	write_car_summary ($carType{$item},"Jaffa",4,3);
}

print "\ncheck: $carType{'suzuki'}{'name'}\n";
print "\ncheck: $carType{'folkswagen'}{'speed'}\n";

#write_car_summary ($carType{'folkswagen'},"Jaffa",4,3);
#write_car_summary ($carType{'pontiack'},"New Jersey",4,4);
#write_car_summary ($carType{'suzuki'},"Hamburg",6,3);

sub write_car_summary {
	my ($lcarType,$port,$wheels,$doors) = @_;
 
	print "\n ** Car Summary ** \n";
	print " Name: $lcarType->{'name'}\n";
	print " shipped from $port port\n";
	print " Car's Price: $lcarType->{'price'}\n";
	print " The speed: $lcarType->{'speed'}\n";
	print " Has $wheels wheels \n";
	print " Has $doors doors \n";
	print "** Summary End ** \n";
}

