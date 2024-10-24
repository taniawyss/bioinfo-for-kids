

library(edgeR)
library(ggplot2)
library(ggrepel)

setwd("/Users/tania/Dropbox/My Mac (pc-10.home)/Documents/aDOF/bioinfo_for_kids")

tmp<-as.matrix(read.table("GSE230491_AllSamples_rawCounts.txt", header=T, row.names = 1))
keep_cases<-c("case25_HOM",  "case21_HOM2",  "case24_HOM1", "case21_HOM1",
              "case24_HOM2", "case22_HOM",  "case23_HOM1",
              "case23_HOM2", "case11_FCGS", "case12_FCGS", "case10_FCGS",
              "case15_FCGS",  "case20_FCGS", 
              "case17_FCGS",
              "case14_FCGS", "case18_FCGS", 
              "case19_FCGS",
              "case5_FCGS" , "case8_FCGS",   "case32_PER",
              "case30_PER",  "case29_PER" , "case31_PER" , "case28_PER" )


tmp<-tmp[-c(which(rowSums(tmp)==0)),keep_cases]
case20_FCGS <- tmp[, "case20_FCGS"]

tmp<-tmp[,-c(which(colnames(tmp)=="case20_FCGS"))]


condition<-as.data.frame(cbind(sampleID=colnames(tmp),
                 condition=sapply(strsplit(colnames(tmp), "_"), '[', 2)))
condition$condition[condition$condition == "HOM1"]<-"HOM"
condition$condition[condition$condition == "HOM2"]<-"HOM"
condition$condition[condition$condition == "HOM3"]<-"HOM"

cpm_counts<-edgeR::cpm(tmp, log = TRUE, prior.count = 1)
sd_count<-sort(apply(cpm_counts, 1, sd), decreasing = T)

cpm_var<-cpm_counts[names(sd_count)[1:500],]



pca<-prcomp(t(cpm_var), scale. = TRUE, center = TRUE)

plot(pca$x[,1], pca$x[,2])
pca_res <- as.data.frame(pca$x)
pca_res$condition<-factor(condition$condition)
  
ggplot(pca_res, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point() +
  geom_text_repel(label=rownames(pca_res))




# Add case 20:

tmp_2<-cbind(tmp, case20_FCGS)

condition_2<-rbind(condition, c("case20_FCGS", "inconnu"))
condition_2$condition[condition_2$condition == "HOM1"]<-"HOM"
condition_2$condition[condition_2$condition == "HOM2"]<-"HOM"
condition_2$condition[condition_2$condition == "HOM3"]<-"HOM"

cpm_counts2<-edgeR::cpm(tmp_2, log = TRUE, prior.count = 1)
sd_count<-sort(apply(cpm_counts2, 1, sd), decreasing = T)

cpm_var<-cpm_counts2[names(sd_count)[1:500],]

pca<-prcomp(t(cpm_var), scale. = TRUE, center = TRUE)

plot(pca$x[,1], pca$x[,2])
pca_res <- as.data.frame(pca$x)
pca_res$condition<-factor(condition_2$condition)

ggplot(pca_res, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point() +
  geom_text_repel(label=rownames(pca_res))


