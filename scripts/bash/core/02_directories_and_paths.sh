#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Step 02: Setup B- Directories_and_paths.sh
# -----------------------------------------------------------------------------
DATE=$(date +"%Y_%m_%d")                               # To define date variable
mkdir -p EVEproject                                    # Create base project dir (if it does not exists)
BaseDir="/home/rabdulaz/EVEproject"                    # Set base path (edit for your system)
cd $BaseDir                                            # To define base directory path
mkdir -p $BaseDir/AllDetectEVEOutput                   # To create output folder for detectEVE results
