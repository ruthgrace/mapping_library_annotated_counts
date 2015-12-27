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
