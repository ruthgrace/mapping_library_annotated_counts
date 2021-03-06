#!/usr/bin/env Rscript
options(error=recover)

library(ALDEx2)

outfolder <- "subsys4_counts"

nash <- c("CL_166_BL_R2_R1", "CL_169_BL_R1", "CL_139_BL_2_R1", "CL_173_2_R1", "CL_144_2_R1", "CL_177_R1", "CL_160_R1", "CL_165_R1", "CL_119_R1", "CL_141_BL_R2_R1")

healthy <- c("HLD_100_R1", "HLD_102_R1", "HLD_111_2_R1", "HLD_80_R1", "HLD_85_R1", "HLD_28_R1", "HLD_47_R1", "HLD_72_2_R1", "HLD_112_R1", "HLD_23_R1")

d <- read.table("subsys4_counts/AitchisonTransformedDataForALDExInput.txt",sep="\t",header=TRUE,row.names=1,quote="",comment.char="")

conditions <- colnames(d)

conditions[which(conditions %in% nash)] <- "nash"
conditions[which(conditions %in% healthy)] <- "healthy"

### for running aldex line by line
reads <- d
mc.samples=128
test="t"
effect=TRUE
include.sample.summary=FALSE
verbose=FALSE
useMC = FALSE
summarizedExperiment=NULL

# aldex.clr kills some reads for some reason
# - getting error in aldex.clr when checking summarizedExperiment

x <- aldex(d, conditions, mc.samples=128)

write.table(x,file=paste(outfolder, "ALDEx_output.txt",sep="/"),,sep="\t",quote=FALSE)

x.ordered <- x[order(abs(x$effect),decreasing=TRUE),]

write.table(x.ordered,file=paste(outfolder,"ALDEx_output_ordered_by_effect.txt"),sep="\t",quote=FALSE)

pdf(paste(outfolder,"ALDEx_output.pdf",sep="/"))

aldex.plot(x)

dev.off()

