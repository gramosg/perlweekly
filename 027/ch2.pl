#!/usr/bin/env perl
#
# Write a script that allows you to capture/display historical data. It could be
# an object or a scalar. For example
#
#   my $x = 10; $x = 20; $x -= 5;
#
# After the above operations, it should list $x historical value in order.
################################################################################

use strict;
use warnings;

{
    package Hist;

    require Tie::Scalar;
    our @ISA = qw<Tie::Scalar>;

    sub TIESCALAR {
        return bless \my @histogram, shift;
    }
    sub FETCH {
        my @self = @{shift()};
        printf STDERR "History of values: %s\n", join(", ", @self);
        return @self[@self-1]
    }
    sub STORE {
        my $self = shift;
        my $value = shift;
        push @$self, $value;
    }
}

tie my $x, 'Hist';

$x = 10;
$x = 20;
$x = -5;

my $y = $x;
print "y=$y\n";

$x = 200;
print "x=$x\n";
