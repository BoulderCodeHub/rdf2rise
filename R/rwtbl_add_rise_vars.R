#' Add required RISE variables to the rwtbl
#'
#' `rwtbl_add_rise_vars()` takes in a rwtbl and adds in the variables required
#' for publication in RISE.
#'
#' @param rwtbl A tbl_df with expected columns. Likely this is output from
#'   [`RWDataPlyr::rdf_to_rwtbl2()`]
#'
#' @param ui_vars User specified values (as a list) for the `sourceCode`,
#' `modelNameSourceCode`, `status`, and `modelRunDescription` fields in the
#'   RISE json file.
#'
#' @return tbl with all required fields for RISE json file
#'
#' @export

add_rise_vars_to_rwtbl <- function(rwtbl, ui_vars)
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

  last_update <- get_time_with_offset(now())

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
      modelRunAttributes = get_modelRunAttributes(InputDMIName, RulesetFileName),
      modelRunDateTime = run_date,
      resultAttributes = "null",
      modelRunName = Scenario,
      modelRunMemberDesc = paste0(Scenario," - Trace ", TraceNumber),
      modelNameSourceCode = ui_vars$modelNameSourceCode,
      SlotName = paste(ObjectName, SlotName, sep = "."),
      TraceNumber = as.character(TraceNumber)
    ) %>%
    dplyr::rename(
      locationSourceCode = ObjectName,
      result = Value,
      parameterSourceCode = SlotName,
      modelRunSourceCode = Scenario,
      modelRunMemberSourceCode = TraceNumber
    ) %>%
    dplyr::select(-Timestep, -Year, -Month, -Unit, -ObjectSlot,
                  -RulesetFileName, -InputDMIName)

  # check that everything worked
  verify_columns(r2)
  check_char_count(r2)

  r2
}
