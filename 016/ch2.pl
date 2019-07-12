#!/usr/bin/env perl
#
# Write a script to validate a given bitcoin address. Most Bitcoin addresses are
# 34 characters. They consist of random digits and uppercase and lowercase
# letters, with the exception that the uppercase letter “O”, uppercase letter
# “I”, lowercase letter “l”, and the number “0” are never used to prevent visual
# ambiguity. A bitcoin address encodes 25 bytes. The last four bytes are a
# checksum check. They are the first four bytes of a double SHA-256 digest of
# the previous 21 bytes. For more information, please refer wiki page. Here are
# some valid bitcoin addresses:
#   1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2
#   3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy
################################################################################

use strict;
use warnings;

use bigint;
use Digest::SHA qw<sha256 sha256_hex>;

my $addr = shift or die "Usage: $0 <btc_address>\n";
my $len = length $addr;

my $B58 = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

# Basic checks
# die "Invalid length (must be 26-35)\n" unless $len >= 26 && $len <= 34;
die "Invalid characters\n" unless $addr =~ /^[$B58]+$/;

# Fill with zeroes if address is shorter than 34 characters
# $addr = '0' x (34 - $len) . $addr;

my $dec_addr;
my $base = 1;
for (my $i = length($addr)-1; $i >= 0; $i--) {
    $dec_addr += $base * index $B58, substr($addr, $i, 1);
    $base *= 58;
}

my $checksum = $dec_addr & (2**32 - 1); # Get last 4 bytes
my $payload = pack("H*", ($dec_addr >> 32)->as_hex);
my $digest = sha256_hex(pack("a*", sha256_hex($payload))); # Get version+payload

print $dec_addr->as_hex, "\n";
print $payload, " - ", $checksum->as_hex, "\n";
print $digest, "\n";
