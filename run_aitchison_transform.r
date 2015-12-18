#!/usr/bin/env Rscript
options(error=recover)

source("/Volumes/data/ruth/scripts/AitchisonTransform.r")

subsys4 <- function(filename="get_annotated_counts_output.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 2, lastsubjectindex = 21, 
groupindex = 22,lengthindex=2,outputfolder="/Volumes/data/ruth/scripts/")

write.table(subsys4, file="/Volumes/data/ruth/scripts/AitchisonTransform_output.txt",sep="\t",quote=FALSE)

