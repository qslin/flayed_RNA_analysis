#!/bin/bash
#SBATCH --job-name=index
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

module load bowtie

#mkdir ../../results/sRNA_reads_mapping
cd ../../results/sRNA_reads_mapping

bowtie-build -f ~/resource/LF10/LF10g_v2.0.fa genome
bowtie-build -f ~/resource/LF10/LF10g_v2.0_organelle.fa organelle
bowtie-build -f ~/resource/LF10/Ml_all_repeats_20191010_rDNA.fa rDNA


