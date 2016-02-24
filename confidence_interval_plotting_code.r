## example usage
# confidence_interval_plot("data/ALDEx_output_for_stripcharts_ordered_by_effect.txt", "annotated_functions_top_20_effect_size_with_confidence_intervals.pdf")

confidence_interval_plot <- function(input, output) {
  data <- read.table(input,header=TRUE,sep="\t",quote="",comment.char="",row.names=1)

  ## if your data is not already ordered by effect, run this line
  data <- data[order(abs(data$effect),decreasing=TRUE),]

  numFeatures <- 20
  if (length(rownames(data)) < 20) {
    numFeatures <- length(rownames(data))
  }

  data.20 <- data[c(1:numFeatures),]

  #plot effect sizes for top OTUs in metagenomic
  x_axis <- c(1:numFeatures)

  effect <- c(1:numFeatures)
  effect <- data.20$effect

  effect.975 <- c(1:numFeatures)
  effect.975 <- data.20$effect.975

  effect.025 <- c(1:numFeatures)
  effect.025 <- data.20$effect.025

  function_labels <- as.character(rownames(data.20))

  label_x_axis <- x_axis - 0.30

  pdf(output)
  plot(NA, xlim=c(0,(numFeatures+1)),ylim=c((min(effect.025) - 1),(max(effect.975) + 1)),main="Confidence intervals for functions with high effect size",xlab="Functional annotation",ylab="Effect size",xaxt='n')
  points(x_axis, effect,ann=FALSE,pch=19)
  arrows(x_axis, effect.025, x_axis, effect.975, length=0.05, angle=90, code=3)
  text(x =label_x_axis, y = par("usr")[3] + 17, labels = function_labels,srt = 90, pos = 1, xpd = TRUE, cex=0.5)
  dev.off()
}
