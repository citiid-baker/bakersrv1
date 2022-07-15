#!/bin/bash

set -eu

# Script to download high quality reference genomes from refseq and store centrally

source $MINICONDA/etc/profile.d/conda.sh

# Parameterise by output loaction and number of threads

LOCATION=$1 # Assumes location exists and is writeable by user software 
THREADS=$2

cd $LOCATION

# Activate conda environment with ncbi-genome downlaodera
conda activate ncbi-genome-download-0.3.1

# Download all viral genomes
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o $LOCATION -H -P -p $THREADS -r 3 -m ${LOCATION}/viral_references.tsv viruses

# Download a limited set of bacterial genomes
# What to do about "Enterobacteriaceae" as this is a family not Genus
bacterial_genomes=("Acinetobacter" "Aliivibrio" "Bacteroides" "Bordetella" "Burkholderia" "Campylobacter" "Chlamydia" "Citrobacter" "Clostridium" "[Clostridium]" "Clostridioides" "Corynebacterium" "Coxiella" "Elizabethkingia" "[Enterobacter]" "Enterobacter" "Enterococcus" "Escherichia" "Haemophilus" "Helicobacter" "Klebsiella" "Legionella" "Leptospira" "Moraxella" "Morganella" "Mycobacterium" "Neisseria" "Proteus" "Pseudomonas" "Salmonella" "Serratia" "Shigella" "Staphylococcus" "Stenotrophomonas" "Streptococcus" "Vibrio")
for i in "${bacterial_genomes[@]}"
do
   : 
   # do whatever on "$i" here
   print $i
   ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o $LOCATION -H -P -p $THREADS -r 3 -m ${LOCATION}/${i}_references.tsv -g $i -N bacteria
done

# Download a limited set of fungal genomes
fungal_genomes=("Aspergillus" "Candida" "[Candida]" "Pneumocystis")
for j in "${funga_genomes[@]}"
do
   : 
   # do whatever on "$j" here
   print $j
   ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o $LOCATION -H -P -p $THREADS -r 3 -m ${LOCATION}/${j}_references.tsv -g $j -N fungi
done

# Download a limited set of eukaryote genomes
euk_genomes=("Homo sapiens" "Mus musculus")
for k in "${euk_genomes[@]}"
do
   : 
   # do whatever on "$k" here
   print $k
   ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o ${LOCATION} -H -P -p $THREADS -r 3 -m ${LOCATION}/${k}_references.tsv -g $k -N vertebrate_mammalian
done

# Fix reference names with non-standard characters e.g. (),+
# TODO?

# Join all the tables into one table
cat ${LOCATION}/*.tsv > ${LOCATION}/references.tsv

# Create a reffind script
cat > reffind.sh <<-EOF
#!/bin/bash
#
# Author: Jacqui Keane <drjkeane at gmail.com>
#
# Usage: reffind.sh [-h] -s search_term
#

set -eu

function help
{
   # Display Help
   script=$(basename $0)
   echo 
   echo "usage: "$script" [-h] -s search_term
   echo
   echo "Searches for the location of reference genome files that match the supplied search term"
   echo
   echo "optional arguments:"
   echo "  -h, --help          	show this help message and exit"
   echo
   echo "required arguments:"
   echo "-s search_term reference genome files that match the supplied search term"
   echo
}

# Check number of input parameters 

NAG=$#

if [ $NAG -ne 1 ] && [ $NAG -ne 2]
then
  help
  echo "Please provide the correct number of input arguments"
  echo
  exit;
fi

# Get the options
while getopts "hs:" option; do
   case $option in
      h) # Display help
         help
         exit;;
      i) # Search term
         TERM=$OPTARGS;;
     \?) # Invalid option
         help
         echo "Error: Invalid arguments"
         exit;;
   esac
done

grep $TERM references.tsv | awk -F"\t" 'BEGIN {print "\"Species\",\"Reference File\""} {print $10" "$11","$23}'

EOF

mv reffind.sh /home/software/bin
chmod 775 /home/software/bin/reffind.sh

echo "Now set "${LOCATION} "back to be owned by root?"

conda deactivate
