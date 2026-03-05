#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Step 6: Detect Batch_detectEVE.sh
# -----------------------------------------------------------------------------
# To detect EVEs in Drosophilid genome
cd $BaseDir                                                                                       # To go to base directory
while read line; do                                                                               # To loop through each line (accession and species)
  accession_no=$(echo "$line" | cut -f 1)                                                         # To extract accession number
  species_name=$(echo "$line" | cut -f 2)                                                         # To extract species name
  out_file_stem=$(echo "${accession_no}___${species_name}" | sed 's/[-. ]/_/g')                   # To standardize output filename

  echo "Now running $species_name	 --- $accession_no output to $out_file_stem"                   # To print texts to the terminal

  mamba deactivate                                                                                # To switch to EVEproject environment
  mamba activate EVEproject

  echo "Download $species_name --- $accession_no"                                                 # To print texts to terminal

  datasets download genome accession "$accession_no" --include genome                             # To download genome
  unzip ncbi_dataset.zip                                                                          # To unzip genome
  find ./ncbi_dataset/ -name "*.fna" -exec mv {} "$out_file_stem.fna" \;                          # To rename all fine name with .fna to a consistent format defined by $out_file_stem.fna.
  rm -r ncbi_dataset ncbi_dataset.zip README.md md5sum.txt                                        # To clean up

  mamba deactivate                                                                                # To switch to detectEVE for running pipeline
  mamba activate detectEVE
  rm -r EVEoutput                                                                                 # To remove any leftover output folder
  $BaseDir/detectEVE/detectEVE -o EVEoutput --snake "--cores 32" "$out_file_stem.fna"             # To run detectEVE
  rm "$out_file_stem.fna"                                                                         # To remove genome file
  mv ./EVEoutput/results "$BaseDir/AllDetectEVEOutput/$out_file_stem.results"                     # To move result folder to output directory
  rm -r EVEoutput                                                                                 # To clean up temporary output

done < "$BaseDir/UpdatesToTheAccession_list.tsv"                                                  # To end loop
