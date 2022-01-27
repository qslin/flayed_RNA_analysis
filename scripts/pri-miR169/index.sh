#!/bin/bash
#SBATCH --job-name=index
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --partition=xeon
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

module load hisat2

#mkdir ../../results/pri-miR169/
cd ../../results/pri-miR169

for seq in LF10T_v1.2_contig_27451 LF10T_v1.2_contig_32469 pri-miR169_chr4 pri-miR169_chr6 pri-miR169_chr7 pri-miR169_chr8
do
	hisat2-build $seq.fasta $seq 
done


