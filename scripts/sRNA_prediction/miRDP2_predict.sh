#!/bin/bash
#SBATCH --job-name=miRDP2
#SBATCH -c 8
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -a 0-6
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=100G
#SBATCH --mail-user=qiaoshan.lin@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

module load bowtie/1.1.2
module load ViennaRNA/2.4.17

lib=(f2-A f5-A f6-A f26-A f56-A f68-A LF10-E)
genome=/home/FCAM/qlin/resource/LF10/LF10g_v2.0.fa

bash ./1.1.4/miRDP2-v1.1.4_pipeline.bash -g $genome -x genome -f -i ${lib[$SLURM_ARRAY_TASK_ID]}.collapse.fa -o . -p 8


