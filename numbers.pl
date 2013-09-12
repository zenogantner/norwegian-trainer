#!/usr/bin/perl

use strict;
use warnings;

use English;
use Lingua::NOR::Num2Word;
 
my $no_num2word = Lingua::NOR::Num2Word->new();

sub usage {
	print "Usage: $0 MAX_INT\n";
	print "  MAX_INT is the maximum number.\n";
	exit;
}

sub repeat_word {
	my ($word, $times) = @_;
	foreach my $i (1 .. $times) {
		while (1) {
			print "$word ($i/$times): ";
			my $input = <STDIN>; chomp $input;
			last if $input eq $word;
		}
	}
}

sub draw {
	my ($max, $last) = @_;
	while (1) {
		my $i = int(rand($max + 1));
		if ($i != $last) {
			return $i;
		}
	}
}

# set up
my $max = 99;
if (length(@ARGV) > 0) {
	if ($ARGV[0] eq '--help' or $ARGV[0] eq '-h') {
		usage();
	}
	if ($ARGV[0] =~ /\d+/) {
		$max = $ARGV[0];
	}
	else {
		usage();
	}
}

print "Norwegian special characters for copy+paste: æ ø̣ å\n";

# actual program loop
my $last = 0;
while (1) {
	my $i = draw($max, $last);
	$last = $i;
	my $text = $no_num2word->num2no_cardinal($i);
	print "$i: ";
	my $input = <STDIN>; chomp $input;
	if ($input eq $text) {
		print "Kjempefint!\n";
	}
	else {
		repeat_word($text, 3);
	}
}

# Copyright (C) 2013 by Zeno Gantner
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.