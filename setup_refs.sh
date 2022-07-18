#!/bin/bash
#
# Author: Jacqui Keane <drjkeane at gmail.com>
#
# Usage: setup_refs.sh [-h] -o out_dir -t threads
#

set -eu

# Script to download high quality reference genomes from refseq and store centrally

function help
{
   # Display Help
   script=$(basename $0)
   echo
   echo "usage: "$script" [-h] -o out_dir -t threads"
   echo
   echo "Downloads high quality reference genomes from refseq and stores then in the specified output directory"
   echo
   echo "optional arguments:"
   echo "-h, --help		show this help message and exit"
   echo
   echo "required arguments:"
   echo "-o out_dir 		location to store the references"
   echo "-t threads 		number of threads"
   echo
}

#Check number of input parameters
NAG=$#
if [ $NAG -ne 1 ] && [ $NAG -ne 4 ]
then
  help
  echo "Please provide the correct number of input arguments"
  echo
  exit;
fi

# Get the options
while getopts "ho:t:" option; do
   case $option in
      h) # display help
         help
         exit;;
      o) # Input file
         LOCATION=$OPTARG;;
      t) # Output directory
         THREADS=$OPTARG;;
     \?) # Invalid option
         help
         echo "!!!Error: Invalid arguments"
         exit;;
   esac
done

source $MINICONDA/etc/profile.d/conda.sh

cd $LOCATION

# Activate conda environment with ncbi-genome downlaodera
conda activate ncbi-genome-download-0.3.1

# Download all viral genomes
echo "Viral genomes"
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o $LOCATION -H -P -p $THREADS -r 3 -m ${LOCATION}/viral_references.tsv viral

# Download a limited set of bacterial genomes
# What to do about "Enterobacteriaceae" as this is a family not Genus
bacterial_genomes=("Acinetobacter" "Aliivibrio" "Bacteroides" "Bordetella" "Burkholderia" "Campylobacter" "Chlamydia" "Citrobacter" "Clostridium" "[Clostridium]" "Clostridioides" "Corynebacterium" "Coxiella" "Elizabethkingia" "[Enterobacter]" "Enterobacter" "Enterococcus" "Escherichia" "Haemophilus" "Helicobacter" "Klebsiella" "Legionella" "Leptospira" "Moraxella" "Morganella" "Mycobacterium" "Neisseria" "Proteus" "Pseudomonas" "Salmonella" "Serratia" "Shigella" "Staphylococcus" "Stenotrophomonas" "Streptococcus" "Vibrio")
for i in "${bacterial_genomes[@]}"
do
   :
   do whatever on "$i" here
   echo $i
   ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o $LOCATION -H -P -p $THREADS -r 3 -m ${LOCATION}/${i}_references.tsv -g $i -N bacteria
done

# Download a limited set of fungal genomes
fungal_genomes=("Aspergillus" "Candida" "[Candida]")
for j in "${fungal_genomes[@]}"
do
   :
   # do whatever on "$j" here
   echo $j
   ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o $LOCATION -H -P -p $THREADS -r 3 -m ${LOCATION}/${j}_references.tsv -g $j -N fungi
done

# Special case for genomes where no complete references exist
fungal_genomes_all=("Pneumocystis")
for f in "${fungal_genomes_all[@]}"
do
   :
   # do whatever on "$f" here
   echo $f
   ncbi-genome-download -s refseq -F fasta,gff -l all -o $LOCATION -H -P -p $THREADS -r 3 -m ${LOCATION}/${f}_references.tsv -g $f -N fungi
done

# Download human and mouse genomes
echo "Homo sapiens and Mus musculus"
ncbi-genome-download -s refseq -F fasta,gff -l complete,chromosome -o ${LOCATION} -H -P -p $THREADS -r 3 -m ${LOCATION}/host_refoerences.tsv -g "Homo sapiens,Mus musculus" -N vertebrate_mammalian

# Fix reference names with non-standard characters e.g. (),+
# TODO?

# Join all the tables into one table
cat ${LOCATION}/*.tsv | sort | uniq > ${LOCATION}/references.tsv

# Put full path to files in references.tsv (escape slashes in location)
sed -i "s/.\/refseq/${LOCATION////\\/}\/refseq/g" ${LOCATION}/references.tsv

# Create a reffind script
FILE="reffind.sh"
cat <<END > $FILE
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
   script=\$(basename \$0)
   echo
   echo "usage: "\$script" [-h] -s search_term"
   echo
   echo "Searches for the location of reference genome files that match the supplied search term"
   echo
   echo "optional arguments:"
   echo "  -h              show this help message and exit"
   echo
   echo "required arguments:"
   echo "-s search_term    reference genome files that match the supplied search term"
   echo
}

#Check number of input parameters
NAG=\$#
if [ \$NAG -ne 1 ] && [ \$NAG -ne 2 ]
then
  help
  echo "Please provide the correct number of input arguments"
  echo
  exit;
fi
# Get the options
while getopts "hs:" option; do
   case \$option in
      h) # Display help
         help
         exit;;
      s) # Search term
         TERM=\$OPTARG;;
     \?) # Invalid option
         help
         echo "Error: Invalid arguments"
         exit;;
   esac
done
grep -i \$TERM ${LOCATION}/references.tsv | awk -F"\t" 'BEGIN {print "\"Species\",\"Reference File\""} {print \$10" "\$11","\$23}'
END

mv reffind.sh /home/software/bin
chmod 775 /home/software/bin/reffind.sh

echo "Now set "${LOCATION} "back to be owned by root and remove world write permissions"

conda deactivate
