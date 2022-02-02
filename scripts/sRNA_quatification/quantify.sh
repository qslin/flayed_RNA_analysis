mkdir ../../results/sRNA_quantification
cd ../../results/sRNA_quantification

perl -lane 'next unless $F[2] eq "miRNA";/ID=([^;]+)/;print join qq{\t},$1,@F[0,3,4,6]' ../sRNA_prediction/miRNA.gff3 > miRNA.feature.region

for i in ../sRNA_reads_mapping/*.mc.bowtie.aln.sorted
do
	name=`echo $i|perl -lane '$_=~s/^.+\///;$_=~s/\.mc.bowtie.aln.sorted$//;print'`
	java -cp ../../scripts/sRNAminer.jar biocjava.sRNA.Miner.sRNAQuantify --inAln $i --insRNAregion miRNA.feature.region --outsRNAExp $name\.miRNA.feature.region.exp --flankBase 0
	echo $'\t'$name > $name\.miRNA.feature.region.RPTM
	echo $'\t'$name > $name\.miRNA.feature.region.counts
	cut -f1,6 $name\.miRNA.feature.region.exp >> $name\.miRNA.feature.region.RPTM
	cut -f1,7 $name\.miRNA.feature.region.exp >> $name\.miRNA.feature.region.counts
	java -cp ../../scripts/sRNAminer.jar biocjava.sRNA.Miner.phasiRNAsQuantify --inAln $i --inPHASregion ../sRNA_prediction/merged.21.PHAS.list.xls --outPhasiRNAExp $name\.21.PHAS.exp
	java -cp ../../scripts/sRNAminer.jar biocjava.sRNA.Miner.phasiRNAsQuantify --inAln $i --inPHASregion ../sRNA_prediction/merged.24.PHAS.list.xls --outPhasiRNAExp $name\.24.PHAS.exp
	echo $'\t'$name > $name\.21.PHAS.RPTM
	echo $'\t'$name > $name\.24.PHAS.RPTM
	perl -F'\t' -lane 'print join qq{\t},@F[0,-1]' $name\.21.PHAS.exp >> $name\.21.PHAS.RPTM
        perl -F'\t' -lane 'print join qq{\t},@F[0,-1]' $name\.24.PHAS.exp >> $name\.24.PHAS.RPTM
done

paste *.miRNA.feature.region.RPTM |cut -f1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44 > all.miRNA.RPTM.txt
paste *.miRNA.feature.region.counts |cut -f1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44 > all.miRNA.counts.txt
paste *.21.PHAS.RPTM |cut -f1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44 > all.21.PHAS.RPTM.txt
paste *.24.PHAS.RPTM |cut -f1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44 > all.24.PHAS.RPTM.txt

