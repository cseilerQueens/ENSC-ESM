setwd("/global/home/hpc5112/ENSC-ESM")

strip_chunks <- function(
  infile,
  outfile,
  marker = "# template code chunk"
) {
  lines <- readLines(infile, warn = FALSE)

  out <- character()
  in_chunk <- FALSE
  chunk_lines <- character()

  for (line in lines) {
    # Start of R chunk
    if (grepl("^```\\{r", line)) {
      in_chunk <- TRUE
      chunk_lines <- line
      next
    }

    # End of chunk
    if (in_chunk && grepl("^```\\s*$", line)) {
      chunk_lines <- c(chunk_lines, line)

      # Keep chunk only if marker is present
      if (any(grepl(marker, chunk_lines, fixed = TRUE))) {
        out <- c(out, chunk_lines)
      }

      in_chunk <- FALSE
      chunk_lines <- character()
      next
    }

    # Inside chunk
    if (in_chunk) {
      chunk_lines <- c(chunk_lines, line)
      next
    }

    # Outside chunk (always keep)
    out <- c(out, line)
  }

  writeLines(out, outfile)
}

files <- list.files(pattern = "^[0-9]{2}-.*\\.Rmd$")

n <- length(files)
for (i in 1:n) {
  infile <- files[i]
  outfile <- sub("(.*)\\.Rmd$", "\\1-template.Rmd", infile)

  strip_chunks(
    infile  = infile,
    outfile = file.path("templates", outfile)
  )
}
