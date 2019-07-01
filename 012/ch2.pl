#!/usr/bin/env perl
#
# Write a script that finds the common directory path, given a collection of
# paths and directory separator. For example, if the following paths are
# supplied
#
# /a/b/c/d
# /a/b/cd
# /a/b/cc
# /a/b/c/d/e
#
# and the path separator is /. Your script should return /a/b as common
# directory path.
################################################################################

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

# CLI usage
if (@ARGV) {
    print commonPath(@ARGV), "\n";
} else {
    print "Usage: $0 path1 path2 ...\n";
}
