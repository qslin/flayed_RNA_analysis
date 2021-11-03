#!/bin/bash
#SBATCH --job-name=prepare
#SBATCH -c 8
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-6
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=100G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load mirdeep2/2.0.0.8

out=(f2-A f5-A f6-A f26-A f56-A f68-A LF10-E)

mapper.pl ../../mapping/bowtie/${out[$SLURM_ARRAY_TASK_ID]}.fa -c -i -j -m -l 18 -n -o 8 -s ${out[$SLURM_ARRAY_TASK_ID]}.collapse.fa

