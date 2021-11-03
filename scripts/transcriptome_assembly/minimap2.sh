#!/bin/bash
#SBATCH --job-name=minimap2
#SBATCH -c 1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=20G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

module load minimap2

minimap2 ~/Mimulus_Genomes/results/annotation/LF10/LF10g_v2.0.longest_isoform.codingseq.fa centroids.fasta > centroids2cds.paf


target=~/resource/LF10/LF10g_v2.0.fa
query=centroids.fasta
out=centroids2genome.paf

minimap2 -x splice -uf $target $query > $out
