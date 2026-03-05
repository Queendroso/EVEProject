#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Step 5: Download B_get_complete_drosophilid_list
# -----------------------------------------------------------------------------
# Download the complete Drosophilidae genome list. This snippet looks through the list of previously downloaded genome and downloads only current ones (if availble)
mamba activate EVEproject                                                                        # To activate environment for downloading genomes

datasets summary genome taxon Drosophilidae > Drosophilidae_Accession_$(date +"%Y_%m_%d").json   # To download (current) metadata for all Drosophilid genomes

# Extract accession and species names
cat Drosophilidae_Accession_$(date +"%Y_%m_%d").json | jq -r '.[] | .[]? | "\(.current_accession)\t\(.organism.organism_name)"' > Accession_list_$DATE.tsv

# Get list of already processed genomes
ls -d $BaseDir/AllDetectEVEOutput/*/ 2>/dev/null | sed "s|$BaseDir/AllDetectEVEOutput/||g" | sed 's/___.\+//g' | sort | uniq > AlreadyDone.txt

# Get list of currently added genomes
cat Accession_list_$DATE.tsv | cut -f 1 | sed 's/[.]/_/g' | sort | uniq > CurrentList.txt

# Compare and extract only the new/unprocessed ones
cat CurrentList.txt AlreadyDone.txt AlreadyDone.txt 2>/dev/null | sort | uniq -u | sed 's/_\([0-9]\+\)$/\.\1/g' | grep -F -f - Accession_list_$DATE.tsv > UpdatesToTheAccession_list.tsv
