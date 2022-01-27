#!/bin/bash
#SBATCH --job-name=STAR
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-14
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o align_%A_%a.out
#SBATCH -e align_%A_%a.err

module load STAR
module load samtools

cd ../../results/mRNA_reads_mapping/

fq1=(../mRNA_trimming/*_R1_paired.fq.gz)
fq2=(../mRNA_trimming/*_R2_paired.fq.gz)

prefix=`echo ${fq1[$SLURM_ARRAY_TASK_ID]}|perl -lane '$_=~s/.+\/trimmed_(.*?)_R.*//;print $1'`

STAR --runThreadN 4 \
 --genomeDir genome \
 --readFilesIn ${fq1[$SLURM_ARRAY_TASK_ID]} ${fq2[$SLURM_ARRAY_TASK_ID]} \
 --readFilesCommand gunzip -c \
 --outFileNamePrefix $prefix \
 --outSAMtype BAM SortedByCoordinate \
 --quantMode TranscriptomeSAM GeneCounts

samtools index $prefix\Aligned.sortedByCoord.out.bam 

# file=(*ReadsPerGene.out.tab)
# for f in ${file[@]}; do cut -f1-2 $f > $f\.txt; done


