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
		return $i if $i != $last;
	}
}

sub input_and_check {
	my ($prompt, $correct_inputs_ref) = @_;

	print "$prompt: ";
	my $input = <STDIN>;
	chomp $input;

	# normalize
	$input =~ s/\s//g;
	my @correct_inputs = map { my $s = $_; $s =~ s/\s//g; $s } @$correct_inputs_ref;

	return $input ~~ @correct_inputs;
}

sub repeat_word {
	my ($words_ref, $times) = @_;

	my $words = join(' ELLER ', @$words_ref);

	foreach my $i (1 .. $times) {
		while (1) {
			last if input_and_check("$words ($i/$times)", $words_ref);
		}
	}

	return;
}

sub expand_text {
	my ($pattern, $replacement, $list_ref) = @_;

	foreach my $text (@$list_ref) {
		if ($text =~ $pattern) {
			my $alternative_text = $text;
			$alternative_text =~ s/$pattern/$replacement/g;
			push @$list_ref, $alternative_text;
		}
	}

	return;
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

# actual program loop
my $last = 0;
while (1) {
	my $i = draw($max, $last);
	$last = $i;

	my @texts = ($no_num2word->num2no_cardinal($i));
	expand_text(qr/^ett /,       '', \@texts);
	expand_text(qr/\bsju\b/,    'syv', \@texts);
	expand_text(qr/\btjue\b/,   'tyve', \@texts);
	expand_text(qr/\btretti\b/, 'tredve', \@texts);

	if (input_and_check($i, \@texts)) {
		print "Kjempefint!\n";
	}
	else {
		repeat_word(\@texts, 3);
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