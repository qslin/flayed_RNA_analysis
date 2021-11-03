module load ViennaRNA/2.4.17
file=(../mapping/*.mc.bowtie.aln.sorted)
genome=~/resource/LF10/LF10g_v2.0.fa
for i in "${file[@]}"
do
	name=`echo $i|perl -lane '$_=~s/^.+\///;$_=~s/\.mc.bowtie.aln.sorted$//;print'`
	java -cp ../sRNAminer.jar biocjava.sRNA.Miner.miRNA.miRNAminerCLI --inAln $i --outputPrefix $name --inGenome $genome --minMiRLen 20 --maxMiRLen 22
done

