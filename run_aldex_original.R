#!/usr/bin/env Rscript
options(error=recover)

library(ALDEx2)

nash <- c("CL_166_BL_R2_R1", "CL_169_BL_R1", "CL_139_BL_2_R1", "CL_173_2_R1", "CL_144_2_R1", "CL_177_R1", "CL_160_R1", "CL_165_R1", "CL_119_R1", "CL_141_BL_R2_R1")

healthy <- c("HLD_100_R1", "HLD_102_R1", "HLD_111_2_R1", "HLD_80_R1", "HLD_85_R1", "HLD_28_R1", "HLD_47_R1", "HLD_72_2_R1", "HLD_112_R1", "HLD_23_R1")

d <- read.table("AitchisonTransformedDataForALDExInput.txt",sep="\t",header=TRUE,row.names=1,quote="",comment.char="")

conditions <- colnames(d)

conditions[which(conditions %in% nash)] <- "nash"
conditions[which(conditions %in% healthy)] <- "healthy"

x <- aldex(d, conditions, mc.samples=2048)

write.table(x,file="ALDEx_output_fixed.txt",sep="\t",quote=FALSE)

pdf("ALDEx_output_fixed.pdf")

aldex.plot(x, type=”MA”)
aldex.plot(x, type=”MW”)

dev.off()

