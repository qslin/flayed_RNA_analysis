#!/bin/bash
#SBATCH --job-name=igv
#SBATCH -c 8
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-16
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=20G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load bowtie
module load samtools

file=(*.mc.fa)

name=`echo ${file[$SLURM_ARRAY_TASK_ID]} | perl -lane '{$_=~s/\.mc\.fa$//;print}'`

for i in ${file[$SLURM_ARRAY_TASK_ID]}
do 
	bowtie -f -p 8 -v 1 -m 20 -S -a --best --strata genome $i|samtools view -Sb -F4 -@ 8 -|samtools sort -@ 8 - > $name\.sorted.bam
	samtools index $name\.sorted.bam
done


