#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Step 4: Download A_single_genome.sh
# -----------------------------------------------------------------------------
# To test run - detecting EVEs in a single genome
mamba deactivate                                                           # To deactivate previous env
mamba activate EVEproject                  	                            # To activate environment for data download
mamba install -c conda-forge ncbi-datasets-cli                             # To install ncbi-datasets-cli tool

datasets download genome accession GCF_003286155.1 --include genome        # To download specific genome
unzip ncbi_dataset.zip                                                     # To unzip downloaded genome

cat dataset_catalog.json | jq '.'                                          # To view a pretty-print catalog of JSON
cat assembly_data_report.jsonl | jq '.'                                    # To view a pretty-print assembly report

mamba deactivate                                                           # To switch to detectEVE for analysis
mamba activate detectEVE

# Download genome .fna file directly from NCBI FTP
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/030/788/295/GCF_030788295.1_Dvir_AGI_RSII-ME/GCF_030788295.1_Dvir_AGI_RSII-ME_genomic.fna.gz

gunzip GCF_030788295.1_Dvir_AGI_RSII-ME_genomic.fna.gz                     # To decompress genome file
mv GCF_030788295.1_Dvir_AGI_RSII-ME_genomic.fna GCF_030788295_1_Dvir_AGI_RSII-ME_genomic.fna  # To rename file (dots to underscores)

./detectEVE GCF_030788295_1_Dvir_AGI_RSII-ME_genomic.fna                   # To run detectEVE on the genome

cd detectEVE                                                               # To enter detectEVE directory
cd results                                                                 # To go to results folder
ls                                                                         # To list result files
cat GCF_030788295_1_Dvir_AGI_RSII-ME_genomic-validatEVEs.tsv               # To view summary table
head -n 10 GCF_030788295_1_Dvir_AGI_RSII-ME_genomic-validatEVEs.fna        # To preview first 10 EVE sequences
