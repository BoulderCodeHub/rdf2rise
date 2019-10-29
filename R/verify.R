# if names of `x` aren't as expected, report that
verify_columns <- function(x)
{
  expt <- c(
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

  cur_names <- names(x)

  t1 <- cur_names[!(cur_names %in% expt)]

  assert_that(
    length(t1) == 0,
    msg = paste(
      paste(t1, collapse = " & "),
      "is found in `names(x)`, but shouldn't be."
    )
  )

  t1 <- expt[!(expt %in% cur_names)]

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
