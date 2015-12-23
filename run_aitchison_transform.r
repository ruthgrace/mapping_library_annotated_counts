#!/usr/bin/env Rscript
options(error=recover)

source("/Volumes/data/ruth/scripts/AitchisonTransform.r")

subsys4 <- aitchison.transform.reads(filename="annotated_counts_with_refseq_length.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 3, lastsubjectindex = 22, groupindex = 23,lengthindex=2,outputfolder="subsys4_counts")

d <- read.table("annotated_counts_with_refseq_length.txt",sep="\t",fill=TRUE,header=TRUE)

d.subsys1 <- d[which(!is.na(d$subsys1)),]
d.subsys2 <- d[which(!is.na(d$subsys2)),]
d.subsys3 <- d[which(!is.na(d$subsys3)),]

write.table(d.subsys1,file="get_annotated_counts_subsys1_output.txt",sep="\t",quote=FALSE)
write.table(d.subsys2,file="get_annotated_counts_subsys2_output.txt",sep="\t",quote=FALSE)
write.table(d.subsys3,file="get_annotated_counts_subsys3_output.txt",sep="\t",quote=FALSE)

