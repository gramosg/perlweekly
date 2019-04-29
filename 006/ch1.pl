#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

sub compact {
	my @ins = split(/,/, shift);
	my @ons = @ins ? $ins[0] : ();
	@ins = @ins[1..$#ins];
	foreach my $n (@ins) {
		# Ending of the last interval
		my ($last) = $ons[-1] =~ /(\d+)$/;
		# Decide whether to expand the previous interval or begin a new one
		if (int($last) == $n-1) {
			# Set new range (2 -> 2-3; 3-4 -> 3-5)
			$ons[-1] =~ s/^(\d+).*$/$1-$n/;
		} else {
			# New interval (number)
			push(@ons, $n);
		}
	}
	return join(",", @ons);
}

foreach (@ARGV) {
	print compact($_), "\n";
}
