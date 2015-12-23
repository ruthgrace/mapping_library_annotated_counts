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

# read in all full refseq ids
my %fullids;
open (REFSEQFILE, "< $refseqs") or die "Could not open $refseqs\n";
while(defined (my $l = <REFSEQFILE>)) {
	chomp ($l);
	if ($l =~ /^>/) {
		$fullid = $l;
		# strip > character
		$fullid =~ s/^.//;
		# trim
		$fullid =~ s/^\s+|\s+$//g;
		# add space on end in case there isn't a space after the unique number in the id
		$id = $fullid;
		$id =~ s/$/ /;
		$id = substr($id, 0, index($id, ' '));
		$fullids{$id} = $fullid;
	}
}
close REFSEQFILE;

my @countlineitems;
my $firstline = 1;
open (COUNTFILE, "< $counts") or die "Could not open $counts\n";
open (OUTFILE, "> $out") or die "Could not open $out\n";
while(defined (my $l = <COUNTFILE>)) {
	chomp ($l);
	if ($firstline) {
		$firstline = 0;
	}
	else {
		@countlineitems = split(/\t/, $l, 2);
		if (@countlineitems == 2) {
			$id = $countlineitems[0];
			$id =~ s/^\s+|\s+$//g;
			if ($id =~ /^[0-9]*$/) {
				if (exists $fullids{$id}) {
					print OUTFILE "$fullids{$id}\t$countlineitems[1]\n";
				}
				else {
					print "Couldn't find full refseq for id $id\n";
				}
			}
			else {
				print OUTFILE "$l\n";
			}
		} else {
			print "Couldn't parse line $l\n";
		}
	}
}
close COUNTFILE;
close OUTFILE;
