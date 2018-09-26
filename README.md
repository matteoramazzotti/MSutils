MSutils is a set of perl utilities tha was written to simplify the analysis of shotgun MS peptide and protein identification performed with SearchGUI and PeptideShaker

<b>PS_pept_collapse.pl</b> detects peptides that are contained in other longer peptides. The PSM count of subpeptides are attributed to the longest peptides and reported. Try it using 

INPUT: data/peptides_short.txt

OUTPUT: data/peptide.collapsed.txt

USAGE: perl PS_pept_collapse.pl data/peptides.txt > data/peptide.collapsed.txt

<b>PS_prot_covplot.pl</b> reads a peptide input file such as data/peptides.txt and a fasta file containing a set of proteins taken from the MS target database (the same using in PeètideSkaker) and created a coveage plot, similar to that obtained in NGS, by stacking peptides (whose contribution is not 1, but the actual PSM count) into the protein sequence and reporting the position specific counts for each protein in the protein set. At the end a number of .cov (coverage) files are also produced (one per protein in the fasta file) and, if R is installed, a coverage plot in png 

INPUT1: coverage

INPUT1: data/protein.fasta

INPUT2: data/peptides.txt

USAGE: perl PS_prot_covplot.pl coverage data/protein.fasta data/peptides.txt

OUTPUT: coverage.png / coverage.cov
