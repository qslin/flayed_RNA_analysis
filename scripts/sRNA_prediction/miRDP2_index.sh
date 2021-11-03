#!/bin/bash
#SBATCH --job-name=index
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=100G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load bowtie/1.1.2

genome=/home/FCAM/qlin/resource/LF10/LF10g_v2.0.fa

bowtie-build -f $genome genome


