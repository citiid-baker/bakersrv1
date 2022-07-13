Parameterise by output loaction (here) and number of threads (p)

//allow conda activate
mkdir refs
conda activate ncbi-genome-download-0.3.1
# -p will depend on threads available
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -p 50 -r 3 -m bacteria_references.tsv bacteria
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o /home/software/refs -H -P -p 50 -r 3 -m /home/software/viral_references.tsv viruses
//human
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -p 50 -r 3 -m ref_table bacteria
//mouse
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -p 50 -r 3 -m ref_table bacteria
//fix reference names with non-standard characters e.g. (,)
cat refs/*.tsv > references_table.tsv
//create a reffind script



Acinetobacter,Aspergillus,Aliivibrio,Bacteroides,Bordetella,Burkholderia,Candida,Chlamydia,Campylobacter,Citrobacter,Clostridium,[Clostridium],Corynebacterium,Coxiella,Elizabethkingia,[Enterobacter],Enterobacter,Enterobacteriaceae,Enterococcus,Escherichia,Haemophilus,Helicobacter,Klebsiella,Legionella,Leptospira,Moraxella,Morganella,Mycobacterium,Neisseria,Pneumocystis,Proteus,Pseudomonas,Salmonella,Serratia,Shigella,Staphylococcus,Stenotrophomonas,Streptococcus
