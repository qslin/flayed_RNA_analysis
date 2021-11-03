java -cp ../sRNAminer.jar biocjava.sRNA.Miner.miRNA.ExtractKnownPlantMIR --inMirBase mature.fa.gz --outFile ./miRBase20211010
module load blast
makeblastdb -in miRBase20211010 -input_type fasta -dbtype nucl

file=(*.tab)
for i in "${file[@]}"
do
	java -cp ../sRNAminer.jar biocjava.sRNA.Miner.miRNA.DetectKnownMiR --inMiRList $i --miRBaseDB miRBase20211010 --outList $i\.known --matureColIndex 6 --starColIndex 7 --starAbundanceIndex 11
	perl -lane 'print unless $F[-1] eq "Unlikely"' $i\.known > $i\.filter
done

ls *.filter > all.miRNA.list

java -cp ../sRNAminer.jar biocjava.sRNA.Miner.miRNA.MIRmerger --inFileList all.miRNA.list --outFile merged.miRNA.list.xls

# reannotate
java -cp ../sRNAminer.jar biocjava.sRNA.Miner.miRNA.DetectKnownMiR --inMiRList merged.miRNA.list.xls --miRBaseDB miRBase20211010 --outList merged.miRNA.list.anno.xls
# rename miRNA
java -cp ../sRNAminer.jar biocjava.sRNA.Miner.miRNA.MIRnamer --inFile merged.miRNA.list.anno.xls --outFile merged.miRNA.list.anno.rename.xls

perl -F'\t' -lane 'print join qq{\t},$F[1],$F[3],$F[4],$F[0]."-".$F[-1],$F[2],$F[5],$F[6] if $F[-1] ne "Unlikely"' merged.miRNA.list.anno.rename.xls > miRNAinfo.tab

genome=~/resource/LF10/LF10g_v2.0.fa
java -cp ../sRNAminer.jar biocjava.sRNA.Miner.miRNA.MIRinfo2GFF --inGenomeFa $genome --inMIRinfo miRNAinfo.tab --outGff3 miRNA.gff3

