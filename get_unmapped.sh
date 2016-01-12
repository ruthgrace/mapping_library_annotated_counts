dir=$1;
dir=${dir%%*( )} # trim trailling newline/whitespace
echo "the input argument is $dir.\n"
for D in `find . -type d`
do
    sample=${D::-4};
    echo "sample is $sample\n";
    samfile=$sample+".sam";
    echo "samfile is $samfile\n";
    unmapped=$sample+"_unmapped.sam";
    echo "unmapped file is $unmapped";
    unmappedFasta = $sample+"_unmapped.fa";
    echo "unmapped fasta is $unmappedFasta";
done