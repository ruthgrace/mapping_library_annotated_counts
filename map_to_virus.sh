dir=$1; # first parameter is the directory of mapped samples
virus_index=$2; # second parameter is the location of the hg19 reference genome index
for D in `find $dir -type d`
do
    sample=$(basename $D);
    sample=${sample::-4};
    unmappedFastq=$D"/"$sample"_unmapped.fq";
    mappedToVirus=$D"/"$sample"_mapped_to_virus.sam";
    unmappedToVirus=$D"/"$sample"_unmapped_to_virus.fq";
    bowtie2 -x $virus_index -U $unmappedFastq -S $mappedToVirus -p 10 -N 1 -D 20 -R 3 -L 20 --un $unmappedToVirus; #2> $DIR/errlog.txt
done