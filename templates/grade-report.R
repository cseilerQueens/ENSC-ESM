files <- list.files("submissions", pattern = "\\.json$", full.names = TRUE)

for (f in files) {
  student <- jsonlite::fromJSON(f)
  key <- jsonlite::fromJSON("answer_key_02.json")

  # compare student$answers to key$answers
}
