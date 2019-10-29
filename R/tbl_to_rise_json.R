#' Converts a tbl to the RISE JSON format
#'
#' `tbl_to_rise_json()` converts the tbl to the RISE json format.

tbl_to_rise_json <- function(tbl)
{
  # for every row in rdf:

  r3 <- jsonlite::toJSON(tbl, auto_unbox = TRUE)
  r3 <- as.character(r3)
  r3 <- stringr::str_remove(r3, "\\[")
  r3 <- stringr::str_remove(r3, "\\]")
  r3 <- stringr::str_replace_all(r3, "\\}\\,\\{", "}\n{")

  r3
}
