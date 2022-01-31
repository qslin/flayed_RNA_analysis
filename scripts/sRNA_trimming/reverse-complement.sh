#!/bin/bash
#SBATCH --job-name=trim
#SBATCH -c 1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=20G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

module load seqtk
pe1=(../../results/sRNA_trimming/*_1.trimmed)
pe2=(../../results/sRNA_trimming/*_2.trimmed)

for i in "${!pe2[@]}"
do
        seqtk seq -r ${pe2[$i]} >> ${pe1[$i]}
        rm ${pe2[$i]}
done


