#####################
#                   #
#  clusterProfiler  #
#                   #
#####################
################
# prepare data #
################

#BiocManager::install("clusterProfiler")
library(clusterProfiler)

plots <- function(enrich_data, name, size) {
  #  barplot(enrich_data, showCategory=size)
  png(paste0(deparse(substitute(enrich_data)),"_",name,"_dotplot.png"), width = 4+size, height = 1+size, units = "in", res = 300)
  image <- dotplot(enrich_data, showCategory = size)
  print(image)
  dev.off()
  ## categorySize can be scaled by 'pvalue' or 'geneNum'
  #  cnetplot(enrich_data, categorySize="pvalue")
  #  emapplot(enrich_data)
}

outdir <- "/Volumes/GoogleDrive/My Drive/Corolla_tube/RNAseq/SAM_mRNA_sequencing/6_ClusterProfiler/"
setwd(outdir)

go <- read.table("LF10g_v2.0.GO.txt",sep="\t",quote="")
kegg <- read.table("LF10g_v2.0.KO.txt",sep="\t",quote="")
kog <- read.table("LF10g_v2.0.KOG.txt",sep="\t",quote = "")

go_term2gene <- data.frame(go$V2,go$V1)
go_term2name <- data.frame(go$V2,go$V3)
names(go_term2gene) <- c("go_term","gene")
names(go_term2name) <- c("go_term","name")

kegg_term2gene <- data.frame(kegg$V2,kegg$V1)
# kegg_term2name <- data.frame(kegg$V3,kegg$V2)
names(kegg_term2gene) <- c("ko_term","gene")
# names(kegg_term2name) <- c("ko_term","name")

kog_term2gene <- data.frame(kog$V2,kog$V1)
names(kog_term2gene) <- c("kog_term","gene")

geneBg <- as.vector(go$V1)

indir <- "/Volumes/GoogleDrive/My Drive/Corolla_tube/RNAseq/SAM_mRNA_sequencing/5_Differential_expression/"
glmLRTfiles <- grep("glmLRT.*.csv",list.files(indir),value=TRUE)
names <- sub("glmLRT(.*).csv","\\1",glmLRTfiles)

for(n in seq(length(names))){
  pair <- read.csv(paste0("../5_Differential_expression/", glmLRTfiles[n]), header = TRUE, row.names = "X")
  pair <- pair[abs(pair$logFC)>=1,]
  pair <- pair[abs(pair$logCPM)>=1,]
  geneList <- as.vector(rownames(pair))
  
  #################
  # GO enrichment #
  #################
  go_enrich <- enricher(gene=geneList,pvalueCutoff = 0.05,pAdjustMethod = "BH",TERM2GENE = go_term2gene, TERM2NAME = go_term2name)
  write.table(as.data.frame(go_enrich),paste0("go_enrich_",names[n],".txt"),row.names = F,sep = "\t")
  size <- nrow(as.data.frame(go_enrich))
  if(size>0) {
    plots(go_enrich,names[n],size)
  }
  
  ###################
  # KEGG enrichment #
  ###################
  kegg_enrich <- enricher(gene=geneList,pvalueCutoff = 0.05,pAdjustMethod = "BH",TERM2GENE = kegg_term2gene)
  write.table(as.data.frame(kegg_enrich),paste0("kegg_enrich_",names[n],".txt"),row.names = F,sep = "\t")
  size <- nrow(as.data.frame(kegg_enrich))
  if(size>0) {
    plots(kegg_enrich,names[n],size)
  }

  ###################
  # KOG enrichment #
  ###################
  kog_enrich <- enricher(gene=geneList,pvalueCutoff = 0.05,pAdjustMethod = "BH",TERM2GENE = kog_term2gene)
  write.table(as.data.frame(kog_enrich),paste0("kog_enrich_",names[n],".txt"),row.names = F,sep = "\t")
  size <- nrow(as.data.frame(kog_enrich))
  if(size>0) {
    plots(kog_enrich,names[n],size)
  }
  
}

