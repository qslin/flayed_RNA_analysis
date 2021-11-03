#!/bin/bash
#SBATCH --job-name=refine
#SBATCH -c 16
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=100G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

date

for i in trinity_*.Trinity.fasta
do
	prefix=`echo $i|perl -lane '$_=~s/^trinity_(.+)\..+$//;print $1'`
	sed "s/>/>${prefix}_/g" $i > trinity_prefix_${prefix}.Trinity.fasta
done

cat trinity_prefix_* > trinity_combine.fasta
rm trinity_prefix_* 

module load hmmer/3.2.1
module load TransDecoder/5.3.0

TransDecoder.LongOrfs -t trinity_combine.fasta

hmmscan --cpu 16 \
       --domtblout pfam.domtblout \
       /isg/shared/databases/Pfam/Pfam-A.hmm \
       trinity_combine.fasta.transdecoder_dir/longest_orfs.pep 

TransDecoder.Predict -t trinity_combine.fasta \
	--retain_pfam_hits pfam.domtblout \
	--cpu 16 

module load vsearch/2.4.3

vsearch --threads 16 --log LOGFile \
	--cluster_fast trinity_combine.fasta.transdecoder.cds \
	--id 0.90 \
	--centroids centroids.fasta \
	--uc clusters.uc

date 

