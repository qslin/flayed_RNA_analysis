# some sequencing files are paired end sequencing, so the *_2.trimmed files need to be reverse-complemented 

module load seqtk
pe1=(*_1.trimmed)
pe2=(*_2.trimmed)
for i in "${!pe2[@]}"
do
	seqtk seq -r ${pe2[$i]} >> ${pe1[$i]}
	rm ${pe2[$i]}
done

file=(*trimmed)
for i in "${file[@]}"
do
	prefix=`echo $i|perl -lane '$_=~s/\.trimmed$//;print'`
	java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRNAseqCollasper --inFx $i --outCollaspedFa $prefix\.mc.fa
done

