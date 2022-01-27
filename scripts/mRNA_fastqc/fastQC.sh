#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -a 0-29
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load fastqc

fq=(../../results/mRNA_trimming/*_paired.fq.gz)

#mkdir ../../results/mRNA_fastqc
fastqc -o ../../results/mRNA_fastqc/ ${fq[$SLURM_ARRAY_TASK_ID]}


