#!/usr/bin/env perl
#
# Print all the niven numbers from 0 to 50 inclusive, each on their own line. A
# niven number is a non-negative number that is divisible by the sum of its
# digits
################################################################################

use strict;
use warnings;

use List::Util qw(reduce);

sub niven {
    my $n = shift;
    return 0 if $n == 0;
    $n % (reduce { $a + $b } split(//, $n)) == 0;
}

foreach (grep { niven $_ } (0..50)) {
    print $_, "\n";
}
