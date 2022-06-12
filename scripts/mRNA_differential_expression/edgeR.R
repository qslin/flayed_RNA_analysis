# This pipeline refers to https://web.stanford.edu/class/bios221/labs/rnaseq/lab_4_rnaseq.html
# Some notes:
# edgeR包主要是用于利用来自不同技术平台的read数（包括RNA-seq，SAGE或者ChIP-seq等）来鉴别差异表达或者差异标记（ChIP-seq）。
# 主要是利用了多组实验的精确统计模型或者适用于多因素复杂实验的广义线性模型。
# 所以有时作者也把前者叫做“经典edgeR”， 后者叫做”广义线性模型 edgeR“。
library(edgeR)

outdir <- "/Volumes/GoogleDrive/My Drive/Corolla_tube/RNAseq/SAM_mRNA_sequencing/5_Differential_expression/"
setwd(outdir)

g <- read.table("sample_info.txt", header = TRUE, sep = "\t")
c <- read.csv("../4_Batch_effects/ComBat_seq_batch_group_adjusted_counts.csv", header = TRUE, row.names = "X")

d <- DGEList(counts=c,group=g$Group)

# First get rid of genes which did not occur frequently enough. 
# We can choose this cutoff by saying we must have at least 100 counts per million (calculated with cpm() in R) on any particular gene that we want to keep. 
# head(cpm(d))
# 
# apply(d$counts, 2, sum) # total gene counts per sample
# 
# keep <- rowSums(cpm(d)>1) >= 2 # keep a gene if it has a cpm >1 for at least two samples
# d <- d[keep,]
# dim(d)

# another way to filter lowly expressed genes
keep <- filterByExpr(d)
d <- d[keep,,keep.lib.sizes=FALSE]        
dim(d)

# This reduces the dataset from 32253 tags to 2843. 
# For the filtered genes, there is very little power to detect differential expression, so little information is lost by filtering. 
# After filtering, it is a good idea to reset the library sizes:
d$samples$lib.size <- colSums(d$counts)
d$samples

# Note that the “size factor” from DESeq is not equal to the “norm factor” in the edgeR. 
# In edgeR, the library size and additional normalization scaling factors are separated. 
# See the two different columns in the $samples element of the 'DGEList' object above. 
# In all the downstream code, the lib.size and norm.factors are multiplied together to act as the effective library size; this (product) would be similar to DESeq's size factor.

# Read this short blog entry about normalizing RNA Seq data: http://www.rna-seqblog.com/data-analysis/which-method-should-you-use-for-normalization-of-rna-seq-data/ . 
# edgeR normalizes by total count.

d <- calcNormFactors(d)
d

design <- model.matrix(~ 0 + d$samples$group)
colnames(design) <- levels(d$samples$group)
d <- estimateGLMCommonDisp(d,design)
d <- estimateGLMTrendedDisp(d,design, method="power")
# You can change method to "auto", "bin.spline", "power", "spline", "bin.loess".
# The default is "auto" which chooses "bin.spline" when > 200 tags and "power" otherwise.
d <- estimateGLMTagwiseDisp(d,design)
plotBCV(d)

# To perform quasi-likelihood F-tests
# https://support.bioconductor.org/p/84291/#84292
# fit <- glmQLFit(d,design)
# qlf2vs1 <- glmQLFTest(fit,coef=2) # compare group 2 to 1
# topTags(qlf2vs1)

# To perform likelihood ratio tests
fit <- glmFit(d,design)

lrt2vs1 <- glmLRT(fit,contrast=c(-1,1,0,0,0,0)) # compare group 2 to 1
lrt3vs1 <- glmLRT(fit,contrast=c(-1,0,1,0,0,0))
lrt4vs1 <- glmLRT(fit,contrast=c(-1,0,0,1,0,0))
lrt5vs1 <- glmLRT(fit,contrast=c(-1,0,0,0,1,0))
lrt6vs1 <- glmLRT(fit,contrast=c(-1,0,0,0,0,1))

lrt5vs2 <- glmLRT(fit, contrast=c(0,-1,0,0,1,0)) # comparing group 5 to group 2
lrt5vs4 <- glmLRT(fit, contrast=c(0,0,0,-1,1,0))
lrt6vs4 <- glmLRT(fit, contrast=c(0,0,0,-1,0,1))
lrt6vs5 <- glmLRT(fit, contrast=c(0,0,0,0,-1,1))

de2vs1 <- decideTestsDGE(lrt2vs1, adjust.method="BH", p.value = 0.05)
de3vs1 <- decideTestsDGE(lrt3vs1, adjust.method="BH", p.value = 0.05)
de4vs1 <- decideTestsDGE(lrt4vs1, adjust.method="BH", p.value = 0.05)
de5vs1 <- decideTestsDGE(lrt5vs1, adjust.method="BH", p.value = 0.05)
de6vs1 <- decideTestsDGE(lrt6vs1, adjust.method="BH", p.value = 0.05)

de5vs2 <- decideTestsDGE(lrt5vs2, adjust.method="BH", p.value = 0.05)
de5vs4 <- decideTestsDGE(lrt5vs4, adjust.method="BH", p.value = 0.05)
de6vs4 <- decideTestsDGE(lrt6vs4, adjust.method="BH", p.value = 0.05)
de6vs5 <- decideTestsDGE(lrt6vs5, adjust.method="BH", p.value = 0.05)

summary(de2vs1)
summary(de3vs1)
summary(de4vs1)
summary(de5vs1)
summary(de6vs1)

summary(de5vs2)
summary(de5vs4)
summary(de6vs4)
summary(de6vs5)

write.csv(topTags(lrt2vs1, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT2vs1.csv', quote = FALSE)
write.csv(topTags(lrt3vs1, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT3vs1.csv', quote = FALSE)
write.csv(topTags(lrt4vs1, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT4vs1.csv', quote = FALSE)
write.csv(topTags(lrt5vs1, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT5vs1.csv', quote = FALSE)
write.csv(topTags(lrt6vs1, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT6vs1.csv', quote = FALSE)

write.csv(topTags(lrt5vs2, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT5vs2.csv', quote = FALSE)
write.csv(topTags(lrt5vs4, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT5vs4.csv', quote = FALSE)
write.csv(topTags(lrt6vs4, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT6vs4.csv', quote = FALSE)
write.csv(topTags(lrt6vs5, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT6vs5.csv', quote = FALSE)

de_tags2vs1 <- rownames(d)[as.logical(de2vs1)]
plotSmear(lrt2vs1, de.tags=de_tags2vs1)
abline(h = c(-2, 2), col = "blue")

de_tags3vs1 <- rownames(d)[as.logical(de3vs1)]
plotSmear(lrt3vs1, de.tags=de_tags3vs1)
abline(h = c(-2, 2), col = "blue")

de_tags4vs1 <- rownames(d)[as.logical(de4vs1)]
plotSmear(lrt4vs1, de.tags=de_tags4vs1)
abline(h = c(-2, 2), col = "blue")

de_tags5vs1 <- rownames(d)[as.logical(de5vs1)]
plotSmear(lrt5vs1, de.tags=de_tags5vs1)
abline(h = c(-2, 2), col = "blue")

de_tags6vs1 <- rownames(d)[as.logical(de6vs1)]
plotSmear(lrt6vs1, de.tags=de_tags6vs1)
abline(h = c(-2, 2), col = "blue")

# compare by different grouping
d <- DGEList(counts=c,group=g$Category1)
keep <- filterByExpr(d)
d <- d[keep,,keep.lib.sizes=FALSE]        
d$samples$lib.size <- colSums(d$counts)
d <- calcNormFactors(d)

design <- model.matrix(~ 0 + d$samples$group)
colnames(design) <- levels(d$samples$group)
d <- estimateGLMCommonDisp(d,design)
d <- estimateGLMTrendedDisp(d,design, method="auto")
d <- estimateGLMTagwiseDisp(d,design)
plotBCV(d)
fit <- glmFit(d,design)

lrt2vs1 <- glmLRT(fit,contrast=c(-1,1)) # compare group 2 to 1
de2vs1 <- decideTestsDGE(lrt2vs1, adjust.method="BH", p.value = 0.05)
summary(de2vs1)

write.csv(topTags(lrt2vs1, n = nrow(d$counts), sort.by = "PValue", p.value = 0.05), 'glmLRT2vs1_cat1.csv', quote = FALSE)

de_tags2vs1 <- rownames(d)[as.logical(de2vs1)]
plotSmear(lrt2vs1, de.tags=de_tags2vs1)
abline(h = c(-2, 2), col = "blue")

