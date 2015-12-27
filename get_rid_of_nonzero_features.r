#!/usr/bin/env Rscript
options(error=recover)

# takes in one parameter for the file name of the counts table

args <- commandArgs(trailingOnly = TRUE)

countfile <- args[1]

d <- read.table(countfile,sep="\t",comment.char="",quote="",header=TRUE,check.names=FALSE)

sampleindices <- c(3:22)

d.sum <- apply(d[,sampleindices],1,sum)

d.nonzero.features <- d[which(d.sum>0),]

# get rid of file extension
countfile <- sub(".[^.]*$","",countfile,perl=TRUE)

write.table(d.nonzero.features,file=paste(countfile,"_non_zero_features.txt"),sep="\t",quote=FALSE,row.names=FALSE)
