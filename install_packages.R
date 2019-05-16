#' # Installing packages to the Docker image with packrat
#'
#' ## How this works
#'
#' ### Setup
#'
#' Keep `Dockerfile` and `install_packages.R` in the root of the
#' project directory.
#'
#' ### First step: make packrat/packrat.lock file
#'
#' Launch rocker image with tag set to same version we will use in
#' the Dockerfile and this directory mounted, and run this script.
#' (change path to this project directory if needed)
#'
#' ````
#' docker run -it -e DISABLE_AUTH=true -v /Users/joelnitta/repos/baitfindR-docker/:/home/rstudio/project rocker/tidyverse:3.6.0 bash
#' ````
#'
#' Install R packages.
#' ```
#' cd home/rstudio/project
#' Rscript install_packages.R
#' ```
#'
#' This will install current versions of all packages and deps
#' used in this project,
#' but the main reason is to write `packrat/packrat.lock`
#'
#' ### Second step: actually build the image
#'
#' Now we can use packrat.lock to restore (i.e., install) packages
#' during the next (real) docker build, using the `Dockerfile`.
#'
#' ```
#' docker build . -t joelnitta/baitfindr
#' ```
#'
#' ### Third step: rinse, repeat
#'
#' Edit the packages below as needed to add new packages
#' or update old ones (by installing), and repeat Steps 1 and 2.

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
github_packages <- c(
  "joelnitta/baitfindR"
)

remotes::install_github(github_packages)

### Take snapshot ###

packrat::snapshot(
  snapshot.sources = FALSE,
  ignore.stale = TRUE,
  infer.dependencies = FALSE
  )
