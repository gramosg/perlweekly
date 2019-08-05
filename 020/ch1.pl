#!/usr/bin/env perl
#
# Write a script to accept a string from command line and split it on change of
# character. For example, if the string is “ABBCDEEF”, then it should split like
# “A”, “BB”, “C”, “D”, “EE”, “F”.
################################################################################

use strict;
use warnings;

use 5.13.2;

print substr(shift =~ s/((.)\g2*)/$1 /gr, 0, -1), "\n";
