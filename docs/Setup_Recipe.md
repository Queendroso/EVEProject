---
editor_options: 
  markdown: 
    wrap: 72
---

# Setup Recipe (R Console): Create, Version, Document, Publish

Copy-paste these commands into the R Console inside the RStudio Project.
\# 0) Install helper packages

```{r}
install.packages(c('usethis','here','fs','renv','readr','dplyr','ggplot2','janitor','rmarkdown','gitcreds'))
```

# 1) Create/open RStudio Project (manual step)

# -File → New Project → New Directory → New Project

# -Name it: EVEProject (or any name), tick “Create a git repository” if available.

# -Then continue in the Console with the active project.

# 2) Set project-scoped Git identity (avoids Windows HOME/network issues)

# What: writes user.name/email to .git/config for this project only

# Why: Git requires an identity to make commits; project-scope is easiest and robust

```{r}
usethis::use_git_config(
  user.name  = "Rashidatu Abdulazeez",  #replace with your user.name
  user.email = "rabdulaz@ed.ac.uk",     #replace with your email
  scope      = "project"
)
```

# 3) Initialize Git and make the first commit

# What: adds/commits .gitignore and .Rproj

# How: interactively asks; choose 3 (“Yup”) when prompted

```{r}
usethis::use_git()
```

# 4) Create a Personal Access Token (PAT) on GitHub (opens browser)

# What: generates a token with minimal scopes (public_repo OR repo)

# Why: authenticates pushes from RStudio to GitHub over HTTPS

# After browser step, come back here and run gitcreds::gitcreds_set() to store it.

```{r}
usethis::create_github_token()        # This opens a browser of Github token.                                              Select repo, at most 90 days validity,                                             generate token. Copy, and save token
```

# 5) Store the token securely in the local Git credential helper (interactive)

# What: saves your PAT so future pushes don’t prompt

# How: choose “2: Replace” if asked, then paste the new token and press Enter

```{r}
gitcreds::gitcreds_set()
```

# 6) Create the GitHub repository and push the project

# What: creates repo under your GitHub account and pushes master/main

# Why: makes the project Available and backed up remotely

```{r}
usethis::use_github()
```

# 7) Add a README in R Markdown and render it to README.md

# What: creates README.Rmd and generates README.md and preview HTML

# Why: project Documentation front page (aims, how to run, outputs)

```{r}
usethis::use_readme_rmd() rmarkdown::render("README.Rmd")
```

# 8) Add a license (MIT for code is a good default)

MIT stands for Massachusetts Institute of Technology. The MIT License is
a type of open-source license that allows users to freely use, modify,
and distribute software.

# What: writes LICENSE.md and ignores it for R build

# Why: clarifies reuse permissions; needed for openness/compliance

```{r}
usethis::use_mit_license("Rashidatu Abdulazeez")
```

# 9) Create a standard, portable project layout (Transferable)

# What: consistent folders for data, scripts, and outputs

# Why: relative paths + here::here() will work on any machine

```{r}
fs::dir_create(c( "data/raw", "data/processed", "scripts/R", "scripts/bash", "output/figures", "output/tables", "docs" )) # Track empty output dirs with .gitkeep so Git keeps the folders fs::file_create("output/figures/.gitkeep") fs::file_create("output/tables/.gitkeep") # Explain where raw data goes and what license/source applies fs::file_create("data/raw/README.txt")
```

# 10) Ignore large/derived content and local libraries (clean repo)

# What: adds patterns to .gitignore

# Why: prevent committing large/raw data, temporary outputs, and renv libs

```{r}
usethis::use_git_ignore(c( "data/raw/", "output/", "!output/figures/.gitkeep", "!output/tables/.gitkeep", "renv/library/" ))
```

# 11) Reproducible environment with renv

# What: creates renv/ and renv.lock; links current packages into project lib

# Why: pins exact package versions; others can run renv::restore() to reproduce

```{r}
renv::init() # choose 'y' when asked to proceed
```

# (If you later add/remove packages, run renv::snapshot() to update renv.lock)

```{r} # renv::snapshot()}
```

# 

# 12) Commit and push all created files to GitHub (Available)

# What: adds README, LICENSE, folders, .gitignore, renv files to version control

# Why: keeps remote repo in sync; forms a clean baseline

```{r}
system("git add -A") system('git commit -m "Add README, license, folders, .gitignore, renv lock"') system("git push")
```

Tips and reminders:

\- Never paste your token into code files; use gitcreds::gitcreds_set()
interactively.

\- If you add packages later, run renv::snapshot() and commit the
updated renv.lock.

\- On a new machine: clone → open .Rproj → renv::restore() → run
scripts.

\- If Git complains about identity again, re-run
use_git_config(scope="project").

\- If you see selection menus from usethis (e.g., “Enter an item from
the menu”), choose 3 for “Yup.”
