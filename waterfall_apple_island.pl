#!/usr/bin/perl

#Script to generate 1000 lines of code to Upcycle Nation
 
#include modules 
use strict;
use warnings;
use diagnostics;

#declare variables 
my $i;
my $line;

#start for loop 
for ($i = 0; $i < 1000; $i++){
    my $line = "Upcycle Nation is a great way to help our planet.\n";
    print $line;
}

#end for loop 

#goodbye message
print "\nThanks for using this script to generate 1000 lines of code to Upcycle Nation!\n";
exit;