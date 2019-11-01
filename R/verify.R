# if names of `x` aren't as expected, report that
verify_columns <- function(x)
{
  cur_names <- names(x)

  t1 <- cur_names[!(cur_names %in% rise_json_req_obj)]

  assert_that(
    length(t1) == 0,
    msg = paste(
      paste(t1, collapse = " & "),
      "is found in `names(x)`, but shouldn't be."
    )
  )

  t1 <- rise_json_req_obj[!(rise_json_req_obj %in% cur_names)]

  assert_that(
    length(t1) == 0,
    msg = paste(
      paste(t1, collapse = " & "),
      "is not found in `names(x)`, but should be."
    )
  )

  invisible(x)
}

# Fail if any of the character counts are higher than expected
check_char_count <- function(x)
{
  max_counts <- c(
    "sourceCode" = 45,
    "parameterSourceCode" = 45,
    "modelRunSourceCode" = 45,
    "modelRunMemberSourceCode" = 45,
    "status" = 45,
    "modelRunName" = 255,
    "modelRunDescription" = 255,
    "modelRunAttributes" = 500,
    "modelRunMemberDesc" = 500
  )

  for (var_name in names(max_counts)) {
    max_count <- max(stringr::str_count(x[[var_name]]))
    assert_that(
      max_count <= max_counts[var_name],
      msg = paste0("Max for ", var_name, " is ", max_count,
                   "; it should be <= ", max_counts[var_name])
    )
  }

  invisible(x)
}

# ensure the rwtbl has all required columns
check_rwtbl <- function(rwtbl)
{
  assert_that(is(rwtbl, "tbl_df"))

  rwtbl_req_cols <- c(rwtbl_cols_for_rise, "Scenario", "ObjectSlot")

  x <- rwtbl_req_cols %in% names(rwtbl)

  assert_that(
    all(x),
    msg = paste(
      paste(rwtbl_req_cols[!x], collapse = ", "),
      "are required column names, but were not found in the provided `rwtbl`."
    )
  )

  req_atts <- c("mrm_config_name", "description", "create_date")

  x <- req_atts %in% names(attributes(rwtbl))

  assert_that(
    all(x),
    msg = paste0(
      "The following are required attributes but were not found in the `rwtbl`:",
      "\n  - ", paste(req_atts[!x], collapse = ", ")
    )
  )

  invisible(rwtbl)
}

# ensure the provided ui_vars is specified correctly
check_ui_vars <- function(ui_vars)
{
  assert_that(class(ui_vars) == "list")
  assert_that(length(ui_vars) == 4)

  req_names <- c("sourceCode", "modelNameSourceCode", "status",
                 "modelRunDescription")

  x <- req_names %in% names(ui_vars)
  assert_that(
    all(x),
    msg = paste(
      paste(req_names[!x], collapse = ","),
      "are required names in `ui_vars`, but they are not specified"
    )
  )

  for (n in names(ui_vars)) {
    assert_that(
      length(ui_vars[[n]]) == 1,
      msg = paste0("`ui_vars[[", n, "]]` should only have a length of 1")
    )
  }

  invisible(ui_vars)
}
