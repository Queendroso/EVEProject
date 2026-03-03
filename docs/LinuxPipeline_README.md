# Linux Pipeline (DetectEVE → Taxonomy → Trees → ENA Evidence)

## Overview
This pipeline discovers EVEs in Drosophilidae with detectEVE, annotates taxonomy via EDirect, builds phylogenies (LucaProt + non-RdRp clusters), and maps ENA reads to EVEs + control genes for evidence (expression/coverage/polymorphism).

## Run order
Core detectEVE:
- scripts/bash/core/01_create_envs.sh
- scripts/bash/core/02_directories_and_paths.sh
- scripts/bash/core/03_detectEVE_setup.sh
- scripts/bash/core/04_single_genome.sh  # sanity-check
- scripts/bash/core/05_get_drosophilid_list.sh
- scripts/bash/core/06_batch_detectEVE.sh

Postprocess & taxonomy:
- scripts/bash/postprocess/07_extract_high_conf.sh
- scripts/bash/postprocess/08_check_missing_or_extra.sh
- scripts/bash/taxonomy/10_get_taxonomy_from_validatEVE.sh
- scripts/bash/taxonomy/11_run_edirect_taxonomy.sh
- scripts/bash/taxonomy/12_get_genome_sizes.sh

Phylogenetics & clustering:
- scripts/bash/utils/extract_EVEs.sh
- scripts/bash/phylo/lucaprot_classification_and_trees.sh
- scripts/bash/phylo/nonRdRp_smallgroups_and_clusters.sh
- scripts/bash/phylo/viral_CDS_plus_EVE_MACSE_IQTREE.sh

ENA mapping & evidence:
- scripts/bash/ena/ena_metadata_and_classification.sh
- scripts/bash/ena/species_mapping_EVEs_controls.sh
- scripts/bash/ena/suzukii_polymorphism_demo.sh

## One-shot orchestrator
Run everything on Linux from the project root:
```bash
bash scripts/bash/run_all.sh
```

## Notes
- Use Darren-style one-liners; loops are allowed; no trailing backslashes.
- Ensure DB paths (LucaProt/nr_cluster_viruses/RVDB) match your system.
- If efetch/elink are throttled, add short `sleep` in loops.
- Absolute base path is set once in `02_directories_and_paths.sh`.

## Outputs
- detectEVE result folders in `$BaseDir/AllDetectEVEOutput/`
- High-confidence TSVs, taxonomy tables, genome sizes
- Per-supergroup and per-cluster alignments and trees
- ENA mapping BAMs, mosdepth summaries, species `summary.txt`
- Polymorphism VCFs and reports
