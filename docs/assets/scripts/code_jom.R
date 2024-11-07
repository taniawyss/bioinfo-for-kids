# Code to test and prepare data for kids' bioinformatics activity

library(edgeR)
library(ggplot2)
library(ggrepel)
library(DESeq2)
library(readr)

setwd("/Users/tania/Dropbox/My Mac (pc-10.home)/Documents/aDOF/bioinfo_for_kids")

tmp<-as.matrix(read.table("GSE230491_AllSamples_rawCounts.txt", header=T, row.names = 1))
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

case20_FCGS <- tmp[, "chat20_Chronique"]
names(case20_FCGS)<-rownames(tmp)

tmp<-tmp[,-c(which(colnames(tmp)=="chat20_Chronique"))]

condition<-as.data.frame(cbind(sampleID=colnames(tmp),
                 condition=sapply(strsplit(colnames(tmp), "_"), '[', 2)))

cpm_counts<-edgeR::cpm(tmp, log = TRUE, prior.count = 1)
sd_count<-sort(apply(cpm_counts, 1, sd), decreasing = T)

cpm_var<-cpm_counts[names(sd_count)[1:500],]

case20_FCGS <- case20_FCGS[names(sd_count)[1:500]]
# identical(rownames(cpm_var), names(case20_FCGS))
# [1] TRUE

pca<-prcomp(t(cpm_var), scale. = TRUE, center = TRUE)

plot(pca$x[,1], pca$x[,2])
pca_res <- as.data.frame(pca$x)
pca_res$condition<-factor(condition$condition)
  
ggplot(pca_res, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point() +
  geom_text_repel(label=rownames(pca_res))

# Create a heatmap of some significant genes
## DESeq2:
dds <- DESeqDataSetFromMatrix(countData=tmp, colData=condition, design= ~condition)
dds <- DESeq(dds) 

levels(as.factor(condition$condition))
# [1] "FCGS" "HOM"  "PER" 
deseq2_res<-as.data.frame(results(dds,  
                                  alpha=0.05, 
                                  contrast=c("condition", "Chronique","Sain"))) 

rownames(tmp)
# up-reg, down-reg
genes_1<-c()
genes<-c("ENSFCAG00000013269", "ENSFCAG00000025666", "ENSFCAG00000029354", "ENSFCAG00000022006", 
         "ENSFCAG00000027677", "ENSFCAG00000019058", "ENSFCAG00000005638", "ENSFCAG00000009165",
         "ENSFCAG00000041420", "ENSFCAG00000013885", "ENSFCAG00000013814", "ENSFCAG00000004720", 
         "ENSFCAG00000042595", "ENSFCAG00000034685", "ENSFCAG00000018172")
genes<-which(genes %in% rownames(cpm_var))

cpm_genes<-cpm_var[genes,]    

# cpm_genes<-cpm_genes[, condition$condition!="PER"]


# pour JOM:
heatmap(cpm_genes, scale = "row")

# play with colors, explain rows and columns
# options:
# terrain.color(), rainbow(), heat.colors(), topo.colors() or cm.colors()
heatmap(cpm_genes, scale = "row", col=rainbow(50))
heatmap(cpm_genes, scale = "row", col=heat.colors(50), cexCol=0.8, cexRow = 0.5)

# Maintenant, le travail du biologiste avec lequel ou laquelle le/la bioinformaticienne
# collabore c'est de comprendre les gènes et voir si on peut donner un médicament
# aux chats malades.
# Eg ENSFCAG00000013269 = CSF3R gène du système immunitaire



#### Add case 20:

tmp_2<-cbind(tmp, case20_FCGS)

condition_2<-rbind(condition, c("case20_FCGS", "inconnu"))
# condition_2$condition[condition_2$condition == "HOM1"]<-"HOM"
# condition_2$condition[condition_2$condition == "HOM2"]<-"HOM"
# condition_2$condition[condition_2$condition == "HOM3"]<-"HOM"

cpm_counts2<-edgeR::cpm(tmp_2, log = TRUE, prior.count = 1)
sd_count<-sort(apply(cpm_counts2, 1, sd), decreasing = T)

cpm_var<-cpm_counts2[names(sd_count)[1:500],]

pca<-prcomp(t(cpm_var), scale. = TRUE, center = TRUE)

plot(pca$x[,1], pca$x[,2])
pca_res <- as.data.frame(pca$x)
pca_res$condition<-factor(condition_2$condition)

# Plot sans nom d'échantillon:
ggplot(pca_res, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point(size=4) 

# Plot avec nom d'échantillon:
ggplot(pca_res, aes(x=PC1, y=PC2, colour = condition)) +
  geom_point(size=4) +
  geom_text_repel(label=rownames(pca_res))

# https://www.nature.com/articles/s41598-023-40679-4#data-availability

