Parameterise by output loaction (here) and number of threads (p)

conda activate ncbi-genome_download
# -p will depend on threads available
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -p 50 -r 3 -m bacteria_references.tsv bacteria
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -p 50 -r 3 -m viruses_references.tsv viruses
//human
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -p 50 -r 3 -m ref_table bacteria
//mouse
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -p 50 -r 3 -m ref_table bacteria
//fix reference names with non-standard characters e.g. (,)
cat *.tsv > references_table.tsv
//create a reffind script
