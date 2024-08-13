library(tidyverse)
data<-read.table("PC_combined.txt")
colnames(data)<-c("Total_Kernels", "Transmission_Rate", "name", "type")
dataplot<-ggplot(data=data, mapping = aes(x=Total_Kernels, y=Transmission_Rate)) + geom_point(aes(shape=type, color=type)) + ylim(0, 1) + geom_smooth(method = "lm")
dir<-basename(getwd())
pdf(paste0("~/Pollen_Crosses/Graphs/",dir,".pdf"))
print(dataplot+ggtitle("Total Kernels vs. Transmission Rate"))

dev.off()
