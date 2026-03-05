
# ------------------------------------------------------------------------------
# Step 9: Is an R step (complete can be found in R pipeline; only summary here)
# Purpose: Checking for Missing Taxonomy (EVEsWithoutVirusTax.R)
# ------------------------------------------------------------------------------

# What: Identify EVE IDs in -validatEVEs.tsv that lack virus taxonomy; write EVEsWithoutVirusTaxonomy.txt for Step 10.
# Why: Some EVEs may not carry protein lineage; we resolve these separately.
# How: Read all *-validatEVEs.tsv, detect missing/empty taxonomy fields, collect EVE IDs, write a clean TXT (LF, no blanks).
# Output: EVEsWithoutVirusTaxonomy.txt (one EVE ID per line).

