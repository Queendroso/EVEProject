---
editor_options: 
  markdown: 
    wrap: 72
---

# Linux Pipeline (DetectEVE → Taxonomy → Trees → ENA Evidence)

# Overview

This pipeline discovers EVEs in Drosophilidae with detectEVE, annotates
taxonomy via EDirect, builds phylogenies (LucaProt + non-RdRp clusters),
and maps ENA reads to EVEs + control genes for evidence
(expression/coverage/polymorphism).

# 1. What this pipeline does

-   Discover EVEs in Drosophilidae genomes with detectEVE, batch-run
    across accessions

-   Postprocess to extract high-confidence EVEs; fill missing taxonomy
    via EDirect

-   Classify proteins (LucaProt RdRp), pull close relatives, trim and
    infer trees

-   Build consolidated clusters for non-RdRp EVEs; add CDS and EVE DNA;
    MACSE + IQ-TREE

-   ENA-wide mapping (EVEs + control genes) to assess
    expression/coverage

-   Method C dating (within-host divergence) using WGS polymorphism

    # 2. Prerequisites

-   Linux shell with mamba/conda, wget/curl, git, awk/sed, jq

-   EDirect in \$HOME/edirect (efetch, esearch, elink), configured in
    PATH

-   BLAST/DIAMOND DBs accessible (LucaProt RdRps;
    nr_cluster_viruses_alias; RVDB taxonomy map)

-   Sufficient cores/disk; \~/.bashrc writeable for PATH updates

# 3. Create folders for Linux pipeline scripts and docs

```{r}
fs::dir_create(c(
  "scripts/bash/core",        # envs, setup, detectEVE core runs
  "scripts/bash/postprocess", # high-confidence, checks
  "scripts/bash/taxonomy",    # edirect taxonomy, missing tax, genome sizes
  "scripts/bash/utils",       # helpers (e.g., extract_EVEs)
  "scripts/bash/phylo",       # LucaProt, trees, clustering, MACSE/IQ-TREE
  "scripts/bash/ena",         # ENA metadata + species-wide mapping
  "docs"
))
```

# 4. Directory map in this repo

-   scripts/bash/core: step_01..06 (envs, setup, detectEVE runs)
-   scripts/bash/postprocess: step_07..08 (high-confidence + QC)
-   scripts/bash/taxonomy: step_10..12 (missing taxonomy; EDirect
    lineage; genome sizes)
-   scripts/bash/utils: helpers (e.g., extract_EVEs.sh)
-   scripts/bash/phylo: LucaProt supergroups, relatives, clustering,
    MACSE/IQ-TREE
-   scripts/bash/ena: ENA metadata, per-species mapping, summaries
-   docs/LinuxPipeline_README.md: this file

# 5. Run order (top to bottom)

## Core detectEVE:

-   scripts/bash/core/01_create_envs.sh
-   scripts/bash/core/02_directories_and_paths.sh
-   scripts/bash/core/03_detectEVE_setup.sh
-   scripts/bash/core/04_single_genome.sh \# sanity-check
-   scripts/bash/core/05_get_drosophilid_list.sh
-   scripts/bash/core/06_batch_detectEVE.sh

## Postprocess & Taxonomy:

-   scripts/bash/postprocess/07_extract_high_conf.sh
-   scripts/bash/postprocess/08_check_missing_or_extra.sh
-   scripts/bash/taxonomy/10_get_taxonomy_from_validatEVE.sh
-   scripts/bash/taxonomy/11_run_edirect_taxonomy.sh
-   scripts/bash/taxonomy/12_get_genome_sizes.sh

## Phylogenetics & Clustering (place after detectEVE has produced EVEs):

-   scripts/bash/utils/extract_EVEs.sh \#(from EVEnumbers list)
-   scripts/bash/phylo/lucaprot_classification_and_trees.sh \#(RdRp
    supergroups + trees)
-   scripts/bash/phylo/nonRdRp_smallgroups_and_clusters.sh \# (per-EVE
    relatives + merging into clusters)
-   scripts/bash/phylo/viral_CDS_plus_EVE_MACSE_IQTREE.sh \# (CDS
    retrieval; MACSE; ClipKIT; IQ-TREE)

## ENA Mapping & Evidence:

-   scripts/bash/ena/ena_metadata_and_classification.sh
-   scripts/bash/ena/species_mapping_EVEs_controls.sh
-   scripts/bash/ena/suzukii_polymorphism_demo.sh \#(example)

## One-shot orchestrator

Run everything on Linux from the project root:

``` bash
bash scripts/bash/run_all.sh
```

## Notes

-   Ensure DB paths (LucaProt/nr_cluster_viruses/RVDB) match your
    system.
-   If efetch/elink are slow, add short `sleep` in loops.
-   Absolute base path is set once in `02_directories_and_paths.sh`.

## Outputs

-   detectEVE result folders in `$BaseDir/AllDetectEVEOutput/`
-   High-confidence TSVs, taxonomy tables, genome sizes
-   Per-supergroup and per-cluster alignments and trees
-   ENA mapping BAMs, mosdepth summaries, species `summary.txt`
-   Polymorphism VCFs and reports
