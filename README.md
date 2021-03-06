# flayed mutant RNA analysis

This document records the RNA-seq and sRNA-seq data analysis processes performed by Qiaoshan Lin.

### Part I. mRNA processing

<details>
<summary>1. mRNA reads trimming</summary>

First, save adapters to trim in adapter.fa

> sbatch [scripts/mRNA_trimming/trim.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_trimming/trim.sh)

</details>

<details>
<summary>2. mRNA reads fastQC</summary>

FastQC and multiQC were used to check and visualize the reads quality after trimming.

> sbatch [scripts/mRNA_fastqc/fastQC.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_fastqc/fastQC.sh)

> sbatch [scripts/mRNA_fastqc/multiQC.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_fastqc/multiQC.sh)

</details>

<details>
<summary>3. mRNA reads mapping</summary>

STAR was used to map reads to genome and to count reads on genes. A genome file in fasta format and an gene annotation file in gtf format are required for running the scripts.

> sbatch [scripts/mRNA_reads_mapping/index.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_reads_mapping/index.sh)

> sbatch [scripts/mRNA_reads_mapping/align.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_reads_mapping/align.sh)

To map reads onto any desired sequence, prepare the sequence in fasta format and use hisat2 to perform the mapping. For example, I prepared six pri-miR169 transcripts and mapped reads to them
.

> sbatch [scripts/pri-miR169/index.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/pri-miR169/index.sh)

> sbatch [scripts/pri-miR169/align.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/pri-miR169/align.sh)

</details>

<details>
<summary>4. mRNA reads count normalization</summary>

First, merge all read counts into one file.

```
file=(../2_Count/*ReadsPerGene.out.tab.txt)

for f in ${file[@]}; do prefix=`echo $f | perl -lane '$_=~/.*\/(.*)ReadsPerGene.out.tab.txt/;print $1'`; echo $prefix > $prefix\.txt; cut -f2 $f >> $prefix\.txt; done

echo gene_id > geneID.txt; cut -f1 ../2_Count/LF10-EReadsPerGene.out.tab.txt >> geneID.txt

paste geneID.txt LF10-E.txt LF10_F.txt LF10-G.txt f2-A.txt f2-C.txt f5-A.txt f6-A.txt f6-B.txt f6-C.txt f26-A.txt f26-D.txt F56_A.txt F56_B.txt F56_C.txt f56-A.txt |grep -v 'N_' > raw_count.txt
```

Then normalize counts by edgeR (a sample_info file need to be created before running the codes).

> execute codes in [scripts/mRNA_reads_count_normalization/edgeR.R](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_reads_count_normalization/edgeR.R)

</details>

<details>
<summary>5. batch effects adjustment</summary>

Since the data came from multipul different sequencing batches, batch effects were adjusted. Results were visualized by MDS plots. 

> execute codes in [scripts/mRNA_batch_effects_adjustment/ComBat_seq.R](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_batch_effects_adjustment/ComBat_seq.R)

</details>

<details>
<summary>6. differential expression analysis</summary>

Use edgeR to find differential expressed genes between samples.

> execute codes in [scripts/mRNA_differential_expression/edgeR.R](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_differential_expression/edgeR.R)

Add functional annotations to genes (LF10g_v2.0_functional_annotations_simple.tsv was used by default).

> perl [scripts/mRNA_differential_expression/annotate.pl](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_differential_expression/annotate.pl) XXX.csv 

</details>

<details>
<summary>7. GO/KEGG/KOG enrichment analysis</summary>

Prepare annotations for clusterProfiler (annotations for LF10g_2.0 have been created [here](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_cluster_profiler/)).

> execute codes in [scripts/mRNA_cluster_profiler/clusterProfiler.R](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_cluster_profiler/clusterProfiler.R)

</details>

### Part II. sRNA processing

sRNAminer is a software developed by Xia Rui Lab. Please contact them by QQ group ID: 979930653 if you want to download the software. They may publish this software soon. --2022/01/31

<details>
<summary>1. sRNA reads trimming</summary>

First, predict adapters and remove them by sRNAminer

> sbatch [scripts/sRNA_trimming/trim.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_trimming/trim.sh)

Then, exam the length of trimmed reads

> sbatch [scripts/sRNA_trimming/exam.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_trimming/exam.sh) 

Some sequencing files are paired end sequencing, so the 2.trimmed files need to be reverse-complemented 

> sbatch [scripts/sRNA_trimming/reverse-complement.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_trimming/reverse-complement.sh)

Finally, collapse the same reads and count number for each 

> sbatch [scripts/sRNA_trimming/collapse.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_trimming/collapse.sh)

</details>

<details>
<summary>2. sRNA reads mapping</summary>

First, make an index

> sbatch [scripts/sRNA_reads_mapping/index.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_reads_mapping/index.sh)

Then, map trimmed and collapsed sRNA reads to genome

> sbatch [scripts/sRNA_reads_mapping/map.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_reads_mapping/map.sh)

For visualize read mapping in IGV-sRNA, run another bowtie command to produce bam format

> sbatch [scripts/sRNA_reads_mapping/igv.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_reads_mapping/igv.sh)

</details>

<details>
<summary>3. sRNA prediction</summary>

Predict miRNA

> sbatch [scripts/sRNA_prediction/predict_miRNA.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_prediction/predict_miRNA.sh)

Download mature.fa.gz from miRNA database and annotate miRNA

> sh [scripts/sRNA_prediction/filter_miRNA.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_prediction/filter_miRNA.sh)

Predict phasiRNA

> sbatch [scripts/sRNA_prediction/predict_phasiRNA.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_prediction/predict_phasiRNA.sh)

Merge phasiRNA prediction results

> sh [scripts/sRNA_prediction/merge_phasiRNA.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_prediction/merge_phasiRNA.sh)

Another tool to predict miRNA is miRDP2. Here are reference scripts for it. But I didn't use them.

> [scripts/sRNA_prediction/miRDP2_index.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_prediction/miRDP2_index.sh)

> [scripts/sRNA_prediction/miRDP2_prepare.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_prediction/miRDP2_prepare.sh)

> [scripts/sRNA_prediction/miRDP2_predict.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_prediction/miRDP2_predict.sh)

</details>

<details>
<summary>4. sRNA quantification</summary>

> sh [scripts/sRNA_quantification/quantify.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/sRNA_quantification/quantify.sh)

</details>

