#!/usr/bin/env perl
#
# Write a script to accept a string from command line and split it on change of
# character. For example, if the string is “ABBCDEEF”, then it should split like
# “A”, “BB”, “C”, “D”, “EE”, “F”.
################################################################################

use strict;
use warnings;

my $str = shift;

my @chunks;
push @chunks, $1 while ($str =~ /\G((.)\2*)/g);
print "@chunks\n";
