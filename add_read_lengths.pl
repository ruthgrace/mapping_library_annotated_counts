#!/usr/bin/env perl -w
#use strict;
my $help = "\tFirst argument is a path to the annotated counts table (first column is refseq ids)\n
Second argument is a path to the refseqs (fasta file)\n
Third argument is output file path\n";
print $help if !$ARGV[0];exit if !$ARGV[0];
print $help if !$ARGV[1];exit if !$ARGV[1];
print $help if !$ARGV[2];exit if !$ARGV[2];

my $counts = $ARGV[0];
my $refseqs = $ARGV[1];
my $out = $ARGV[2];

# read in all refseq lengths
my %seqlengths;
my $id;
my $seqlength = -1;
my $numseqs = 0;
open (REFSEQFILE, "< $refseqs") or die "Could not open $refseqs\n";
while(defined (my $l = <REFSEQFILE>)) {
	chomp ($l);
	if ($l =~ /^>/) {
		if ($seqlength != -1) {
			$seqlengths{$id} = $seqlength;
			$numseqs = $numseqs + 1;
		}
		else {
			print "Didn't process data at seqlength $seqlength and id $id\n";
		}
		$seqlength = 0;
		$id = $l;
		# strip > character
		$id =~ s/^.//;
		# trim
		$id =~ s/^\s+|\s+$//g;
		# replace spaces with underscores
		$id =~ s/ /_/g;
		# add underscore on end in case there isn't one after the unique number in the id
		$id =~ s/$/_/;
		$id = substr($id, 0, index($id, '_'));
	}
	else {
		$seqlength = $seqlength + length($l);
	}
}
$seqlengths{$id} = $seqlength;
close REFSEQFILE;

print "$numseqs total refseqs processed\n";

my @countlineitems;
my $firstline = 1;
open (COUNTFILE, "< $counts") or die "Could not open $counts\n";
open (OUTFILE, "> $out") or die "Could not open $out\n";
while(defined (my $l = <COUNTFILE>)) {
	chomp ($l);
	if ($firstline) {
		$firstline = 0;
		my @lineitems = split(/\t/, $l, 2);
		print OUTFILE "$lineitems[0]\tlength\t$lineitems[1]\n";
	}
	else {
		@countlineitems = split(/\t/, $l, 2);
		if (@countlineitems == 2) {
			$id = $countlineitems[0];
			$id =~ s/^\s+|\s+$//g;
			$id =~ s/ /_/g;
			$id =~ s/$/_/;
			$id = substr($id, 0, index($id, '_'));
			if (exists $seqlengths{$id}) {
				print OUTFILE "$countlineitems[0]\t$seqlengths{$id}\t$countlineitems[1]\n";
			}
			else {
				print "Couldn't find refseq for line $l\n";
			}
		} else {
			print "Couldn't parse line $l\n";
		}
	}
}
close COUNTFILE;
close OUTFILE;
