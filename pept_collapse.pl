#!/usr/bin/perl
#ARGV[0] is a a 4 column PeptideShaker peptide report file containing 
peptide ID, description, sequence and PSM count
open(IN,$ARGV[0]); 
while($line = <IN>) {
	chomp $line;
	next if ($line =~ /Sequence/i);
	($pcode,$pdesc,$pept,$count) = split (/\t/,$line); #
	$cnt{$pept} += $count; #accumulate #PSM for each identified peptide
	$num{$pept}++;
	@tmp1 = split (/; /,$pcode);
	@tmp2 = split (/; /,$pdesc);
	foreach $i (0..$#tmp1) {
		push(@{$desc{$pept}},$tmp1[$i].":".$tmp2[$i]); #peptides form the same protein are joined
	}
}
close IN;
foreach $p (sort {length($b) <=> length($a)} keys %cnt) { #peptides are sorted by length 
	@f = contains($p,keys %cnt); #the list of sub-peptides
	foreach $f (@f) {
		delete $cnt{$f}; #sub peptides are removed form the list of available peptides
	}
	@{$sons{$p}} = @f; #the sub-peptides @f of $p are stored
}
print "Longest_peptide\tTotal_PSM_count\t#Sub_peptides\tSub_peptides\tAnnotation\n";
foreach $p (sort {$cnt2{$b} <=> $cnt2{$a}} keys %cnt2) {
	print $p,"\t",$cnt2{$p},"\t",(scalar @{$sons{$p}}),"\t",join "|",@{$sons{$p}},"\t",join "|",@{$desc{$p}},"\n";
}

sub contains {
	my $who = shift;
	my @list = @_;
	my @found = ();
	foreach my $p (@list) { #the full list of peptides is scanned
		if ($who =~ /$p/) { #perfect match
			$cnt2{$who} += $cnt{$p}; #accumulate #PSM of sub-peptides
			push(@found,$p); #collect sub-peptides
		}
	}
	return(@found); #the list of sub-peptides
}
