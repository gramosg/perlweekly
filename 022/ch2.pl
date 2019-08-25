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

################################################################################
# Naïve implementation of a bidirectional map
my $MAX_BIT_WIDTH = 12;
sub bimap_new {
    return {binwidth=>0, sym2bin=>{}, bin2sym=>{}};
}
sub bimap_extend {
    my ($dict, $binwidth) = @_;
    return unless $binwidth > $dict->{binwidth} && $binwidth <= $MAX_BIT_WIDTH;
    my ($sym2bin, $bin2sym) = @$dict{'sym2bin', 'bin2sym'};
    foreach my $sym (keys %$sym2bin) {
        my $bin = $sym2bin->{$sym};
        delete $bin2sym->{$bin};
        $bin = "0" x ($binwidth - length $bin) . $bin;
        $sym2bin->{$sym} = $bin;
        $bin2sym->{$bin} = $sym;
    }
    $dict->{binwidth} = $binwidth;
}
sub bimap_insert {
    my ($dict, $sym) = @_;
    my ($sym2bin, $bin2sym) = @$dict{'sym2bin', 'bin2sym'};
    die "Symbol '$sym' already in dict" if exists $dict->{sym2bin}{$sym};
    my $ord = keys %{$dict->{sym2bin}}; # Ordinal of symbol to insert in decimal
    my $bin = sprintf "%b", $ord; # ... and in binary (string of 1/0s)
    return unless length $bin <= $MAX_BIT_WIDTH;
    $sym2bin->{$sym} = $bin; # Update symbol -> binary mapping
    $bin2sym->{$bin} = $sym; # Update binary -> symbol mapping

    # Extend with left zeroes the previously inserted binaries
    bimap_extend($dict, length($bin));

    return $bin;
}


################################################################################
# Default dictionary
my $DEFAULT_DICT = bimap_new();
my $STOP = '';
bimap_insert($DEFAULT_DICT, $_) foreach (map(chr, 1..254), $STOP);
sub dict_print {
    my $bin2sym = shift()->{bin2sym};
    foreach my $bin (sort keys %$bin2sym) {
        printf "%s -> %s\n", $bin2sym->{$bin}, $bin;
    }
}

sub lzw_encode {
    my $input = shift;
    my %dict = %$DEFAULT_DICT;
    my ($sym2bin, $bin2sym) = @dict{'sym2bin', 'bin2sym'};

    my $out = '';
    while ($input) {
        # Find largest match in dictionary
        foreach my $sym (sort { length $b cmp length $a } keys %$sym2bin) {
            if (rindex($input, $sym, 0) == 0) {
                # Attach the binary corresponding to the matching symbol
                $out .= $sym2bin->{$sym};
                # ... and cut the symbol from the input text
                $input = substr($input, length $sym);
                if ($input) {
                    # New dict entry ($sym + next character)
                    bimap_insert(\%dict, $sym . substr($input, 0, 1));
                } else {
                    # No next character: insert EOM marker and we're finished
                    $out .= $sym2bin->{$STOP};
                }
                last;
            }
        }
    }
    return $out;
}

sub lzw_decode {
    my $input = shift;
    my %dict = %$DEFAULT_DICT;
    my ($sym2bin, $bin2sym) = @dict{'sym2bin', 'bin2sym'};

    my $out = '';
    my $lastsym;
    while ($input) {
        foreach my $bin (keys %$bin2sym) {
            if ($input =~ /^$bin/) {
                my $sym = $bin2sym->{$bin};
                $out .= $sym;
                $input = substr($input, length $bin);
                last if $sym eq $STOP;
                if (defined $lastsym) {
                    my $bin = bimap_insert(\%dict, $lastsym . substr($sym, 0, 1));
                    bimap_extend(\%dict, $dict{binwidth}+1)
                        if $bin =~ /^1+$/;
                }
                $lastsym = $sym;
                last;
            }
        }
    }
    return $out;
}

sub usage {
    die "Usage: $0 -e | --encode | -d | --decode\n";
}
my $mode = shift || usage;
if ($mode eq '-e' || $mode eq '--encode') {
    my $input = <>;
    my $out = lzw_encode($input);
    my $comprate = 100 * length($out) / (8 * length($input));
    printf STDERR "Compressed to %.2f%% of original size\n", $comprate;
    print $out;
} elsif ($mode eq '-d' || $mode eq '--decode') {
    my $input = <>;
    my $out = lzw_decode($input);
    print $out;
} else {
    usage;
}
