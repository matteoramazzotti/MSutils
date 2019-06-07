#!/usr/in/perl
$out = shift @ARGV; #ARGV[0] = base name for the output files (e.g. "output" will drive output.txt and output.pdf
$db = shift @ARGV; #$ARGV[1] = fasta file containig the proteins of interest
#next @ARGV, 1 or more protein reports form PeptideShaker
open(IN,$db); 
while($line = <IN>) { #loads fasta sequences
	$line =~ s/[\n\r]//g;
	if ($line =~ />.+?\|(.+?)\|/) { #this line must be adapted to catch an unique portion of the protein ID that will be matched below (see line 34)
		$name = $1;
		push(@names,$name); #brief
		$longname{$name} = $name; #extended (all line)
	} else {
		$seq{$name} .= $line; #indexed by extracted name
	}
}
close IN;
print STDERR scalar keys %seq, " sequences loaded.\n";

#one or more protein report files from PeptiderShaker
#in the current setup, column headers are
#Index+Protein(s)+Description(s)+#Validated Protein Group(s)+Sequence+#Validated PSMs+#PSMs
#e.g. 
#1+A0A1D5ZTU9; A0A1D5ZTV0; H9AXB3;+A0A1D5ZTU9_WHEAT Serpin-N3.2; A0A1D5ZTV0_WHEAT Serpin-N3.2; H9AXB3_WHEAT Serpin-N3.2+1+ISSNPESTVNNAAFSPVS+1+1	

@prots = ();
foreach $file (@ARGV) {
	open(IN,$file) or die "no $file";
	$cnt = 0;
	while($line = <IN>) {
		$cnt++;
		next if ($cnt == 1);
		$line =~ s/[\n\r]//g; #remove blank lines
		$line =~ s/ //g; #and white spaces
		@tmp = split (/\t/,$line); #split_by_tab
		push(@prots,split(/;/,$tmp[1])); #retain protein IDs only (see line 8)
		foreach $p (@prots) {
			next if (!$seq{$p}); #not interesting proteins IDs (see line 8) are ignored 
			push(@{$pep{$p}},$tmp[4]); #peptides matching accepted proteins are recorded 
		}
		print STDERR "From $file $cnt\r";
	}
	print STDERR "\n";
	close IN;
}
print STDERR "Covering ",scalar @names, " proteins\n";
foreach $protein (@names) {
	foreach $peptide (@{$pep{$protein}}) {
		if ($seq{$protein} =~ /$peptide/) { #the peptide is contained in the protein
			$en = $+[0]; #match begin
			$st = $-[0]; #match end
#			print "   $peptide $st:$en\n";
			foreach $pos (1..length($seq{$protein})) {
				$cnt{$pos."@".$protein}++ if ($pos>=$st && $pos<=$en); #protein coverage grow by 1 in all matching positions (hint: possible use of #PSM here...)
			}
#			<STDIN>;
		}
	}
}
$max = 0;
foreach $protein (@names) {
	open(OUT,">XPP.$protein.cov"); #fore each protein the coverage at all positions is stored 
	foreach $pos (1..length($seq{$protein})) {
		$max = $cnt{$pos."@".$protein} if ($cnt{$pos."@".$protein} > $max);
		print OUT $pos,"\t",$cnt{$pos."@".$protein},"\n" if ($cnt{$pos."@".$protein});
		print OUT $pos,"\t0\n" if (!$cnt{$pos."@".$protein});
	}
	close OUT;
}

#a R scrirpt is written to a file so that, upon its launch, R will draw the appropriate coverage plots)
open(R,">plot.R");
$pcnt = 0;
foreach $protein (@names) {
	$pcnt++;
	print R "d<-read.table(\"XPP.$protein.cov\",sep=\"\t\")\n";
	print R "png(\"$out.png\",width=400,height=400)\n" if ($pcnt == 1);
	print R "plot(d[,1]/d[,1][dim(d)[1]],d[,2],type=\"l\",main=\"$out\",xlab=\"Position\",ylab=\"Coverage\",ylim=c(0,$max))\n" if ($pcnt == 1);
	print R "lines(d[,1]/d[,1][dim(d)[1]],d[,2])\n" if ($pcnt > 1);
}
print R "dev.off()\n";
close R;

print STDERR "Plotting\n";
#R is run in slave vanilla mode
`R --slave --vanilla < plot.R`;
#at the end the text used to build the plots is deleted.
#`rm *.cov`;
