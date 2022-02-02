cd ../../results/sRNA_prediction
ls *.21.PHAS.tab > all.21.PHAS.list
java -cp ../../scripts/sRNAminer.jar biocjava.sRNA.Miner.phasiRNA.PHASMerger --inFileList all.21.PHAS.list --outFile merged.21.PHAS.list.xls

perl -i.bak -lane 'print and next if $.==1;print if $F[5]>1' merged.21.PHAS.list.xls

genome=~/resource/LF10/LF10g_v2.0.fa
java -cp ../../scripts/sRNAminer.jar biocjava.bioIO.FastX.FastaIndex.MakeFastaIndex --inFa $genome --outFa $genome\.TBtools.fa
java -cp ../../scripts/sRNAminer.jar biocjava.sRNA.Miner.phasiRNA.PHASMergedListToGFF --inPhasList merged.21.PHAS.list.xls --outGff3 merged.PHAS21.gff3 --phasLen 21 --inGenome $genome

ls *.24.PHAS.tab > all.24.PHAS.list
java -cp ../../scripts/sRNAminer.jar biocjava.sRNA.Miner.phasiRNA.PHASMerger --inFileList all.24.PHAS.list --outFile merged.24.PHAS.list.xls

perl -i.bak -lane 'print and next if $.==1;print if $F[5]>1' merged.24.PHAS.list.xls

java -cp ../../scripts/sRNAminer.jar biocjava.sRNA.Miner.phasiRNA.PHASMergedListToGFF --inPhasList merged.24.PHAS.list.xls --outGff3 merged.PHAS24.gff3 --phasLen 24 --inGenome $genome

