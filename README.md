# mapping_library_annotated_counts

This is a continuation of the [functional mapping library pipeline](https://github.com/ruthgrace/make_functional_mapping_library). These scripts annotate reference sequences and amalgamate counts for each annotation.

## Annotation by SEED hierarchy

The functional mapping library pipeline ended with blasting the reference sequences against the SEED database. Run the following script to match the reference sequences to their unique subsys4 categorization according to the best BLAST hit that meets a threshhold. The -i flag should be followed by your blast output file.

```
nohup perl get_subsys4.pl -i /Volumes/data/ruth/nafld_blast/blast.out > get_subsys4_nohup.out 2>&1&
```

My `get_subsys4_nohup.out` has `nohup: ignoring input` on the first line, but is otherwise properly formatted output. I copied `get_subsys4_nohup.out` into `get_subsys4_output.txt` and remove the first line in `get_subsys4_output.txt`. Now our subsystem 4 annotations are ready to be piped into a script that outputs the SEED hierarchy for each subsystem 4. There can be multiple hierarchies for a subsys4 (they can fit into multiple higher level categorizations), and these are printed out on separate lines.

```
nohup perl get_seed_hier.pl -i get_subsys4_output.txt > get_seed_hier_nohup.out 2>&1&
```

Again I copy `get_seed_hier_nohup.out` into `get_seed_hier_output.txt` and remove the first line.

## Amalgamating read counts for each subsys4

Aggregate counts for each subsys4. The first parameter of the `get_annotated_counts.pl` is the output from get_seed_hier.pl, the second parameter is the folder in which the bowtie mapping was completed (mapping scripts are in the [functional mapping library pipeline](https://github.com/ruthgrace/make_functional_mapping_library), and the third parameter is the name of the output file.

```
nohup perl get_annotated_counts.pl get_seed_hier_output.txt /Volumes/data/ruth/mapping_data get_annotated_counts_output.txt > get_annotated_counts_nohup.out 2>&1&
```

I was dumb and had spaces in my refseq IDs when I put them through BLAST. This is my one-off script for fixing my refseq IDs. The first parameter is the count file, the second is the refseq fasta file, and the third is the output path.

```
nohup perl ensure_full_refseq_ids.pl get_annotated_counts_output.txt /Volumes/data/ruth/refseqs/all_genus_orfs_clustered_at_100_unique_sorted.fa annotated_counts_with_full_refseq_ids.txt > ensure_full_refseq_ids_nohup.out 2>&1&
```

You'll also want to add in the length of your refseqs in your counts file. As with the script before, the first parameter is the count file, the second is the refseq fasta file, and the third is the output path.

```
nohup perl add_read_lengths.pl annotated_counts_with_full_refseq_ids.txt /Volumes/data/ruth/refseqs/all_genus_orfs_clustered_at_100_unique_sorted.fa annotated_counts_with_full_refseq_ids.txt annotated_counts_with_refseq_length.txt > add_read_lengths_nohup.out 2>&1&
```

## Aitchison transform & ALDEx analysis

You can run the aitchison transform script and the ALDEx analysis using the `run_aldex_for_stripcharts.R` script. For some reason sometimes some of the functions can't be run in a batch using the nohup command, but work fine if you run them line by line.

The Aitchison transform script amalgamates counts to unique subsys hierarchies. The ALDEx (Anova-Like Differential Expression) analysis calculates the variance within groups for each feature and the variance between groups for each feature to arrive upon an effect size.

After running this script, you will get some files that are output in intermediate stages (so that you can read them in and start the script from the middle if necessary), plus `ALDEx_all_hierarchies_output.pdf`, which has a difference within vs. difference between plot for subsys4, and `ALDEx_output_for_stripcharts_ordered_by_effect.txt`, which you can examine to see which features had the greatest measured effect, and which you can also feed into the stripchart plots in the next section.

## Stripchart plots 

Features can fall into multiple subsys1, subsys2, and subsys3 categories for each subsys4 category, and can be better visualized with stripcharts. Stripcharts can be generated using the `SEED_stripcharts_aldex2_update.R` script.

## Exploring unmapped reads

### Check how much of your unmapped reads map to the human genome

The next script requires seqtk to be installed. You can install it like so:

```
git clone https://github.com/lh3/seqtk.git
cd seqtk
make
```

Don't forget to add it to your PATH.

Isolate the unmapped sequences and convert to FASTA (give the mapped files directory as the parameter):

```
nohup ./get_unmapped.sh /Volumes/data/ruth/mapping_data > get_unmapped_seqs_nohup.out 2>&1&
```

Run Bowtie2 against the hg19 human genome reference. The first parameter is the mapped files directory and the 2nd parameter is the hg19 bowtie index. You can download the hg19 reference genome from http://bowtie-bio.sourceforge.net/bowtie2/index.shtml

```
nohup ./map_to_human.sh /Volumes/data/ruth/mapping_data /Volumes/data/ruth/hg19/hg19 > map_to_human_nohup.out 2>&1&
```

### Check how much of your unmapped reads map to viruses

Download the FASTA files for all the virus genomes on NCBI:

```
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Viruses/all.ffn.tar.gz
```

Unzip the file. You will get a folder for each genome with one or more .ffn files inside. Concatenate all the .ffn files (I think the strain name is in all the sequence identifiers so I haven't bothered to make sure the identifiers unique):

```
cat ./*/*.ffn > all_viruses.ffn
```

Replace all spaces in sequence names with underscores

```
sed -i.backup '/^>/ s/ /_/g' all_viruses.ffn
```

Build the Bowtie2 index for the viruses

```
nohup bowtie2-build -f /Volumes/data/ruth/viruses/all_viruses.ffn ncbi_viruses &
```

Perform mapping

```
nohup ./map_to_virus.sh /Volumes/data/ruth/mapping_data /Volumes/data/ruth/virus_bowtie_index/ncbi_viruses > map_to_virus_nohup.out 2>&1&

```

### Run analysis on data subsets

I am subsetting the data by carbohydrates and lipids, by SEED subsystem 1 categorization:

```
nohup awk '$24 == "Carbohydrates" { print $0 }' annotated_counts_with_refseq_length_non_zero_features.txt > annotated_carbohydrate_counts_with_refseq_length.txt 2>&1&
nohup awk '/Fatty Acids/' annotated_counts_with_refseq_length_non_zero_features.txt > annotated_lipid_counts_with_refseq_length.txt 2>&1&
```

Delete the first line (that says 'nohup: ignoring input') in `annotated_carbohydrate_counts_with_refseq_length.txt` and `annotated_lipid_counts_with_refseq_length.txt` (I used Vim for this). Add the file header from `annotated_counts_with_refseq_length.txt` to both files:

```
refseq	length	HLD_85_R1	HLD_80_R1	HLD_72_2_R1	HLD_47_R1	HLD_28_R1	HLD_23_R1	HLD_112_R1	HLD_111_2_R1	HLD_102_R1	HLD_100_R1	CL_177_R1	CL_173_2_R1CL_169_BL_R1	CL_166_BL_R2_R1	CL_165_R1	CL_160_R1	CL_144_2_R1	CL_141_BL_R2_R1	CL_139_BL_2_R1	CL_119_R1	subsys4	subsys1	subsys2	subsys3
```

Run the ALDEx analysis using `run_aldex_for_stripcharts.r` (you'll have to run it line by line since for some reason the `AitchisonTransform.r` script doesn't work unless it's run line by line). Create stripcharts using `SEED_stripcharts_aldex2_update.R`.

Extract the same genes from the analysis with all the genes included for comparison (in the `subsys4_counts` folder)

```
nohup awk '$2 == "Carbohydrates" { print $0 }' subsys4_counts/ALDEx_output_for_stripcharts_ordered_by_effect.txt > subsys4_counts/ALDEx_output_for_stripcharts_ordered_by_effect_carbohydrates_only.txt 2>&1&
nohup awk '/Fatty Acids/' subsys4_counts/ALDEx_output_for_stripcharts_ordered_by_effect.txt > subsys4_counts/ALDEx_output_for_stripcharts_ordered_by_effect_lipids_only.txt 2>&1&
```

Add the file header to `subsys4_counts/ALDEx_output_for_stripcharts_ordered_by_effect_carbohydrates_only.txt` and `subsys4_counts/ALDEx_output_for_stripcharts_ordered_by_effect_lipids_only.txt`.

```
subsys4 subsys1 subsys2 subsys3 rab.all rab.win.healthy rab.win.nash    diff.btw        diff.win        diff.btw.025    diff.btw.975    diff.win.025    diff.win.975    effect  effect.025      effect.975      overlap we.ep   we.eBH  wi.ep   wi.eBH
```

Plot stripcharts for `subsys4_counts/ALDEx_output_for_stripcharts_ordered_by_effect_carbohydrates_only.txt` and `subsys4_counts/ALDEx_output_for_stripcharts_ordered_by_effect_lipids_only.txt` using `SEED_stripcharts_aldex2_update.R`.

Plot confidence intervals of genes with highest effect size




