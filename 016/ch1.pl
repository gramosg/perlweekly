#!/usr/bin/env perl
#
# At a party a pie is to be shared by 100 guest. The first guest gets 1% of the
# pie, the second guest gets 2% of the remaining pie, the third gets 3% of the
# remaining pie, the fourth gets 4% and so on. Write a script that figures out
# which guest gets the largest piece of pie.
################################################################################

use strict;
use warnings;

my $guest = 0;
my $sum = 0;

$sum += ++$guest while $sum <= 100;

print "Largest piece: ", $guest-1, "\n";
