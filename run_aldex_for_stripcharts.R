# runs ALDEx for stripcharts

options(error=recover)

library(ALDEx2)

sampleindexes <- c(2:21)

outfolder <- "subsys4_counts"

nash <- c("CL_166_BL_R2_R1", "CL_169_BL_R1", "CL_139_BL_2_R1", "CL_173_2_R1", "CL_144_2_R1", "CL_177_R1", "CL_160_R1", "CL_165_R1", "CL_119_R1", "CL_141_BL_R2_R1")

healthy <- c("HLD_100_R1", "HLD_102_R1", "HLD_111_2_R1", "HLD_80_R1", "HLD_85_R1", "HLD_28_R1", "HLD_47_R1", "HLD_72_2_R1", "HLD_112_R1", "HLD_23_R1")

# read in fully annotated counts with hierarchies
d <- read.table("annotated_counts_with_refseq_length.txt",sep="\t",header=TRUE,row.names=1,quote="",comment.char="")

#put subsystems in hierarchies with "|||" as separator
subsys <- paste(d$subsys4, d$subsys1, d$subsys2, d$subsys3, sep="|||")

subsys.unique <- unique(subsys)

subsys.nums <- c(1:length(subsys.unique))

d.samples.mat <- as.matrix(d[,sampleindexes])

aggregate.subsys.counts <- function(x,d.samples.mat,subsys,subsys.unique) {
  indices <- which(subsys==subsys.unique[x])
  if (length(indices) == 1) {
    return(d.samples.mat[which(subsys==subsys.unique[x]),])
  }
  else {
    return(apply(d.samples.mat[which(subsys==subsys.unique[x]),],2,sum))
  }
}

d.aggregate <- sapply(subsys.nums,function(x) { return(aggregate.subsys.counts(x,d.samples.mat,subsys,subsys.unique)) } )

d.aggregate <- t(d.aggregate)

rownames(d.aggregate) <- subsys.unique

aldex.data <- d.aggregate

conditions <- colnames(aldex.data)
conditions[which(conditions %in% nash)] <- "nash"
conditions[which(conditions %in% healthy)] <- "healthy"

aldex.data <- data.frame(aldex.data)

x <- aldex(aldex.data, conditions, mc.samples=128)

write.table(x,file=paste(outfolder, "ALDEx_output_for_stripcharts_merged_subsys.txt",sep="/"),,sep="\t",quote=FALSE)

x.separate.subsys <- matrix(NA,nrow=nrow(x),ncol=(ncol(x)+4))

x.separate.subsys[,c(1:4)] <- t(data.frame(strsplit(rownames(x),split="|||")))

x.separate.subsys[,c(5:ncol(x.separate.subsys))] <- x

write.table(x,file=paste(outfolder, "ALDEx_output_for_stripcharts.txt",sep="/"),,sep="\t",quote=FALSE,row.names=FALSE)

pdf(paste(outfolder,"ALDEx_all_hierarchies_output.pdf",sep="/"))

aldex.plot(x)

dev.off()

