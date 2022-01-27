#!/bin/bash
#SBATCH --job-name=align
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-14
#SBATCH --partition=xeon
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load hisat2
module load samtools

#mkdir ../../results/pri-miR169/
cd ../../results/pri-miR169
 
fq1=(../../results/mRNA_trimming/*_R1_paired.fq.gz)
fq2=(../../results/mRNA_trimming/*_R2_paired.fq.gz)

prefix=`echo ${fq1[$SLURM_ARRAY_TASK_ID]}|perl -lane '$_=~s/.+\/trimmed_(.*?)_R.*//;print $1'`

for seq in LF10T_v1.2_contig_27451 LF10T_v1.2_contig_32469 pri-miR169_chr4 pri-miR169_chr6 pri-miR169_chr7 pri-miR169_chr8
do
	hisat2 -x $seq \
	 -1 ${fq1[$SLURM_ARRAY_TASK_ID]} -2 ${fq2[$SLURM_ARRAY_TASK_ID]} \
	 -S $prefix.$seq.sam \
	 --quiet \
	 --no-unal \
	 --threads 4
done

