# Setup Recipe (R Console): Create, Version, Document, Publish

Copy-paste these commands into the R Console inside the RStudio Project.

```r
# 0) Install helper packages (safe to re-run)
install.packages(c('usethis','here','fs','renv','readr','dplyr','ggplot2','janitor','rmarkdown','gitcreds'))

# 1) Set project-scoped Git identity (works even if HOME is odd on Windows)
usethis::use_git_config(user.name = 'Your Name', user.email = 'your.email@ed.ac.uk', scope = 'project')

# 2) Initialize Git and first commit (choose 3 = Yup if prompted)
usethis::use_git()

# 3) Create a GitHub token (opens browser), then store it locally
usethis::create_github_token()
gitcreds::gitcreds_set()    # choose 'Replace', paste token, Enter

# 4) Create the GitHub repo and push
usethis::use_github()

# 5) README + render
usethis::use_readme_rmd()
rmarkdown::render('README.Rmd')

# 6) License, folders, ignores
usethis::use_mit_license('Your Name')
fs::dir_create(c('data/raw','data/processed','scripts/R','scripts/bash','output/figures','output/tables','docs'))
fs::file_create('output/figures/.gitkeep'); fs::file_create('output/tables/.gitkeep')
fs::file_create('data/raw/README.txt')
usethis::use_git_ignore(c('data/raw/','output/','!output/figures/.gitkeep','!output/tables/.gitkeep','renv/library/'))

# 7) Reproducible environment
renv::init()     # choose y; later use renv::snapshot() when you add packages

# 8) Commit and push
system('git add -A')
system('git commit -m "Add README, license, folders, .gitignore, renv lock"')
system('git push')
```

Tips:
- On a new machine: clone → open .Rproj → `renv::restore()` → run scripts.
- Use `here::here()` for all file paths.
