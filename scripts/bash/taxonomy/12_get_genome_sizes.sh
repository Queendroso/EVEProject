#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Step 12: Getting Genome sizes from NCBI
# Purpose: Prepare EDirect path, fetch assembly summaries, normalise accession list, then call get_genome_sizes.sh
# -----------------------------------------------------------------------------
whereis entrez                                                                                            # Locate EDirect tools if installed in multiple places (informational)
find ~/ -name esearch 2>/dev/null || true                                                                 # Show candidate esearch paths (informational)
echo 'export PATH=$HOME/edirect:$PATH' >> ~/.bashrc                                                       # Ensure EDirect's bin is in PATH for future sessions
source ~/.bashrc                                                                                          # Reload PATH
which esearch || { echo 'ERROR: esearch not found in PATH'; exit 1; }                                     # Confirm esearch is usable

wget -c ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/assembly_summary_genbank.txt                           # GenBank assembly summary, which includes genome sizes
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt                 # RefSeq summary (optional reference)

sed -i 's/\r$//' AssembliesinLinux.tsv                                                                   # Strip Windows CRs from input list if present
sed 's/^\(GCF_[0-9]*\)_\([0-9]\)$/\1.\2/' AssembliesinLinux.tsv > accession_list.txt                # Convert GCF_XXXX_1 -> GCF_XXXX.1

chmod +x scripts/bash/taxonomy/get_genome_sizes.sh 2>/dev/null || true                                    # Ensure helper is executable if stored in repo
ASSEMBLY_SUMMARY=assembly_summary_genbank.txt INPUT=accession_list.txt OUTPUT=GenomeSizes.tsv scripts/bash/taxonomy/get_genome_sizes.sh  # Run helper with explicit I/O
echo 'Done. GenomeSizes.tsv written.'                                                                     # Completion message
