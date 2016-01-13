dir=$1;
echo "the input argument is $dir."
for D in `find $dir -type d`
do
    sample=$(basename $D);
    sample=${sample::-4};
    samfile=$D"/"$sample".sam";
    unmappedBam=$D"/"$sample"_unmapped.bam";
    samtools view -b -f 4 $samfile > $unmappedBam
    unmappedFastq=$D"/"$sample"_unmapped.fq";
    samtools bam2fq $unmappedBam > $unmappedFastq
done