#!/usr/bin/env Rscript
options(error=recover)

source("/Volumes/data/ruth/scripts/AitchisonTransform.r")

subsys4 <- aitchison.transform.reads(filename="annotated_counts_with_refseq_length.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 3, lastsubjectindex = 22, groupindex = 23,lengthindex=2,outputfolder="subsys4_counts")


### output tables for other subsys (in my case actually only subsys2 has NA)
# d <- read.table("annotated_counts_with_refseq_length.txt",sep="\t",fill=TRUE,header=TRUE,quote="",comment.char="")

# d.subsys1 <- d[which(!is.na(d$subsys1)),]
# d.subsys2 <- d[which(!is.na(d$subsys2)),]
# d.subsys3 <- d[which(!is.na(d$subsys3)),]

# write.table(d.subsys1,file="annotated_counts_subsys1.txt",sep="\t",quote=FALSE)
# write.table(d.subsys2,file="annotated_counts_subsys2.txt",sep="\t",quote=FALSE)
# write.table(d.subsys3,file="annotated_counts_subsys3.txt",sep="\t",quote=FALSE)

