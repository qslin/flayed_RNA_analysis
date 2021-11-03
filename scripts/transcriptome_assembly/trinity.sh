#!/bin/bash
#SBATCH --job-name=trinity
#SBATCH -c 36
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0,2,4,6,8,10,12,14,16,18,20,22
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=120G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

hostname
date

module load trinity/2.8.5
module load samtools

fq=(/archive/users/qlin/RNA/flayed_mutants/SAM_mRNA/2.cleandata/*/*gz)

prefix=`echo ${fq[$SLURM_ARRAY_TASK_ID]}|perl -lane '$_=~s/.+\///;$_=~s/_FR.+$//;print'`

Trinity --seqType fq \
	--left ${fq[$SLURM_ARRAY_TASK_ID]} \
	--right ${fq[$SLURM_ARRAY_TASK_ID+1]} \
	--min_contig_length 150 \
	--CPU 36 \
	--max_memory 100G \
	--output trinity_$prefix \
	--full_cleanup 
date 
