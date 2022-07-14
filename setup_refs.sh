#!/bin/bash

set -eu

# Script to download high quality reference genomes from refseq and store centrally

source $MINICONDA/etc/profile.d/conda.sh

# Parameterise by output loaction (here) and number of threads (p)

LOCATION=$1
THREADS=$2

cd $LOCATION
mkdir refs

conda activate ncbi-genome-download-0.3.1
# Download viral genomes
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o /home/software/refs -H -P -p THREADS -r 3 -m /home/software/viral_references.tsv viruses

# Download a limited set of bacerial genomes
genomes=("Acinetobacte" "Aspergillus" "Aliivibrio" "Bacteroides" "Bordetella" "Burkholderia" " Candida" "Chlamydia" "Campylobacter" "Citrobacter" "Clostridium" "[Clostridium]" "Corynebacterium" "Coxiella" "Elizabethkingia" "[Enterobacter]" "Enterobacte" "Enterobacteriaceae" "Enterococcus" "Escherichia" "Haemophilus" "Helicobacter" "Klebsiella" "Legionella" "Leptospira" "Moraxella" "Morganella" "Mycobacterium" "Neisseria" "Pneumocystis" "Proteus" "Pseudomonas" "Salmonella" "Serratia" "Shigella" "Staphylococcus" "Stenotrophomonas" "Streptococcus")
for i in "${genomes[@]}"
do
   : 
   # do whatever on "$i" here
   print $i
   ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -p $THREADS -r 3 -m $i_references.tsv -g $i
done

for each genome in GENOMES
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -p $THREADS -r 3 -m bacteria_references.tsv bacteria

# Download human genome
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -r 3 -m ref_table bacteria

# Download mouse genome
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o here -H -P -r 3 -m ref_table bacteria

# Fix reference names with non-standard characters e.g. (),

# Join all the tables into one table
cat $LOCATION/refs/*.tsv > $LOCATION/refs/references.tsv

//create a reffind script ?

conda deactivate
