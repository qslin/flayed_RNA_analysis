#!/bin/bash
#SBATCH --job-name=STAR
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0,2,4,6,8,10,12,14,16,18,20,22
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o align_%A_%a.out
#SBATCH -e align_%A_%a.err

module load STAR
module load samtools

fq=(/archive/users/qlin/RNA/flayed_mutants/SAM_mRNA/2.cleandata/*/*gz)

prefix=`echo ${fq[$SLURM_ARRAY_TASK_ID]}|perl -lane '$_=~s/.+\///;$_=~s/_.+$//;print'`

STAR --runThreadN 4 \
 --genomeDir genome \
 --readFilesIn ${fq[$SLURM_ARRAY_TASK_ID]} ${fq[$SLURM_ARRAY_TASK_ID+1]} \
 --readFilesCommand gunzip -c \
 --outFileNamePrefix $prefix \
 --outSAMtype BAM SortedByCoordinate \
 --quantMode TranscriptomeSAM GeneCounts

samtools index $prefix\Aligned.sortedByCoord.out.bam 

# file=(*ReadsPerGene.out.tab)
# for f in ${file[@]}; do cut -f1-2 $f > $f\.txt; done


