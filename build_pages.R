.libPaths("/global/home/hpc5112/Rlibs_ESM")
bookdown::render_book()

# The website on github uses files in docs
# Copy _book to docs
unlink("docs", recursive = TRUE)
dir.create("docs")

file.copy(
  list.files("_book", full.names = TRUE),
  "docs",
  recursive = TRUE,
  overwrite = TRUE
)