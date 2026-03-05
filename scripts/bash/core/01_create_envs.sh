#!/usr/bin/env bash                                      # # This is a shebang, specifying the interpreter (Bash) to run the script
set -euo pipefail                                        # -e: Exit the script if any command fails (non-zero exit status); -u: Treat unset variables as an error; -o pipefail: Make the pipeline (|) fail if any command in it fails. Therefore, if any command in the pipeline fails, the whole pipeline fails. This helps catch errors earlier

# -----------------------------------------------------------------------------
# Step 01: Setup A- Create_envs.sh (detectEVE + EVEproject envs)
# -----------------------------------------------------------------------------
# Create environment for detectEVE
mamba create -n detectEVE                                # To create Mamba environment named detectEVE (-n implies if not yet created)
mamba activate detectEVE                                 # To activate detectEVE environment
mamba deactivate                                         # To deactivate environment (prepare to create next env)

# Create separate environment for genome download and file handling
mamba create -n EVEproject                               # To create another environment named EVEproject
mamba activate EVEproject                                # Activate EVEproject
