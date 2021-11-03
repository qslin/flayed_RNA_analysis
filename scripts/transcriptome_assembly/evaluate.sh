#!/bin/bash
#SBATCH --job-name=evaluate
#SBATCH -c 8
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=50G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

data

module load rnaQUAST/1.5.2
module load GeneMarkS-T/5.1

rnaQUAST.py --transcripts centroids.fasta \
	--gene_mark \
	--threads 8 \
	--output_dir results

date


