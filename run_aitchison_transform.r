#!/usr/bin/env Rscript
options(error=recover)

source("/Volumes/data/ruth/scripts/AitchisonTransform.r")

subsys4 <- aitchison.transform.reads(filename="get_annotated_counts_output.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 2, lastsubjectindex = 21, 
groupindex = 22,lengthindex=2,outputfolder="../scripts")

