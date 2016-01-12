dir=$1;
echo "the input argument is $dir."
for D in `find $dir -type d`
do
    echo "dir is $D"
    sample=$(basename d);
    echo "sample is $sample after basename";
    sample=${sample::-4};
    echo "sample is $sample";
    samfile=$sample".sam";
    echo "samfile is $samfile";
    unmapped=$sample"_unmapped.sam";
    echo "unmapped file is $unmapped";
    unmappedFasta=$sample"_unmapped.fa";
    echo "unmapped fasta is $unmappedFasta";
done