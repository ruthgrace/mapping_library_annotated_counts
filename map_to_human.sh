dir=$1; # first parameter is the directory of mapped samples
hg19=$2; # second parameter is the location of the hg19 reference genome index
for D in `find $dir -type d`
do
    sample=$(basename $D);
    sample=${sample::-4};
    unmappedFasta=$D"/"$sample"_unmapped.fa";
    mappedToHuman=$D"/"$sample"_mapped_to_human.sam";
    unmappedToHuman=$D"/"$sample"_unmapped_to_human.fq";
    bowtie2 -x $hg19 -U $unmappedFasta -S $mappedToHuman -p 10 -N 1 -D 20 -R 3 -L 20 --un $unmappedToHuman; #2> $DIR/errlog.txt
done