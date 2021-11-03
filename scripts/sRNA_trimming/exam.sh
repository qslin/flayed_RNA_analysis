file=(*trimmed)
for i in "${file[@]}"
do
	java -cp ../sRNAminer.jar biocjava.sRNA.Tools.sRNAseqReadLenStat --inFx $i
done

