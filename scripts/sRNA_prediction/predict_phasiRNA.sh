#!/bin/bash
#SBATCH --job-name=predict_phasiRNA
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

file=(../../results/sRNA_reads_mapping/*.mc.bowtie.aln.sorted)

name=`echo ${file[$SLURM_ARRAY_TASK_ID]}|perl -lane '$_=~/.*\/(.*)\.mc.bowtie.aln.sorted$/;print $1'`

outdir=../../results/sRNA_prediction

java -cp ../sRNAminer.jar biocjava.sRNA.Miner.phasiRNA.PHASMinerCLI --inAln ${file[$SLURM_ARRAY_TASK_ID]} --output $outdir/$name\.21.PHAS.tab --phasLen 21
java -cp ../sRNAminer.jar biocjava.sRNA.Miner.phasiRNA.PHASMinerCLI --inAln ${file[$SLURM_ARRAY_TASK_ID]} --output $outdir/$name\.24.PHAS.tab --phasLen 24



