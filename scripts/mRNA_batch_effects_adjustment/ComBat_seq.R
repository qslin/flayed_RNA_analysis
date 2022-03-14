install.packages("devtools")
devtools::install_github("zhangyuqing/sva-devel")
library(edgeR)

outdir <- "/Volumes/GoogleDrive/My Drive/Corolla_tube/RNAseq/SAM_mRNA_sequencing/4_Batch_effects/"
setwd(outdir)

c <- read.table("../3_Normalize/raw_count.txt", header = TRUE, sep = "\t", row.names = "gene_id")

batch <- c(1,3,2,1,2,1,1,2,2,1,2,1,3,3,3)
adjusted <- sva::ComBat_seq(c, batch=batch, group=NULL)

write.csv(adjusted, 'ComBat_seq_batch_adjusted_counts.csv', quote = FALSE)

g <- read.table("../3_Normalize/sample_info.txt", header = TRUE, sep = "\t")

d <- DGEList(counts=adjusted,group=g$Group)
d

keep <- rowSums(cpm(d)>1) >= 2 # keep a gene if it has a cpm >1 for at least two samples
d <- d[keep,]
dim(d)

d$samples$lib.size <- colSums(d$counts)
d$samples

d <- calcNormFactors(d)
d

png("ComBat_seq_batch_adjusted_MDS.png")
plotMDS(d, method="bcv", col=as.numeric(d$samples$group))
dev.off()

write.csv(cpm(d, normalized.lib.sizes=TRUE), 'ComBat_seq_batch_adjusted_normalized_cpm.csv', quote = FALSE)

####
group <- c(1,1,1,2,2,3,4,4,4,5,5,6,6,6,6)
adjusted_counts <- sva::ComBat_seq(c, batch=batch, group=group)

write.csv(adjusted_counts, 'ComBat_seq_batch_group_adjusted_counts.csv', quote = FALSE)

g <- read.table("../3_Normalize/sample_info.txt", header = TRUE, sep = "\t")

d <- DGEList(counts=adjusted_counts,group=g$Group)
d

keep <- rowSums(cpm(d)>1) >= 2 # keep a gene if it has a cpm >1 for at least two samples
d <- d[keep,]
dim(d)

d$samples$lib.size <- colSums(d$counts)
d$samples

d <- calcNormFactors(d)
d

png("ComBat_seq_batch_group_adjusted_MDS.png")
plotMDS(d, method="bcv", col=as.numeric(d$samples$group))
dev.off()

write.csv(cpm(d, normalized.lib.sizes=TRUE), 'ComBat_seq_batch_group_adjusted_normalized_cpm.csv', quote = FALSE)

####visualize by PCA
library(ggfortify)
library(ggrepel)
c_pca<-prcomp(c)
df_out_r <- as.data.frame(c_pca$rotation)
df_out_r$feature <- g$Library
df_out_r$group <- as.character(g$Group)
ggplot(df_out_r,aes(x=PC1,y=PC2,label=feature,color=group))+scale_fill_brewer(palette="Spectral")+
  geom_point()+geom_text_repel(size=5)+theme_classic()+theme(legend.position = "none")

