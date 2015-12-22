#!/usr/bin/env Rscript
options(error=recover)

source("/Volumes/data/ruth/scripts/AitchisonTransform.r")

# subsys4 <- aitchison.transform.reads(filename="get_annotated_counts_output.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 2, lastsubjectindex = 21, groupindex = 22,lengthindex=2,outputfolder="subsys4_counts")

d <- read.table("get_annotated_counts_output.txt",sep="\t",fill=TRUE,header=TRUE)

d.subsys1 <- d[which(!is.na(d$subsys1)),]
d.subsys2 <- d[which(!is.na(d$subsys2)),]
d.subsys3 <- d[which(!is.na(d$subsys3)),]

write.table(d.subsys1,file="get_annotated_counts_subsys1_output.txt",sep="\t",quote=FALSE)
write.table(d.subsys2,file="get_annotated_counts_subsys2_output.txt",sep="\t",quote=FALSE)
write.table(d.subsys3,file="get_annotated_counts_subsys3_output.txt",sep="\t",quote=FALSE)

print("Processing subsys1 counts")

subsys1 <- aitchison.transform.reads(filename="get_annotated_counts_subsys1_output.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 2, lastsubjectindex = 21, groupindex = 23,lengthindex=2,outputfolder="subsys1_counts")

print("Processing subsys2 counts")

subsys2 <- aitchison.transform.reads(filename="get_annotated_counts_subsys2_output.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 2, lastsubjectindex = 21, groupindex = 24,lengthindex=2,outputfolder="subsys2_counts")

print("Processing subsys3 counts")

subsys3 <- aitchison.transform.reads(filename="get_annotated_counts_subsys3_output.txt",rounded=TRUE, subjects = 20, firstsubjectindex = 2, lastsubjectindex = 21, groupindex = 25,lengthindex=2,outputfolder="subsys3_counts")


