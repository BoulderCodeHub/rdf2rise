library(RWDataPlyr)

# initial setup -----------------------
ifile <- "../KeySlots.rdf"

keep_cols <- c("Timestep", "TraceNumber","ObjectName", "SlotName", "Value",
  "Unit", "RulesetFileName", "InputDMIName")

bad_tbl <- rdf_to_rwtbl2(ifile, scenario = "DNF,CT,IG")
bad_tbl2 <- rdf_to_rwtbl2(ifile, keep_cols = keep_cols)
good_tbl <- rdf_to_rwtbl2(ifile, keep_cols = keep_cols, scenario = "DNF,CT,IG")

bad_ui <- list(
  sourceCode = "CRSS-TestData",
  modelNameSourceCode = "CRSS",
  status = "testing"
)
bad_ui2 <- list(
  sourceCode = "CRSS-TestData",
  modelNameSourceCode = "CRSS",
  status = c("testing", "and more testing"),
  modelRunDescription = "test description"
)
good_ui <- list(
  sourceCode = "CRSS-TestData",
  modelNameSourceCode = "CRSS",
  status = "testing",
  modelRunDescription = "test description"
)

# check errors ----------------------
test_that("rwtbl_add_rise_vars() errors correctly", {
  expect_error(rwtbl_add_rise_vars(bad_tbl, good_ui))
  expect_error(rwtbl_add_rise_vars(bad_tbl2, good_ui))
  expect_error(rwtbl_add_rise_vars(good_tbl, bad_ui))
  expect_error(rwtbl_add_rise_vars(good_tbl, bad_ui2))
})

# check return type/value ----------------
expt_cols <- c(
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



test_that("rwtbl_add_rise_vars() returns as expected", {
  expect_is(x <- rwtbl_add_rise_vars(good_tbl, good_ui), "tbl_df")
  expect_equal(nrow(x), nrow(good_tbl))
  expect_true(all(names(x) %in% expt_cols))
  expect_true(all(expt_cols %in% names(x)))
})
