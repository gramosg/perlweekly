#!/usr/bin/env perl
#
# Write a script to perform different types of ranking as described below:
#
# 1. Standard Ranking (1224): Items that compare equal receive the same ranking
# number, and then a gap is left in the ranking numbers.
# 2. Modified Ranking (1334): It is done by leaving the gaps in the ranking
# numbers before the sets of equal-ranking items.
# 3. Dense Ranking (1223): Items that compare equally receive the same ranking
# number, and the next item(s) receive the immediately following ranking number.
#
# (https://en.wikipedia.org/wiki/Ranking)
##############################################################################

use strict;
use warnings;

sub rank {
    my $rank_type = shift;
    my @points = sort @_;

    my %ranks;
    my $rank = $rank_type eq "modified" ? 0 : 1;

    my $interval_begin = 0;
    my $i;
    for ($i = 0; $i < @points; $i++) {
        my $point = $points[$i];
        if ($point != $points[$interval_begin]) {
            my @points_to_add = @points[$interval_begin .. ($i-1)];
            $rank += @points_to_add if $rank_type eq "modified";
            $ranks{$rank} = \@points_to_add;
            if ($rank_type eq "standard") {
                $rank += @points_to_add;
            } elsif ($rank_type eq "dense") {
                $rank = $rank + 1;
            }
            $interval_begin = $i;
        }
    }
    my @points_to_add = @points[$interval_begin .. ($i-1)];
    $rank += @points_to_add if $rank_type eq "modified";
    $ranks{$rank} = \@points_to_add;
    return \%ranks;
}

# Get rank type and points as CLI arguments
my $rank_type = shift || "";
grep /^$rank_type$/, qw(modified standard dense)
    or die "Usage: $0 {modified, standard, dense} rank1 rank2 ...";
my @points = @ARGV;

# Compute rankings
my $ranks = rank($rank_type, @points);

# Display rankings
foreach my $rank (sort (keys %$ranks)) {
    my @positions = @{$ranks->{$rank}};
    print "$rank. @positions\n";
}
