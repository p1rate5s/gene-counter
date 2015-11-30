#!/usr/bin/perl

##############################
## generate gene counts in vcf file
## assume VCF has been annotated with BED file to include gene names in INFO field
##
##################################

if (!@ARGV) {
    die "##Usage: count_genes.pl <vcf file>
## This needs to be run in the directory of the file to load";
}

$maxcount=0;
$patt="";
%genes = ();

open(LOADFILE, "$ARGV[0]") || die "Can't open loadfile: $!\n";
while (<LOADFILE>)
{
	#print $_;
	my($line) = $_;
	$line =~ s/([\t])/\\$1/g;
    if ($line =~ /BED-features\=(\S+);[.|C]/)
      {
		@gene = split /:/, $1;
		foreach $g (@gene){
			if (exists $genes{$g}){
				$genes{$g}++;
			}else{
				$genes{$g}=1;
			}
			if ($genes{$g} > $maxcount){
				$maxcount=$genes{$g};
			}
		}
      }
}
#print "$maxcount\n";

while (($patt, $freq) = each(%genes)){
		print("$patt\t$freq \n");
}

close(LOADFILE);
