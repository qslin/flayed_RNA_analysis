#!/bin/bash
#SBATCH --job-name=predict_miRNA
#SBATCH -c 1
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

module load ViennaRNA/2.4.17

file=(../../results/sRNA_reads_mapping/*.mc.bowtie.aln.sorted)

genome=~/resource/LF10/LF10g_v2.0.fa

name=`echo ${file[$SLURM_ARRAY_TASK_ID]}|perl -lane '$_=~/.*\/(.*)\.mc.bowtie.aln.sorted$/;print $1'`

#mkdir ../../results/sRNA_prediction
cd ../../results/sRNA_prediction

java -cp ../../scripts/sRNAminer.jar biocjava.sRNA.Miner.miRNA.miRNAminerCLI --inAln ${file[$SLURM_ARRAY_TASK_ID]} --outputPrefix $name --inGenome $genome --minMiRLen 20 --maxMiRLen 22


