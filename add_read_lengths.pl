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
my $outfile = $ARGV[2];
