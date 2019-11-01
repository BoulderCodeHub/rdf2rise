#' Required columns, variables, and objects
#'
#' `rwtbl_cols_for_rise()` contains the columns that are required from the
#' rdf file to ensure rdf2rise can fill in all required json objects for RISE.
#' This should be passed to [`RWDataPlyr::rdf_to_rwtbl2()`] as the `keep_cols`
#' argument. `rise_json_req_obj()` contains all of the required json objects for
#' RISE. All of these will be returned by [rwtbl_add_rise_vars()], but this
#' could be used if you are creating your own tbl to pass to
#' [`tbl_to_rise_json()`].
#'
#' @rdname req_vars
#' @export

rwtbl_cols_for_rise <- c("Timestep", "TraceNumber","ObjectName", "SlotName",
                         "Value", "Unit", "RulesetFileName", "InputDMIName",
                         "ObjectSlot")

#' @rdname req_vars
#' @export
rise_json_req_obj <- c(
  "sourceCode",
  "locationSourceCode",
  "dateTime",
  "result",
  "status",
  "lastUpdate",
  "resultAttributes",
  "parameterSourceCode",
  "modelRunSourceCode",
  "modelRunName",
  "modelRunDescription",
  "modelRunAttributes",
  "modelRunMemberSourceCode",
  "modelRunMemberDesc",
  "modelRunDateTime",
  "modelNameSourceCode"
)
