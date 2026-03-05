#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Step 03: Setup C- detectEVE.sh
# -----------------------------------------------------------------------------
mamba deactivate                                                            # To ensure fresh start for detectEVE environment
mamba activate detectEVE                                                    # To activate detectEVE environment

git clone https://github.com/thackl/detectEVE                               # To clone detectEVE from GitHub
mamba env update --file workflow/envs/env.yaml                              # To install detectEVE dependencies from YAML file

cd $BaseDir                                                                 # To go back to base directory
./detectEVE --setup-databases --snake '--cores 32 --notemp' || true         # To setup necessary databases for detectEVE; --snake: passes arguments to Snakemake backend; --cores 32: uses 32 CPU cores; --notemp: tells Snakemake not to keep temporary files; || true: ensures the command succeeds (returns true) even if detectEVE fails

# Inspect taxonomy structure
head nodes.dmp
head names.dmp
grep -iE "domain|realm|acellular root|cellular root" nodes.dmp              # To perform a case-insensitive search for taxonomic ranks using extended regular expressions
grep -iE "domain|realm|acellular root|cellular root" names.dmp

# Fix taxonomic ranks in taxonomy files (after databases are downloaded)
sed -i 's/domain/superkingdom/g; s/<.*superkingdom /superkingdom /g; s/acellular root/superkingdom/g; s/cellular root/superkingdom/g; s/realm/superkingdom/g' nodes.dmp names.dmp     # To substitute globally words within the first backslashes in the .dmp files; Harmonise taxonomy to ensure compatibility with detectEVE expectations
