#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Step 8: Postprocess B_check_missing_or_extra.sh
# Purpose: Per-result-folder sanity check for presence/duplication of -validatEVEs.fna; general file-count check by stem
# -----------------------------------------------------------------------------
# Check result folders for missing validatEVEs.fna files
find "$BaseDir"/AllDetectEVEOutput -mindepth 1 -maxdepth 1 -type d | while read dir; do  # Iterate each result folder
  count=$(find "$dir" -name "*-validatEVEs.fna" | wc -l)                                  # Count FASTA of validated EVEs in this folder
  if [ "$count" -eq 0 ]; then
    echo "MISSING: $dir has no -validatEVEs.fna file"                                     # Report missing
  elif [ "$count" -gt 1 ]; then
    echo "EXTRA: $dir has more than one -validatEVEs.fna file"                            # Report duplicates
  fi                                                                                       # Finish with a file
done                                                                                       # End per-folder loop

# Check for missing or additional files
find ./ -name "*.*" | sed 's/___.\+//g' | sort | uniq -c | sort -nr | more              # Count files by stem to spot anomalies
