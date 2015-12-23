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
open (REFSEQFILE, "< $refseqs") or die "Could not open $refseqs\n";
while(defined (my $l = <REFSEQFILE>)) {
	chomp ($l);
	if ($l =~ /^>/) {
		$id = $l;
		# strip > character
		$id =~ s/^.//;
		# trim
		$id =~ s/^\s+|\s+$//g;
		if ($seqlength != -1) {
			$seqlengths{$id} = $seqlength;
		}
		$seqlength = 0;
	}
	else {
		$seqlength = $seqlength + length($l);
	}
}
close REFSEQFILE;

my @countlineitems;
open (COUNTFILE, "< $counts") or die "Could not open $counts\n";
open (OUTFILE, "> $out") or die "Could not open $out\n";
while(defined (my $l = <COUNTFILE>)) {
	chomp ($l);
	@countlineitems = split(/\t/, $l, 2);
	$id = $countlineitems[0];
	$id =~ s/^\s+|\s+$//g;
	print OUTFILE "$id\t$seqlengths{$id}\tcountlineitems[1]\n";
}
close COUNTFILE;
close OUTFILE;