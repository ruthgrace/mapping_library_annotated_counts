dir=$1;
echo "the input argument is $dir."
for D in `find $dir -type d`
do
    sample=$(basename $D);
    sample=${sample::-4};
    samfile=$D"/"$sample".sam";
    echo "samfile is $samfile";
    unmapped=$D"/"$sample"_unmapped.sam";
    echo "unmapped file is $unmapped";
    unmappedFasta=$D"/"$sample"_unmapped.fa";
    echo "unmapped fasta is $unmappedFasta";
done