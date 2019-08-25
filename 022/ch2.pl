#!/usr/bin/env perl
#
# Write a script to implement Lempel–Ziv–Welch (LZW) compression algorithm. The
# script should have method to encode/decode algorithm. The wiki page explains
# the compression algorithm very nicely.
#
# (https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Welch).
################################################################################

use strict;
use warnings;

use POSIX qw<ceil>;
use Data::Dumper;

################################################################################
# Naïve implementation of a bidirectional map
sub bimap_new {
    return {sym2bin=>{}, bin2sym=>{}};
}
sub bimap_insert {
    my ($dict, $sym) = @_;
    my ($sym2bin, $bin2sym) = @$dict{'sym2bin', 'bin2sym'};
    die "Symbol '$sym' already in dict" if exists $dict->{sym2bin}{$sym};
    my $ord = keys %{$dict->{sym2bin}}; # Ordinal of symbol to insert in decimal
    my $bin = sprintf "%b", $ord; # ... and in binary (string of 1/0s)
    $sym2bin->{$sym} = $bin; # Update symbol -> binary mapping
    $bin2sym->{$bin} = $sym; # Update binary -> symbol mapping

    # Extend with left zeroes the previously inserted binaries
    my $binlen = length $bin;
    foreach my $sym (keys %$sym2bin) {
        my $bin = $sym2bin->{$sym};
        delete $bin2sym->{$bin};
        $bin = "0" x ($binlen - length $bin) . $bin;
        $sym2bin->{$sym} = $bin;
        $bin2sym->{$bin} = $sym;
    }
}


################################################################################
# Default dictionary
my $DEFAULT_DICT = bimap_new();
bimap_insert($DEFAULT_DICT, $_) foreach ('', 'A' .. 'Z');
sub dict_print {
    my $bin2sym = shift()->{bin2sym};
    foreach my $bin (sort keys %$bin2sym) {
        printf "%s -> %s\n", $bin2sym->{$bin}, $bin;
    }
}

sub lzw_encode {
    my $text = shift;
    my %dict = %$DEFAULT_DICT;
    my ($sym2bin, $bin2sym) = @dict{'sym2bin', 'bin2sym'};

    my $out = '';
    while ($text) {
        # Find largest match in dictionary
        foreach my $sym (sort { length $b cmp length $a } keys %$sym2bin) {
            if ($text =~ /^$sym(.*)$/) {
                # Attach the binary corresponding to the matching symbol
                $out .= $sym2bin->{$sym};
                # ... and cut the symbol from the input text
                $text = substr($text, length $sym);
                if ($1) {
                    # New dict entry ($sym + next character)
                    bimap_insert(\%dict, $sym . substr($1, 0, 1));
                } else {
                    # No next character: insert EOM marker and we're finished
                    $out .= $sym2bin->{''};
                }
                last;
            }
        }
        print "[debug] compressing $text\n";
    }
    return $out;
}

sub usage {
    die "Usage: $0 -e | --encode | -d | --decode\n";
}
my $mode = shift || usage;
if ($mode eq '-e' || $mode eq '--encode') {
    my $text = <>;
    my $bin = lzw_encode($text);
    my $comprate = 100 * length($bin) / (8 * length($text));
    printf STDERR "Compressed to %.2f%% of original size\n", $comprate;
    print $bin;
} else {
    usage;
}
