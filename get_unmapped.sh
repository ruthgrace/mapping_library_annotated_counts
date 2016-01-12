dir=$1;
echo "the input argument is $dir."
for D in `find $dir -type d`
do
    sample=$(basename $D);
    sample=${sample::-4};
    samfile=$D"/"$sample".sam";
    unmappedBam=$D"/"$sample"_unmapped.sam";
    samtools view -b -f 4 $samfile > $unmappedBam
    unmappedFasta=$D"/"$sample"_unmapped.fa";
    samtools bam2fq $unmappedBam | seqtk seq -A > $unmappedFasta
done