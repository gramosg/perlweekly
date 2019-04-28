#!/usr/bin/env perl

use strict;
use warnings;

# Functional implementation (tail-recursive)
sub anagrams {
	sub iter {
		my ($word, @acc) = @_;
		if (length($word) == 0) {
			return @acc;
		} else {
			my ($head, $tail) = $word =~ /^(.)(.*)$/;
			@_ = $tail; # Next word will be the tail of the previous one
			foreach my $anagram (@acc) {
				for (my $i = 0; $i <= length($anagram); $i++) {
					push(@_, $anagram);
					substr($_[-1], $i, 0) = $head;
				}
			}
			goto &iter;
		}
	}
	iter($_[0], (""));
}

for (@ARGV) {
	for (anagrams($_)) {
		print $_, "\n";
	}
}
