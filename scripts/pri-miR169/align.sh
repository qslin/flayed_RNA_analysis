#!/bin/bash
#SBATCH --job-name=align
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-6
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load hisat2
module load samtools

file=(f26-A_FRAS202409840-1r f2-A_FRAS202409837-1r f56-A_FRAS202409841-1r f5-A_FRAS202409838-1r f68-A_FRAS202409843-1r f6-A_FRAS202409839-1r LF10-E_FRAS202409836-1r)

hisat2 -x LF10T_v1.2_contig_27451 \
 -1 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_1.clean.fq.gz -2 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_2.clean.fq.gz \
 -S ${file[$SLURM_ARRAY_TASK_ID]}.LF10T_v1.2_contig_27451.sam \
 --quiet \
 --no-unal \
 --threads 4

hisat2 -x LF10T_v1.2_contig_32469 \
 -1 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_1.clean.fq.gz -2 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_2.clean.fq.gz \
 -S ${file[$SLURM_ARRAY_TASK_ID]}.LF10T_v1.2_contig_32469.sam \
 --quiet \
 --no-unal \
 --threads 4

hisat2 -x pri-miR169_chr6 \
 -1 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_1.clean.fq.gz -2 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_2.clean.fq.gz \
 -S ${file[$SLURM_ARRAY_TASK_ID]}.pri-miR169_chr6.sam \
 --quiet \
 --no-unal \
 --threads 4

hisat2 -x pri-miR169_chr7 \
 -1 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_1.clean.fq.gz -2 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_2.clean.fq.gz \
 -S ${file[$SLURM_ARRAY_TASK_ID]}.pri-miR169_chr7.sam \
 --quiet \
 --no-unal \
 --threads 4

hisat2 -x pri-miR169_chr8 \
 -1 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_1.clean.fq.gz -2 ../2.cleandata/${file[$SLURM_ARRAY_TASK_ID]}/*_2.clean.fq.gz \
 -S ${file[$SLURM_ARRAY_TASK_ID]}.pri-miR169_chr8.sam \
 --quiet \
 --no-unal \
 --threads 4

