conda create -n primer3tools-0.0.2 python=3 primer3=2.6.1 bowtie2=2.4.5
conda activate primer3tools
wget https://github.com/jacquikeane/primer3tools/archive/refs/tags/v0.0.2.tar.gz
tar -xvf v0.0.2.tar.gz
cd primer3tools-0.0.2
python3 setup.py test
python3 setup.py install
cd ..
rm -rf v0.0.2.tar.gz
rm -rf primer3tools
conda deactivate
