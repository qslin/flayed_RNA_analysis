#!/bin/bash
#SBATCH --job-name=exam
#SBATCH -c 1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-27
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

#since the f56-A raw data was not properly transfered, it might miss some data. So here use clean data instead
#RUN THE FOLLOWING INTERACTIVELY
#gzip -cd /labs/Yuan/RNA/flayed_mutants/SAM_sRNA/X101SC20101622-Z03-J001/clean_data/f56-A_clean.fa.gz > ../../results/sRNA_trimming/f56-A_clean.trimmed
file=(../../results/sRNA_trimming/*trimmed)
java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRNAseqReadLenStat --inFx ${file[$SLURM_ARRAY_TASK_ID]}


