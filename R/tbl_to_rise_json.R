#' Converts a tbl_df to the RISE JSON format
#'
#' `tbl_to_rise_json()` converts a tbl to the RISE json format.
#'
#' The RISE json format is a specific json format that (1) has one complete
#' object per row and (2) does not include any arrays. Each object on a row
#' contains 16 required object-value pairs.
#'
#' @param tbl A tbl_df with all required columns (fields for the RISE json
#'   file). Likely output from [`rwtbl_add_rise_vars()`].
#'
#' @return Invisibly returns data in RISE json format, currently just a
#'   character vector of length == 1.
#'
#' @export

tbl_to_rise_json <- function(tbl)
{
  nn <- names(tbl)
  assert_that(nn %in% rise_json_req_obj)
  assert_that(rise_json_req_obj %in% nn)

  # for every row in rdf:

  r3 <- jsonlite::toJSON(tbl, auto_unbox = TRUE)
  r3 <- as.character(r3)
  r3 <- stringr::str_remove(r3, "\\[")
  r3 <- stringr::str_remove(r3, "\\]")
  r3 <- stringr::str_replace_all(r3, "\\}\\,\\{", "}\n{")

  invisible(r3)
}
