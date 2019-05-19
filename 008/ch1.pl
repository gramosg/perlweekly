#!/usr/bin/env perl

use strict;
use warnings;

my @mersennes = (2, 3, 5, 7, 13);

foreach my $p (@mersennes) {
    print 2**($p - 1) * (2**$p - 1), "\n";
}
