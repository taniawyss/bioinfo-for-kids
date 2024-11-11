# Code to test and prepare data for kids' bioinformatics activity

library(edgeR)
library(ggplot2)
library(ggrepel)
library(DESeq2)
library(readr)
getwd()

setwd("/Users/tania/Dropbox/My Mac (pc-10.home)/Documents/aDOF/bioinfo_for_kids/bioinfo-for-kids/docs/assets/data/")

tmp<-as.matrix(read.table("~/Dropbox/My Mac (pc-10.home)/Documents/aDOF/bioinfo_for_kids/GSE230491_AllSamples_rawCounts.txt", header=T, row.names = 1))
keep_cases<-c("case25_HOM",  "case21_HOM2",  "case24_HOM1", # "case21_HOM1",
              # "case24_HOM2", 
              "case22_HOM",  "case23_HOM1",
              # "case23_HOM2",
              "case11_FCGS", "case12_FCGS", "case10_FCGS",
              "case15_FCGS",  "case20_FCGS", 
              "case17_FCGS",
              "case14_FCGS", "case18_FCGS", 
              "case19_FCGS",
              "case5_FCGS" , "case8_FCGS",   "case32_PER",
              "case30_PER",  "case29_PER" , "case31_PER" , "case28_PER" )

# change names of HOM; PER and FCGS to something more meaningfull!
# Feline chronic gingivostomatitis FCGS
# include oral pain, difficulty prehending food, ptyalism, and lack of grooming behavior
# treatment is limited: life-long medication, surgery that doesn't always work.
# 

tmp<-tmp[-c(which(rowSums(tmp)==0)),keep_cases]
colnames(tmp)<-gsub("HOM1", "Sain", colnames(tmp))
colnames(tmp)<-gsub("HOM2", "Sain", colnames(tmp))
colnames(tmp)<-gsub("HOM3", "Sain", colnames(tmp))
colnames(tmp)<-gsub("HOM", "Sain", colnames(tmp))
colnames(tmp)<-gsub("case", "chat", colnames(tmp))
colnames(tmp)<-gsub("FCGS", "Chronique", colnames(tmp))
colnames(tmp)<-gsub("PER", "Legere", colnames(tmp))

cpm_counts<-edgeR::cpm(tmp, log = TRUE, prior.count = 1)

case20_FCGS <- cpm_counts[, "chat20_Chronique"]
names(case20_FCGS)<-rownames(cpm_counts)

cpm_counts<-cpm_counts[,-c(which(colnames(cpm_counts)=="chat20_Chronique"))]

condition<-as.data.frame(cbind(sampleID=colnames(cpm_counts),
                 condition=sapply(strsplit(colnames(cpm_counts), "_"), '[', 2)))

sd_count<-sort(apply(cpm_counts, 1, sd), decreasing = T)

cpm_var<-cpm_counts[names(sd_count)[1:500],]

# Create CSV for 
if(FALSE) {
write.csv(cpm_var, "genes_gingivite_chats.csv",
            quote = FALSE, row.names = TRUE)
} 

case20_FCGS <- case20_FCGS[names(sd_count)[1:500]]
identical(rownames(cpm_var), names(case20_FCGS))
# [1] TRUE
if(FALSE) {
write.csv(cbind(Cappuccino=case20_FCGS), "chat20_cappuccino_genes.csv", quote = FALSE, row.names = TRUE)
}

pca<-prcomp(t(cpm_var), scale. = TRUE, center = TRUE)

plot(pca$x[,1], pca$x[,2])
pca_res <- as.data.frame(pca$x)
pca_res$condition<-factor(condition$condition)
  
ggplot(pca_res, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point() +
  geom_text_repel(label=rownames(pca_res))

# Create a heatmap of some significant genes
## DESeq2:
dds <- DESeqDataSetFromMatrix(countData=tmp[,-c(which(colnames(tmp)=="chat20_Chronique"))]
, colData=condition, design= ~condition)
dds <- DESeq(dds) 

levels(as.factor(condition$condition))
# [1] "FCGS" "HOM"  "PER" 
deseq2_res<-as.data.frame(results(dds,  
                                  alpha=0.05, 
                                  contrast=c("condition", "Chronique","Sain"))) 

deseq2_res<-subset(deseq2_res, rownames(deseq2_res) %in% rownames(cpm_var))
# up-reg, down-reg

genes<-c("ENSFCAG00000005637", "ENSFCAG00000045399", "ENSFCAG00000009165",
         "ENSFCAG00000013829","ENSFCAG00000028691", 
         "ENSFCAG00000015193", "ENSFCAG00000036851", "ENSFCAG00000009900",
         "ENSFCAG00000041420", "ENSFCAG00000041248")

diff_genes<-cpm_var[genes,]    

# pour JOM:
heatmap(diff_genes, scale = "row", cexCol = 0.8, cexRow = 0.8)

# play with colors, explain rows and columns
# options:
# terrain.color(), rainbow(), heat.colors(), topo.colors() or cm.colors()
heatmap(diff_genes, scale = "row", col=rainbow(50))
heatmap(diff_genes, scale = "row", col=heat.colors(50), cexCol=0.8, cexRow = 0.5)

# Maintenant, le travail du biologiste avec lequel ou laquelle le/la bioinformaticienne
# collabore c'est de comprendre les gènes et voir si on peut donner un médicament
# aux chats malades.
# Eg ENSFCAG00000013269 = CSF3R gène du système immunitaire

#### Add case 20:

cappuccino <- read.csv("chat20_cappuccino_genes.csv", row.names = 1)

genes_avec_cappuccino<-cbind(cpm_var, cappuccino)

pca<-prcomp(t(genes_avec_cappuccino), scale. = TRUE, center = TRUE)$x
pca <- as.data.frame(pca)

pca$condition<-sapply(strsplit(colnames(genes_avec_cappuccino), "_"), '[', 2)

ggplot(pca, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point(size=2) +
  geom_text_repel(label=rownames(pca))



# https://www.nature.com/articles/s41598-023-40679-4#data-availability

