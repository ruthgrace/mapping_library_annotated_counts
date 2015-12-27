#!/usr/bin/env Rscript
options(error=recover)

source("/Volumes/data/ruth/scripts/AitchisonTransform.r")

# subsys4 <- aitchison.transform.reads(filename="annotated_counts_with_refseq_length.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 3, lastsubjectindex = 22, groupindex = 23,lengthindex=2,outputfolder="subsys4_counts")

subsys.hierarchies <- aitchison.transform.reads(filename="annotated_counts_with_refseq_length_non_zero_features.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 3, lastsubjectindex = 22, groupindex = 23,lengthindex=2,outputfolder=".")

# filename="annotated_counts_with_refseq_length.txt"
# rounded=TRUE
# subjects = 20
# firstsubjectindex = 3
# lastsubjectindex = 22
# groupindex = 23
# lengthindex=2
# outputfolder="subsys4_counts"
