inputfile <- "subsys4_counts/ALDEx_output_for_stripcharts.txt"
outputfolder <- "subsys4_counts"
d <- read.table(file=inputfile, header=TRUE, sep="\t", quote="",comment.char="")	

levels <- paste( "subsys", 1:4, sep="" )

for (i in 1:3) {
  g <- levels[i]
  
  subsys <- d[,which(colnames(d)==g)]
  
  subsys.unique <- unique(subsys)
  
  subsys.med.med.effect <- data.frame(matrix(NA,nrow=length(subsys.unique),ncol=2))
  
  subsys.med.med.effect[,2] <- sapply(subsys.unique,function(x) { return(median(d$effect[which(subsys==x)])) } )  
  
  subsys.med.med.effect[,2] <- subsys.med.med.effect[order(abs(subsys.med.med.effect[,2]),decreasing=TRUE),2]

  subsys.med.med.effect[,1] <- subsys.unique[order(abs(subsys.med.med.effect[,2]),decreasing=TRUE)]

  colnames(subsys.med.med.effect) <- c(g,"median_median_effect")
  
  write.table(subsys.med.med.effect,file=paste(outputfolder,"/",g,"_median_median_effect.txt",sep=""),sep="\t",quote=FALSE,row.names=FALSE)
  
}
