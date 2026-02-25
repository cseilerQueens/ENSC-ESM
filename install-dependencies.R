module --force purge
module load StdEnv/2023
module load gcc/12.3
module load r/4.4.0
module load gdal/3.7.2
module load proj/9.4.1
module load geos/3.12.0
module load udunits/2.2.28

# install.packages("renv")
# install.packages("yaml")
# install.packages("pak")
.libPaths("/global/home/hpc5112/Rlibs_ESM")


install.packages("terra", Ncpus = 4)

deps <- renv::dependencies()
pkgs <- unique(deps$Package)
install.packages(pkgs)
pak::pak('rstudio/rmarkdown')
install.packages("bookdown")
pak::pak('cseilerQueens/clover')

# remotes::install_github("cseilerQueens/clover", ref = "main", dependencies = TRUE)
# remotes::install_github("cseilerQueens/clover", ref = "main", dependencies = FALSE)

