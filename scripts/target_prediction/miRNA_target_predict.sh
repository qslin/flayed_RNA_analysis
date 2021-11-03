#!/bin/bash
#SBATCH --job-name=miRNA_target_predict
#SBATCH -c 8
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

perl -F'\t' -lane 'next if $.==1;open(F,">","$F[0].miRNA.fa");print F ">".$F[0]."\n".$F[5];close(F)' ../prediction/merged.miRNA.list.anno.rename.xls

module load fasta

transcript=~/flayed_mRNA_analysis/assemble/centroids.transcripts.fasta

for i in *.miRNA.fa
do
	id=`echo $i | perl -lane '{$_=~s/\.miRNA\.fa$//;print}'`
	java -cp ../sRNAminer.jar biocjava.bioDoer.miRNA.TargetSoPipe --inMIRfa $i --inGenomeFa $transcript --outTable $id\.miRNA.target.txt --isFragment true --searchRevCom true --maxMisM 3 --deleteTmp true --maxThreadNum 8
done


