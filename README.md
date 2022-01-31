# flayed mutant RNA analysis

This document records the RNA-seq and sRNA-seq data analysis processes performed by Qiaoshan Lin.

### Part I. mRNA processing

<details>
<summary>1. mRNA reads trimming</summary>

First, save adapters to trim in adapter.fa

> sbatch [scripts/mRNA_trimming/trim.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_trimming/trim.sh)

</details>

<details>
<summary>2. RNA-seq reads fastQC</summary>

FastQC and multiQC were used to check and visualize the reads quality after trimming.

> sbatch [scripts/mRNA_fastqc/fastQC.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_fastqc/fastQC.sh)

> sbatch [scripts/mRNA_fastqc/multiQC.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_fastqc/multiQC.sh)

</details>

<details>
<summary>3. RNA-seq reads mapping</summary>

STAR was used to map reads to genome and to count reads on genes. A genome file in fasta format and an gene annotation file in gtf format are required for running the scripts.

> sbatch [scripts/mRNA_reads_mapping/index.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_reads_mapping/index.sh)

> sbatch [scripts/mRNA_reads_mapping/align.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_reads_mapping/align.sh)

To map reads onto any desired sequence, prepare the sequence in fasta format and use hisat2 to perform the mapping. For example, I prepared six pri-miR169 transcripts and mapped reads to them
.

> sbatch [scripts/pri-miR169/index.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/pri-miR169/index.sh)

> sbatch [scripts/pri-miR169/align.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/pri-miR169/align.sh)

</details>

<details>
<summary>3. Assemble transcriptome</summary>

Since I need to predict sRNA target sites that might be located on UTRs of genes, transcriptome was re-assembled even though CDS sequences were known. 

> sbatch [scripts/transcriptome_assembly/trinity.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/transcriptome_assembly/trinity.sh)

> sbatch [scripts/transcriptome_assembly/refine.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/transcriptome_assembly/refine.sh)

At this point, a rough CDS file was generated. However, I need transcripts instead of CDS. So another vsearch was done for all transcripts regardless of protein-coding ability.

> sbatch [scripts/transcriptome_assembly/cluster.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/transcriptome_assembly/cluster.sh)

Evaluate the transcriptome quality. 

> sbatch [scripts/transcriptome_assembly/evaluate.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/transcriptome_assembly/evaluate.sh)

Map transcripts to annotated genes. 

> sbatch [scripts/transcriptome_assembly/minimap2.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/transcriptome_assembly/minimap2.sh)

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


