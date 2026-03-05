#!/usr/bin/env bash
set -euo pipefail
# -----------------------------------------------------------------------------
# Step 10: Taxonomy A_get_taxonomy_from_validatEVE.sh
# Purpose: For EVEs lacking taxonomy, locate their protein info from *-validatEVEs.fna and compile accession list for EDirect
# -----------------------------------------------------------------------------
comm -23 <(sort EVEsWithoutVirusTaxonomy.txt) <(find ./ -name "*-validatEVEs.fna" -exec grep -F -o -f EVEsWithoutVirusTaxonomy.txt {} \; | sort -u)      # Show EVE IDs not present in any validatEVEs.fna (sanity check only)

cd "$BaseDir"/AllDetectEVEOutput                                                                                                                          # Work in results root
while read line; do                                                                                                                                         # Loop over EVE IDs missing taxonomy
  echo "$line"                                                                                                                                            # Echo current EVE ID for traceability
  fname=$(echo "$line" | sed 's/_EVE.\+/[.]results/g')                                                                                                   # Derive result folder name from EVE ID
  echo "$fname"                                                                                                                                           # Show expected folder
  cd "$fname"                                                                                                                                             # Enter that result folder
  EVEid=$(echo "$line" | grep -o "_EVE[0-9]\+")                                                                                                        # Extract the _EVE### tag
  echo "$EVEid"                                                                                                                                           # Show tag
  paste <(echo "$line") <(grep "$EVEid" *-validatEVEs.fna | sed 's/ /\t/g' | cut -f 2,3) >> "$BaseDir"/EVEsWithVirusTaxonomyProteins.tsv             # Append EVE ID with (protein name, accession)
  cd "$BaseDir"/AllDetectEVEOutput                                                                                                                        # Back to results root
done < "$BaseDir"/EVEsWithoutVirusTaxonomy.txt                                                                                                            # Feed loop from prepared list

# Extract protein accession numbers
awk '{print $NF}' "$BaseDir"/EVEsWithVirusTaxonomyProteins.tsv > "$BaseDir"/EVEsWithVirusProteinAssession.tsv

# Check for duplicates
cut -f1  "$BaseDir"/EVEsWithVirusTaxonomyProteins.tsv | sort | uniq -d || true                                                                           # Show duplicated EVE IDs (if any)
cat "$BaseDir"/EVEsWithoutVirusTaxonomy.txt | sort | uniq -d || true                                                                                     # Show duplicates in input (if any)

# Deduplicate the list
sed 's/ /_/g' "$BaseDir"/EVEsWithVirusProteinAssession.tsv | tr -d '\r' | sort | uniq > "$BaseDir"/EVEsWithVirusProteinAssession.tsv_uniqIDs.txt      # Normalise and uniq the accessions

# Check the format of your file;Each protein ID on a new line, followed by a $ symbol (indicating the end of the line); No extra characters or blank lines.
cat -A "$BaseDir"/EVEsWithVirusProteinAssession.tsv || true                                                                                              # Visual check for stray characters
cat -A "$BaseDir"/EVEsWithVirusProteinAssession.tsv_uniqIDs.txt || true                                                                                  # Visual check for stray characters

# Clean the file if necessary
sed '/^$/d' "$BaseDir"/EVEsWithVirusProteinAssession.tsv > "$BaseDir"/cleaned_file.tsv                                                                 # Remove blank lines if present
