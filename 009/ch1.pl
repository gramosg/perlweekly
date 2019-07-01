#!/usr/bin/env perl
#
# Write a script that finds the first square number that has at least 5 distinct
# digits
################################################################################

use strict;
use warnings;

# Compute distinct digits of the given number
sub distinct {
    my $n = shift;
    my %uniq; # Poor man's set
    $uniq{$_} = 1 foreach split(//, $n);
    return keys %uniq;
}

my $n = 0;
$n++ while distinct($n**2) != 5;

print "$n ($n**2 = ", $n**2, ")\n";
