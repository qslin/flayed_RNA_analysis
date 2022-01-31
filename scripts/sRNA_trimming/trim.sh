#!/bin/bash
#SBATCH --job-name=trim
#SBATCH -c 1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-1,3-27
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

raw1=(/labs/Yuan/RNA/flayed_mutants/SAM_sRNA/X101SC20101622-Z03-J001/raw_data/*-*.fq.gz) #single end sequencing
raw2=(/labs/Yuan/RNA/flayed_mutants/SAM_sRNA/X101SC20101622-Z03-J008/1.rawdata/*/*gz) #double end sequencing
raw3=(/labs/Yuan/RNA/flayed_mutants/SAM_sRNA/X101SC20101622-Z03-J008-MORESEQ/raw_data/*gz) #single end sequencing
raw4=(/labs/Yuan/RNA/flayed_mutants/SAM_sRNA/X101SC20101622-Z03-J009/LF10-H_FRRN210145074-1a/*gz) #double end sequencing
raw5=(/labs/Yuan/RNA/flayed_mutants/SAM_sRNA/X202SC21121760-Z01-F001/raw_data/*/*gz) #single end sequencing

file=("${raw1[@]}" "${raw2[@]}" "${raw3[@]}" "${raw4[@]}" "${raw5[@]}")

#mkdir ../../results/sRNA_trimming
 
prefix=`echo ${file[$SLURM_ARRAY_TASK_ID]}|perl -lane '$_=~/.*\/(.*)\.fq\.gz/;print $1'`
adapter=`java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRNAseqAdapterPrediction --inFq ${file[$SLURM_ARRAY_TASK_ID]} | cut -f2`
java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRNAseqAdaperRemover --inFxFile ${file[$SLURM_ARRAY_TASK_ID]} --adapter $adapter --outFaFile ../../results/sRNA_trimming/$prefix\.trimmed


