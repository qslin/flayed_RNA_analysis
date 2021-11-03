#!/bin/bash
#SBATCH --job-name=cutadapt
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-4
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=20G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load cutadapt/2.7 

file1=(~/raw_data/flayed_mutants_sRNA/1.rawdata/*a/*_1.fq.gz)
file2=(~/raw_data/flayed_mutants_sRNA/1.rawdata/*a/*_2.fq.gz)
name=`echo ${file1[$SLURM_ARRAY_TASK_ID]} | perl -lane '{$_=~s/.+\/1.rawdata\/.+a\///;$_=~s/_.+\.fq.gz$//;print}'`

cutadapt -a AGATCGGAAGAGCACACGTCT -g GTTCAGAGTTCTACAGTCCGACGATC -O 15 -q 10,5 --minimum-length 19 --maximum-length 30 --discard-untrimmed --max-n 0.1 -j 0 -o $name.1.fastq.gz ${file1[$SLURM_ARRAY_TASK_ID]}

cutadapt -g AGACGTGTGCTCTTCCGATCT -a GATCGTCGGACTGTAGAACTCTGAAC -O 15 -q 10,5 --minimum-length 19 --maximum-length 30 --discard-untrimmed --max-n 0.1 -j 0 -o $name.2.fastq.gz ${file2[$SLURM_ARRAY_TASK_ID]}

cutadapt -b "A{15}" -b "T{15}" -b "G{15}" -b "C{15}" --discard-trimmed -j 0 -o $name.1.fq.gz $name.1.fastq.gz
cutadapt -b "A{15}" -b "T{15}" -b "G{15}" -b "C{15}" --discard-trimmed -j 0 -o $name.2.fq.gz $name.2.fastq.gz

#rm *fastq.gz

