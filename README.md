# flayed mutant RNA analysis

This document records the RNA-seq and sRNA-seq data analysis processes performed by Qiaoshan Lin.

### Part I. mRNA processing

<details>
<summary>1. RNA-seq reads fastQC</summary>

Here I used the clean reads provided by the sequencing company so that reads trimming was not necessary. FastQC and multiQC were used to check and visualize the reads quality.

> sbatch [scripts/mRNA_fastqc/fastQC.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_fastqc/fastQC.sh)

> sbatch [scripts/mRNA_fastqc/multiQC.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_fastqc/multiQC.sh)

</details>

<details>
<summary>2. RNA-seq reads mapping</summary>

STAR was used to map reads to genome and to count reads on genes. A genome file in fasta format and an gene annotation file in gtf format are required for running the scripts.

> sbatch [scripts/mRNA_reads_mapping/index.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_reads_mapping/index.sh)

> sbatch [scripts/mRNA_reads_mapping/align.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/mRNA_reads_mapping/align.sh)

To map reads onto any desired sequence, prepare the sequence in fasta format and use hisat2 to perform the mapping. For example, I prepared five pri-miR169 transcripts and mapped reads to them
.

> sbatch [scripts/pri-miR169/align.sh](https://github.com/qslin/flayed_RNA_analysis/blob/master/scripts/pri-miR169/align.sh)

</details>


