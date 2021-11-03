#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -a 0-23
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load fastqc

fq=(/archive/users/qlin/RNA/flayed_mutants/SAM_mRNA/2.cleandata/*/*gz)

fastqc -o . ${fq[$SLURM_ARRAY_TASK_ID]}

