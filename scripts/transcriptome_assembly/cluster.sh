#!/bin/bash
#SBATCH --job-name=cluster
#SBATCH -c 16
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=100G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

date

module load vsearch/2.4.3

vsearch --threads 16 --log LOGFile \
	--cluster_fast trinity_combine.fasta \
	--id 0.90 \
	--centroids centroids.transcripts.fasta 

date 

