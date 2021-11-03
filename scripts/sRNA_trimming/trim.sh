file=(/scratch/qlin/flayed/*fq)
for i in "${file[@]}"
do
	prefix=`echo $i|perl -lane '$_=~s/^.+\///;$_=~s/\.fq$//;print'`
	adapter=`java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRNAseqAdapterPrediction --inFq $i | cut -f2`
	java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRNAseqAdaperRemover --inFxFile $i --adapter $adapter --outFaFile $prefix\.trimmed
done

