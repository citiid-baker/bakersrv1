 2020  conda create -n primer3tools-0.0.2 python=3 primer3=2.6.1 bowtie2=2.4.5
 2021  conda activate primer3tools
 2022  git clone https://github.com/jacquikeane/primer3tools
 wget https://github.com/jacquikeane/primer3tools/archive/refs/tags/v0.0.2.tar.gz
 2023  cd primer3tools/
 2024  python3 setup.py test
 2025  python3 setup.py install
 2030  cd ..
 2032  rm -rf primer3tools
 2033  conda deactivate
