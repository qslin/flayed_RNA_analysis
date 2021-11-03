#!/bin/bash
#SBATCH --job-name=phasiRNA_target_predict
#SBATCH -c 8
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-44
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=5G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load fasta

file=(*.21.PHAS.fa)

transcript=~/flayed_mRNA_analysis/assemble/centroids.transcripts.fasta

id=`echo ${file[$SLURM_ARRAY_TASK_ID]} | perl -lane '{$_=~s/\.21\.PHAS\.fa$//;print}'`

mkdir $id\.21.PHAS
cd $id\.21.PHAS

split -l 2 --additional-suffix=.fa ../${file[$SLURM_ARRAY_TASK_ID]} 
cp $transcript transcript

for i in *.fa
do
	java -cp ../../sRNAminer.jar biocjava.bioDoer.miRNA.TargetSoPipe --inMIRfa $i --inGenomeFa transcript --outTable $i\.txt --searchRevCom true --maxMisM 3 --deleteTmp true --maxThreadNum 8
done

cat *.txt > ../$id\.21.PHAS.target.txt 

cd ..
rm -r $id\.21.PHAS/

