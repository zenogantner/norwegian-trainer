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

sub draw {
	my ($max, $last) = @_;
	while (1) {
		my $i = int(rand($max + 1));
		if ($i != $last) {
			return $i;
		}
	}
}

sub input_and_check {
	my ($prompt, $word_or_list_ref) = @_;

	my @words = ref $word_or_list_ref eq 'ARRAY' ? @$word_or_list_ref : [$word_or_list_ref];

	print "$prompt: ";
	my $input = <STDIN>;
	chomp $input;

	return $input ~~ @words;
}

sub repeat_word {
	my ($word_or_list_ref, $times) = @_;

	my $words = ref $word_or_list_ref eq 'ARRAY' ? join(' ELLER ', @$word_or_list_ref) : $word_or_list_ref;

	foreach my $i (1 .. $times) {
		while (1) {
			last if input_and_check("$words ($i/$times)", $word_or_list_ref);
		}
	}
}

# set up
my $max = 99;
if (length @ARGV > 0 && defined $ARGV[0]) {
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
print "Please use spaces: 'tjue to', not 'tjueto' for 22.\n";

# actual program loop
my $last = 0;
while (1) {
	my $i = draw($max, $last);
	$last = $i;
	my $text = $no_num2word->num2no_cardinal($i);
	if ($text =~ /^ett /) {
		my $alternative_text = $text;
		$alternative_text =~ s/^ett //;
		$text = [$text, $alternative_text];
	}
	if (input_and_check($i, $text)) {
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