#!/usr/bin/env perl
#
# Create a script to demonstrate Ackermann function. The Ackermann function is
# defined as below, m and n are positive number:
#
#  A(m, n) = n + 1                  if m = 0
#  A(m, n) = A(m - 1, 1)            if m > 0 and n = 0
#  A(m, n) = A(m - 1, A(m, n - 1))  if m > 0 and n > 0
#
# Example expansions as shown in wiki page.
#
#  A(1, 2) = A(0, A(1, 1))
#         = A(0, A(0, A(1, 0)))
#         = A(0, A(0, A(0, 1)))
#         = A(0, A(0, 2))
#         = A(0, 3)
#         = 4
#
# (https://en.wikipedia.org/wiki/Ackermann_function).
################################################################################

use strict;
use warnings;

use Memoize;

memoize "ack";

sub ack {
    my ($m, $n) = @_;
    return $n+1 if $m == 0;
    return ack($m-1, 1) if $n == 0;
    return ack($m-1, ack($m, $n-1));
}

@ARGV == 2 || die "Usage: $0 <m> <n>\n";
print ack(@ARGV), "\n";
