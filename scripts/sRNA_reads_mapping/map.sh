#!/bin/bash
#SBATCH --job-name=map
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

file=(../trimming/*.mc.fa)

name=`echo ${file[$SLURM_ARRAY_TASK_ID]} | perl -lane '{$_=~s/^.+\///;$_=~s/\.mc\.fa$//;print}'`

bowtie -p 8 -v 0 -f organelle --un $name\.tmp ${file[$SLURM_ARRAY_TASK_ID]} /dev/null 2> $name\.org.log
bowtie -p 8 -v 0 -f rDNA --un $name\.mc.fa $name\.tmp /dev/null 2> $name\.rdna.log
rm $name\.tmp

bowtie -a --best --strata -v 1 -p 8 -f genome $name\.mc.fa $name\.mc.bowtie 2> $name\.mc.bowtie.log

java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRNAseqAlignmentFormater --inFile $name\.mc.bowtie --outFile $name\.mc.bowtie.aln
rm $name\.mc.bowtie

java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRnaAlnIndexBuilder --inAln $name\.mc.bowtie.aln
rm $name\.mc.bowtie.aln

