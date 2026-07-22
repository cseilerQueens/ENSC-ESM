myDir <- "/global/home/hpc5112/ENSC-ESM"
setwd(myDir)

.libPaths("/global/home/hpc5112/Rlibs_ESM")

# Render Book
bookdown::render_book()
# Delete folders that are not needed
unlink("_main_files", recursive = TRUE)
unlink("_bookdown_files", recursive = TRUE)
unlink("figure-html", recursive = TRUE)
print("Book has been rendered")
setwd(myDir)

# Update website files
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
print("Website files have been updated in docs folder")
setwd(myDir)

# Generate templates and answers
source("generate-templates-and-answers.R")
print("Template and answer RMD files have been produced in their respectiv folders")
setwd(myDir)

# Knit templates:
source("knit-templates.R")
print("Template PDF files have been knitted in the templates folder")
setwd(myDir)

# Knit templates:
source("knit-answers.R")
print("Answer PDF files have been knitted in the answers folder")
setwd(myDir)
