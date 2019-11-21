#' Add required RISE variables to rwtbl
#'
#' `rwtbl_add_rise_vars()` takes in an rwtbl and adds in the variables required
#' for publication in RISE. It does so by converting variables from the rwtbl
#' to the corresponding required object name in the RISE json format. Some
#' columns some are constructed from one or more variables in the rwtbl, a
#' few must be provided by the user (`ui_vars`), and others are constructed
#' from attributes in the rwtbl. [`rwtbl_cols_for_rise`] includes all of the
#' columns that are required in the rwtbl for this function to work properly.
#'
#' @param rwtbl A tbl_df with expected columns. Likely this is output from
#'   [`RWDataPlyr::rdf_to_rwtbl2()`]
#'
#' @param ui_vars User specified values (as a list) for the `sourceCode`,
#' `modelNameSourceCode`, `status`, and `modelRunDescription` fields in the
#'   RISE json file.
#'
#' @return tbl with all required objects for RISE json file as column names
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
#' @export

rwtbl_add_rise_vars <- function(rwtbl, ui_vars)
{
  check_rwtbl(rwtbl)
  check_ui_vars(ui_vars)

  # assume that the run date has the same tmezone as the computer that is
  # running this code
  run_date <- lubridate::force_tz(
    lubridate::ymd_hm(attributes(rwtbl)$create_date),
    Sys.timezone()
  ) %>%
    get_time_with_offset()

  last_update <- get_time_with_offset(lubridate::now())
  tbl_atts <- attributes(rwtbl)

  r2 <- rwtbl %>%
    dplyr::mutate(
      sourceCode = ui_vars$sourceCode,
      # set times to noon and add in the GMT offset of -07:00
      # subtract 1 second to get from 24:00 to 23:99 so month/date are correct
      dateTime = paste(
        lubridate::date(lubridate::ymd_hm(Timestep) - 1),
        "12:00:00-07:00"
      ),
      status = ui_vars$status,
      lastUpdate = last_update,
      modelRunDescription = ui_vars$modelRunDescription,
      modelRunAttributes =
        get_modelRunAttributes(InputDMIName, RulesetFileName, tbl_atts),
      modelRunDateTime = run_date,
      resultAttributes = NA_character_,
      modelRunName = Scenario,
      modelRunMemberDesc = paste0(Scenario," - Trace ", TraceNumber),
      modelNameSourceCode = ui_vars$modelNameSourceCode,
      SlotName = paste(ObjectName, SlotName, sep = "."),
      TraceNumber = as.character(TraceNumber)
    ) %>%
    dplyr::rename(
      locationSourceCode = ObjectName,
      result = Value,
      parameterSourceCode = ObjectSlot,
      modelRunSourceCode = Scenario,
      modelRunMemberSourceCode = TraceNumber
    ) %>%
    dplyr::select(-Timestep, -Year, -Month, -Unit, -SlotName,
                  -RulesetFileName, -InputDMIName)

  # check that everything worked
  verify_columns(r2)
  check_char_count(r2)

  r2
}
