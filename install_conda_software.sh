#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

# Set up variables and add miniconda location to PATH
export MINICONDA="/home/software/miniconda"
export MINICONDA_BIN_LOCATION="$MINICONDA/bin"
export PATH="$MINICONDA_BIN_LOCATION:$PATH"

# Download and install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p $MINICONDA

# Set conda for autoinstalls and update conda
conda config --set always_yes yes --set changeps1 no
conda update -n base -c defaults conda

# Useful for debugging any issues with conda
conda info -a

# Set the conda channels
conda config --add channels defaults
conda config --add channels r
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority true

# Initialise conda
conda init bash

# Install software
echo "Reading bioconda software list!"
while read -r line;
do
    echo "Installing ${line}"
    # Split line on comma into environment and software list
    IFS=',' read -a myarray <<<  $line
    environment=${myarray[0]}
    software=${myarray[1]}
    # Create a new conda environment with the software
    conda create -n $environment $software
done < software.txt

# Fix for prokka 1.14.6
conda activate prokka-1.14.6
conda install -y perl-app-cpanminus
cpanm Bio::SearchIO::hmmer --force

echo "!!! Don't forget to set a permanent global variable on the server MINICONDA=$MINICONDA !!!"

set +eu
