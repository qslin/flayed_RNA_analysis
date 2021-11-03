#copy all commands and run in the interactive mode
module load samtools
module load blast
module load fasta

genome=~/resource/LF10/LF10g_v2.0.fa
transcript=~/flayed_mRNA_analysis/assemble/centroids.transcripts.fasta
cod=~/resource/LF10/LF10g_v2.0.codingseq.fa

list=../../results/sRNA_prediction/merged.21.PHAS.list.xls

#explore phasiRNA locus that might be homologous to its target gene
perl -F'\t' -lane 'next if $.==1;$F[15]=~s/21\.PHAS\.tab$/sorted\.bam/;print "samtools faidx ~/resource/LF10/LF10g_v2.0.fa ".$F[14].">".$F[0].".21.PHAS.locus.fa"' $list > tmp.sh

sh tmp.sh
rm tmp.sh

for i in *.21.PHAS.locus.fa
do
	id=`echo $i | perl -lane '{$_=~s/\.21\.PHAS\.locus\.fa$//;print}'`
	/isg/shared/apps/blast/ncbi-blast-2.7.1+/bin/blastn -subject $cod -query $i -outfmt "6 qseqid qlen qstart qend sseqid slen sstart send pident mismatch length sstrand">$id\.21.PHAS.blast.txt
done

#extract all 21nt phasiRNA candidates
perl -F'\t' -lane 'next if $.==1;$F[15]=~s/21\.PHAS\.tab$/sorted\.bam/;print "samtools view ../../results/sRNA_reads_mapping/".$F[15]." ".$F[14].">".$F[0].".21.PHAS.sam"' $list > tmp.sh

sh tmp.sh 
rm tmp.sh

for i in *.21.PHAS.sam
do 
	id=`echo $i | perl -lane '{$_=~s/\.21\.PHAS\.sam$//;print}'`
	awk '$6~/21M/{print $10}' $i |sort|uniq|perl -lane '$_=~s/^/>$.\n/;print' > $id\.21.PHAS.fa
done

for i in *.21.PHAS.fa
do
	id=`echo $i | perl -lane '{$_=~s/\.fa$//;print}'`
	perl -slane '$_=~s/^>/>$id\./;print' -- -id=$id $i >> all.21.PHAS.fa
done



