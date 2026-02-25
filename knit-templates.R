setwd("/global/home/hpc5112/ENSC-ESM/templates")

files <- list.files(pattern = "\\.Rmd$")
n <- length(files)
for (i in 1:n) {
  rmarkdown::render(
    input = files[i],
    output_format = rmarkdown::pdf_document(),
    output_file = sub("\\.Rmd$", ".pdf", files[i]),
    knit_root_dir = getwd(),
    envir = new.env(parent = globalenv())
  )
}
