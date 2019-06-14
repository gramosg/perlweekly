#!/usr/bin/env perl

use strict;
use warnings;

sub commonPath {
    # Normalize paths (merge multiple "/"s into a single one)
    map s|/+|/|g, @_;

    # This array stores the common path components so far
    my @common = split m|/|, shift, -1;

    # Iterate over arguments (paths) and update @common accordingly
    foreach my $path (@_) {
        my @current = split m|/|, $path, -1;

        # Cut @common if longer than the current one
        @common = @common[0 .. $#current] if $#current < $#common;

        # Cut @common to keep only the matching components
        foreach my $i (0 .. $#common) {
            if ($common[$i] ne $current[$i]) {
                @common = @common[0 .. $i-1];
                last;
            }
        }
    }

    # Corner case: @common == ('') means root
    return @common == 1 && $common[0] eq ''
        ? "/"
        : join "/", @common;
}

print commonPath(@ARGV), "\n";
