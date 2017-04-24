mkdir -p raw ref seq res
wget -P raw/ 'ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.*.protein.faa.gz'
gunzip -c raw/human.*.protein.faa.gz | seqtk seq -l0 > ref/human.fa
wget -P raw/ 'ftp://ftp.ncbi.nih.gov/refseq/M_musculus/mRNA_Prot/mouse.*.protein.faa.gz'
gunzip -c raw/mouse.*.protein.faa.gz | seqtk seq -l0 > ref/mouse.fa

diamond makedb --in ref/human.fa --db ref/human.fa
for number in `seq -w 01 10`; do
    seqtk seq -s ${number} -f 0.001 ref/mouse.fa > seq/mouse.sample-${number}.fa
    diamond blastp --db ref/human.fa --query seq/mouse.sample-${number}.fa --outfmt tab --out res/mouse.sample-${number}.human-blastp.tsv
done
