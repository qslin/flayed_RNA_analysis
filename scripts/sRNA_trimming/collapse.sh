#!/bin/bash
#SBATCH --job-name=collapse
#SBATCH -c 1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-21
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

file=(../../results/sRNA_trimming/*trimmed)
prefix=`echo ${file[$SLURM_ARRAY_TASK_ID]}|perl -lane '$_=~s/\.trimmed$//;print'`
java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRNAseqCollasper --inFx ${file[$SLURM_ARRAY_TASK_ID]} --outCollaspedFa $prefix\.mc.fa


