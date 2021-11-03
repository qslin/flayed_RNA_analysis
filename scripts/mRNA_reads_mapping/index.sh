#!/bin/bash
#SBATCH --job-name=index
#SBATCH -c 8
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=20G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o index_%j.out
#SBATCH -e index_%j.err

module load STAR

mkdir genome
STAR --runThreadN 8 --runMode genomeGenerate --genomeDir genome --genomeFastaFiles /home/CAM/qlin/resource/LF10/LF10g_v2.0.fa --sjdbGTFfile /home/CAM/qlin/resource/LF10/LF10g_v2.0.gtf --genomeSAindexNbases 13



