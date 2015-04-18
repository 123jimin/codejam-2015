#!/usr/bin/env perl

use strict;

my $T = <STDIN>;
my $ti = 1;

while ($ti <= $T) {
	my $line = <STDIN>;
	$line = <STDIN>;
	chomp $line;
	my @numbers = split / /, $line;
	my $max_dec = 0;
	my $a1 = 0;
	my $a2 = 0;
	for my $i (1 .. $#numbers) {
		my $cur_dec = $numbers[$i-1] - $numbers[$i];
		if ($cur_dec > 0) {
			$a1 += $cur_dec;
			if ($cur_dec > $max_dec) {
				$max_dec = $cur_dec;
			}
		}
	}
	for my $i (1 .. $#numbers) {
		if ($numbers[$i-1] <= $max_dec) {
			$a2 += $numbers[$i-1];
		} else {
			$a2 += $max_dec;
		}
	}
	print "Case #$ti: $a1 $a2\n";
	$ti++;
}
