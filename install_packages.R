# Install packages within docker container, then write a snapshot to
# packrat/packrat.lock.

### Initialize packrat ###

# Install packrat
install.packages("packrat", repos = "https://cran.rstudio.com/")

# Initialize packrat, but don't let it try to find packages to install itself.
packrat::init(
  infer.dependencies = FALSE,
  enter = TRUE,
  restart = FALSE)

### Setup repositories ###

# Install packages that install packages.
install.packages("remotes", repos = "https://cran.rstudio.com/")

# Specify repositories so they get included in
# packrat.lock file.
my_repos <- c(CRAN = "https://cran.rstudio.com/")
options(repos = my_repos)

### Install packages ###

# All packages will be installed to
# the project-specific packrat library.

# Install CRAN packages
cran_packages <- c(
  "ape",
  "bedr",
  "conflicted",
  "future",
  "drake",
  "here",
  "ips",
  "knitr",
  "rlang",
  "tidyverse",
  "txtq",
  "visNetwork"
)

install.packages(cran_packages)

# Install github packages
remotes::install_github("joelnitta/baitfindR")

### Take snapshot ###

packrat::snapshot(
  snapshot.sources = FALSE,
  ignore.stale = TRUE,
  infer.dependencies = FALSE
  )
