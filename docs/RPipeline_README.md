# R Analysis Pipeline

## Purpose
Document the R-side analysis: setup, data preparation, analyses and figures, and where outputs are written.

## Scripts
- `scripts/R/00_setup.R`
  - What: global options, libraries, seed
  - Why: consistent environment across all scripts
  - How: sets options; loads libraries
  - Output: none

- `scripts/R/01_data_prep.R`
  - What: read raw CSV(s), clean names/types, save processed data
  - Why: create consistent, analysis-ready dataset(s)
  - How: `readr` + `janitor` + `dplyr`
  - Output: `data/processed/clean_data.csv` (or parquet)

- `scripts/R/02_analysis.R`
  - What: compute summary tables and a main figure
  - Why: generate core quantitative outputs
  - How: `dplyr` summaries; `ggplot2` figure
  - Output: `output/tables/summary.csv`, `output/figures/plot_main.png`

## How to run
```r
renv::restore()
source('scripts/R/00_setup.R')
source('scripts/R/01_data_prep.R')
source('scripts/R/02_analysis.R')
```

## Conventions
- Use `here::here()` for file paths (never `setwd()`).
- Put anything not reproducible under `data/raw/` and document the source/license in `data/raw/README.txt`.
- Save outputs under `output/` and do not commit large outputs unless essential.
