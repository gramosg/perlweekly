#!/usr/bin/env perl
#
# Write a script that computes the first five perfect numbers. A perfect number
# is an integer that is the sum of its positive proper divisors (all divisors
# except itself).
# (https://en.wikipedia.org/wiki/Perfect_number)
################################################################################

use strict;
use warnings;

sub perfect {
    my $sum = 0;
    my $n = shift;
    my $candidate = 1;
    while ($candidate*2 <= $n) {
        $sum += $candidate if $n % $candidate == 0;
        $candidate++;
    }

    return $n == $sum;
}

my $n = 1;
my $perfects = 0;
while ($perfects < 5) {
    if (perfect($n)) {
        print $n, "\n";
        $perfects++;
    }
    $n++;
}
