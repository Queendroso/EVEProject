#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Step 07: Postprocess A_extract_high_conf.sh
# Purpose: Collect one header from any -validatEVEs.tsv and append all rows flagged 'high' to a dated TSV
# -----------------------------------------------------------------------------
find_files=$(find "$BaseDir"/AllDetectEVEOutput -name "*-validatEVEs.tsv" | head -n 1)                                                                             # To find a sample file for header; pick one TSV to copy header from
if [ -n "$find_files" ]; then  # Proceed only if we found at least one TSV
  head -n 1 "$find_files" | awk -v OFS='\t' '{print $1, $2, $3, $7, $9, $10, $12, $13}' > All_highConfidence.$DATE.tsv                                              # To write header (selected columns)
  find "$BaseDir"/AllDetectEVEOutput -name "*-validatEVEs.tsv" -exec grep high {} \; | cut -f 1-3,7,9,10,12-13 | sort -nr -k4,4 >> All_highConfidence.$DATE.tsv   # To extract and append all 'high'-confidence (selected columns)
fi                                                                                                                                                                     # Done
