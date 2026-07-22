setwd("/global/home/hpc5112/ENSC-ESM")


extract_blocks <- function(lines, outfile, mode = c("student", "answer")) {
  mode <- match.arg(mode)

  out <- character()

  in_block <- FALSE
  block_type <- NULL
  block_lines <- character()

  question_number <- 0


  for (line in lines) {
    # Detect start of include block
    if (grepl("^::: \\{\\.include\\}", line)) {
      in_block <- TRUE
      block_type <- "include"
      block_lines <- c(line)
      next
    }


    # Detect start of question block
    if (grepl("^::: \\{\\.question", line)) {
      in_block <- TRUE
      block_type <- "question"
      block_lines <- c(line)
      question_number <- question_number + 1

      next
    }


    # Inside block
    if (in_block) {
      # End of block
      if (grepl("^:::$", line)) {
        block_lines <- c(block_lines, line)


        if (block_type == "include") {
          out <- c(out, block_lines)
        }


        if (block_type == "question") {
          if (mode == "student") {
            # Add question unchanged
            out <- c(out, block_lines)
          }


          if (mode == "answer") {
            # Replace student answer with solution
            block_text <- paste(block_lines, collapse = "\n")


            # extract answer="A"
            correct_answer <- sub(
              '.*answer="([^"]+)".*',
              "\\1",
              block_text
            )


            # replace answer placeholder
            block_text <- gsub(
              'answer <- "X"',
              paste0('answer <- "', correct_answer, '"'),
              block_text
            )


            # remove record_answer()
            block_text <- gsub(
              "record_answer\\(answer\\)",
              "",
              block_text
            )


            out <- c(
              out,
              strsplit(block_text, "\n")[[1]]
            )
          }
        }


        in_block <- FALSE
        block_type <- NULL
        block_lines <- character()

        next
      }


      block_lines <- c(block_lines, line)
      next
    }
  }


  writeLines(out, outfile)
}

# Run the function

files <- list.files(
  pattern = "^[0-9]{2}-.*\\.Rmd$"
)


for (file in files) {
  lines <- readLines(file, warn = FALSE)


  base <- sub("\\.Rmd$", "", file)


  # Student template

  extract_blocks(
    lines,
    outfile = file.path(
      "templates",
      paste0(base, "-template.Rmd")
    ),
    mode = "student"
  )


  # Instructor answer sheet

  extract_blocks(
    lines,
    outfile = file.path(
      "answers",
      paste0(base, "-answers.Rmd")
    ),
    mode = "answer"
  )
}
