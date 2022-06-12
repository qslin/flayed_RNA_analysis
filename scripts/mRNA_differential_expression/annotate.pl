#!/usr/bin/perl
#
$anno = $ARGV[1];
$in = $ARGV[0];

if (not defined($in)) {
 	print "-----------------------------------------------\n";
 	print "This script is used for adding gene annotation.\n";
 	print "-----------------------------------------------\n";
 	print "Usage:\n";
 	print "perl ~/scripts/annotate.pl <target_file> [annotation]\n\n";
 	exit;
} 

$anno = "/home/FCAM/qlin/resource/LF10/LF10g_v2.0_ENTAP_annotation/LF10g_v2.0_functional_annotations_simple.tsv";
$anno = $ARGV[1] if defined $ARGV[1];

open ANNO, "$anno";
while (<ANNO>) {
	my @line = split /\t/;
	$line[0] =~ /(ML.{8})\.\d+/;
	$h{$1} .= $line[6];
}
close ANNO;

open IN, "$in";
while (<IN>) {
	chomp;
	my @line = split /,/;
	print $line[0],"\t",$line[1],"\t",$line[4],"\t",$line[5],"\t",$h{$line[0]},"\n";
}
close IN;



