#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Step 11: Taxonomy B_run_edirect_taxonomy.sh
# Purpose: Use EDirect to resolve NCBI TaxID and lineage for each protein accession, writing a 2-column TSV
# -----------------------------------------------------------------------------
# Set up Entrez Direct path for this session and future sessions
export PATH=$PATH:/home/rabdulaz/edirect                                                                  # To temporarily add EDirect to PATH
echo 'export PATH=$PATH:/home/rabdulaz/edirect' >> ~/.bashrc                                              # To add EDirect path permanently
source ~/.bashrc                                                                                          # To reload shell config

# To get the TaxID (taxonomy ID) for a single protein accession number
elink -db protein -id WPV74318.1 -target taxonomy | efetch -format docsum | grep "<TaxId>" | sed 's/<TaxId>//; s/<\/TaxId>//'      # Which will provide a taxid of 10239 to be used in the next command line

# Check how the lineage information is formatted before extraction
efetch -db taxonomy -id $taxid -mode xml | grep "<Lineage>"                                               # Shows the format

# Loop through each protein accession to get taxonomy
for protein_id in $(cat EVEsWithVirusProteinAssession.tsv_uniqIDs.txt); do                                # To loop through each protein accession
  echo >&2 "Processing protein ID: $protein_id"                                                           # To print processing message to stderr
  taxid=$(elink -db protein -id $protein_id -target taxonomy | efetch -format docsum | grep "<TaxId>" | sed 's/<TaxId>//; s/<\/TaxId>//')     # To get  TaxID
  if [ -z "$taxid" ]; then                                                                                # If taxid is empty, not found
    echo >&2 "No taxid found for $protein_id"                                                             # To print warning message
    echo -e "${protein_id}\tNo taxid found" >> NowEVEsWithVirusTaxonomy.tsv                              # To record as missing taxid
  else                                                                                                    # Have TaxID; fetch lineage
    lineage=$(efetch -db taxonomy -id $taxid -mode xml | grep "<Lineage>" | sed 's/<Lineage>//; s/<\/Lineage>//')                    # To extract lineage string
    echo -e "${protein_id}\t${lineage}" >> NowEVEsWithVirusTaxonomy.tsv                                  # To append protein ID and lineage
  fi                                                                                                      # End if taxid
done                                                                                                      # End of loop
