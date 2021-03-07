MSutils is a set of perl utilities tha was written to simplify the analysis of shotgun MS peptide and protein identification performed with SearchGUI and PeptideShaker (http://compomics.github.io/projects/searchgui).

MSUtils have been used to analyze data in the publication: 
"Antioxidant and anti-inflammatory properties of sourdoughs containing selected Lactobacilli strains are retained in breads" 
Luti, Mazzoli,Ramazzotti, [...],Pazzagli
Food Chemistry 322:126710. PMID: 32283363 DOI: 10.1016/j.foodchem.2020.126710

<b>PS_pept_collapse.pl</b> detects peptides that are contained in other longer peptides. The PSM count of subpeptides are attributed to the longest peptides and reported. Try it using: 

INPUT: data/peptides_short.txt<br>
<b>USAGE</b>: perl PS_pept_collapse.pl data/peptides.txt > data/peptide.collapsed.txt<br>
OUTPUT: data/peptide.collapsed.txt<br>

<b>PS_prot_covplot.pl</b> reads a peptide input file such as data/peptides.txt and a fasta file containing a set of proteins taken from the MS target database (the same using in PeptideShaker) and creates a coveage plot, similar to that obtained in NGS, by stacking peptides (whose contribution is not 1, but the actual PSM count) into the protein sequence. It emits a the position specific counts for each protein in the protein set. At the end a number of .cov (coverage) files are also produced (one per protein in the fasta file) and, if R is installed, a coverage plot in png.

INPUT1: coverage<br>
INPUT2: data/protein.fasta<br>
INPUT3: data/peptides.txt<br>
<b>USAGE</b>: perl PS_prot_covplot.pl coverage data/protein.fasta data/peptides.txt<br>
OUTPUT1: coverage.png<br>
OUTPUT2: coverage.cov<br>
