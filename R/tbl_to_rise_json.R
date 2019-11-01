#' Convert a tbl_df to the RISE json format
#'
#' `tbl_to_rise_json()` converts a tbl_df to the RISE json format.
#'
#' The RISE json format is a specific json format that (1) has one complete
#' object per row and (2) does not include any arrays. Each object on a row
#' contains 16 required object-value pairs. The provided `tbl` should have
#' column names that match the required json objects (see [rise_json_req_obj])
#' and the package
#' [GitHub site README](https://github.com/BoulderCodeHub/rdf2rise).
#' The function will error if this is not the case. It is probably best to
#' create the `tbl` using [`rwtbl_add_rise_vars()`], but it is possible it
#' could be created some other way.
#'
#' @param tbl A tbl_df with all required columns (objects for the RISE json
#'   file).
#'
#' @return Invisibly returns data in RISE json format, currently just a
#'   character vector of length == 1.
#'
#' @examples
#' ifile <- system.file(
#'   'extdata/Scenario/ISM1988_2014,2007Dems,IG,Most',
#'   "KeySlots.rdf",
#'  package = "RWDataPlyr"
#' )
#'
#' # get the tbl using RWDataPlyr
#' rwtbl <- RWDataPlyr::rdf_to_rwtbl2(
#'   ifile,
#'   scenario = "test",
#'   keep_cols = rwtbl_cols_for_rise
#' )
#'
#' # manually specify some parameters:
#' ui_vars <- list(
#'   sourceCode = "CRSS-TestData",
#'   modelNameSourceCode = "CRSS",
#'   status = "Finalized Dec. 2012. To RISE v0.0.1",
#'   modelRunDescription = "desc"
#' )
#'
#' # get the rest of the parameters automatically
#' rise_tbl <- rwtbl_add_rise_vars(rwtbl, ui_vars)
#'
#' # and then convert to the RISE json format
#' rise_json <- tbl_to_rise_json(rise_tbl)
#'
#' @export

tbl_to_rise_json <- function(tbl)
{
  nn <- names(tbl)
  assert_that(
    all(nn %in% rise_json_req_obj) & all(rise_json_req_obj %in% nn),
    msg = paste(
      "`tbl` should only have required json objects as column names.,
      See `?rise_json_req_obj`",
      sep = "\n"
    )
  )

  # for every row in rdf:

  r3 <- jsonlite::toJSON(tbl, auto_unbox = TRUE)
  r3 <- as.character(r3)
  r3 <- stringr::str_remove(r3, "\\[")
  r3 <- stringr::str_remove(r3, "\\]")
  r3 <- stringr::str_replace_all(r3, "\\}\\,\\{", "}\n{")

  invisible(r3)
}
