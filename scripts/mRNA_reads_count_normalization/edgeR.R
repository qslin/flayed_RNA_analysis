# This pipeline refers to https://web.stanford.edu/class/bios221/labs/rnaseq/lab_4_rnaseq.html
# Some notes:
# edgeR包主要是用于利用来自不同技术平台的read数（包括RNA-seq，SAGE或者ChIP-seq等）来鉴别差异表达或者差异标记（ChIP-seq）。
# 主要是利用了多组实验的精确统计模型或者适用于多因素复杂实验的广义线性模型。
# 所以有时作者也把前者叫做“经典edgeR”， 后者叫做”广义线性模型 edgeR“。
library(edgeR)

outdir <- "/Volumes/GoogleDrive/My Drive/Corolla_tube/RNAseq/SAM_mRNA_sequencing/3_Normalize/"
setwd(outdir)

g <- read.table("sample_info.txt", header = TRUE, sep = "\t")
c <- read.table("raw_count.txt", header = TRUE, sep = "\t", row.names = "gene_id")

d <- DGEList(counts=c,group=g$Group)
d

dim(d)
d.full <- d # keep the old one in case we mess up

# First get rid of genes which did not occur frequently enough. 
# We can choose this cutoff by saying we must have at least 100 counts per million (calculated with cpm() in R) on any particular gene that we want to keep. 
head(cpm(d))

apply(d$counts, 2, sum) # total gene counts per sample

keep <- rowSums(cpm(d)>1) >= 2 # keep a gene if it has a cpm >1 for at least two samples
d <- d[keep,]
dim(d)

# This reduces the dataset from 32253 tags to 20267 
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

png("raw_count_MDS.png")
plotMDS(d, method="bcv", col=as.numeric(d$samples$group))
# legend("bottomleft", as.character(unique(d$samples$group)), col=1:3, pch=20)
dev.off()

write.csv(cpm(d, normalized.lib.sizes=TRUE), 'normalized_cpm.csv', quote = FALSE)

