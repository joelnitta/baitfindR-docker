Dockerfile for building images to run [baitfindR](https://joelnitta.github.io/baitfindR/) and its dependencies. Based on [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse).

During the build, R packages are installed using `packrat::restore()`. For a more detailed explanation of this process, see [this blog post](https://www.joelnitta.com/post/docker-and-packrat/) and [this example repo](https://github.com/joelnitta/docker-packrat-example).

The `packrat.lock` file should be built with the following command, which sources `install_packages.R` within a `rocker/tidyverse` container (change path on LHS of `-v` as needed).

```
docker run --rm -e DISABLE_AUTH=true -v /Users/joelnitta/repos/baitfindr-docker:/home/rstudio/project -w /home/rstudio/project rocker/tidyverse:3.6.0 Rscript install_packages.R
```
