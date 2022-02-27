#!/bin/bash
#SBATCH --job-name=trim
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-5,7-15
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=20G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load Trimmomatic/0.36

reads1=(/labs/Yuan/RNA/flayed_mutants/SAM_mRNA/*/*raw*data/*/*_1.fq.gz)
reads2=(/labs/Yuan/RNA/flayed_mutants/SAM_mRNA/*/*raw*data/*/*_2.fq.gz)

prefix=`echo ${reads1[$SLURM_ARRAY_TASK_ID]}|perl -lane '$_=~s/.*\/(.*[A-Z])_.*$//;print $1'`

#mkdir ../../results/mRNA_trimming
cd ../../results/mRNA_trimming

java -jar $Trimmomatic PE \
 -phred33 \
 -threads 4 \
 ${reads1[$SLURM_ARRAY_TASK_ID]} ${reads2[$SLURM_ARRAY_TASK_ID]} \
 trimmed_$prefix\_R1_paired.fq.gz trimmed_$prefix\_R1_unpaired.fq.gz \
 trimmed_$prefix\_R2_paired.fq.gz trimmed_$prefix\_R2_unpaired.fq.gz \
 ILLUMINACLIP:/home/FCAM/qlin/flayed_RNA_analysis/scripts/mRNA_trimming/adapter.fa:2:30:10:2:TRUE \
 LEADING:5 \
 TRAILING:5 \
 SLIDINGWINDOW:4:10 \
 MINLEN:30


