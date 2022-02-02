#!/bin/bash
#SBATCH --job-name=igv
#SBATCH -c 8
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-21
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=20G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load bowtie
module load samtools

cd ../../results/sRNA_reads_mapping/
file=(../sRNA_trimming/*.mc.fa)

name=`echo ${file[$SLURM_ARRAY_TASK_ID]} | perl -lane '{$_=~/.*\/(.*)\.mc\.fa$/;print $1}'`

bowtie -f -p 8 -v 1 -m 20 -S -a --best --strata genome ${file[$SLURM_ARRAY_TASK_ID]}|samtools view -Sb -F4 -@ 8 -|samtools sort -@ 8 - > $name\.sorted.bam
samtools index $name\.sorted.bam



