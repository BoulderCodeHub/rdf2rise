library(RWDataPlyr)
library(magrittr)
# setup -------------------------------
test_json <- scan(
  "../CRSS-TestData_2019110112212725.json",
  what = character(),
  sep = "\n",
  quiet = TRUE
)

gmt_plus <- scan(
  "../CRSS-TestData_2019110116055901.json",
  what = character(),
  sep = "\n",
  quiet = TRUE
)

ifile <- "../KeySlots.rdf"
keep_cols <- c("Timestep", "TraceNumber","ObjectName", "SlotName", "Value",
               "Unit", "RulesetFileName", "InputDMIName")
good_ui <- list(
  sourceCode = "CRSS-TestData",
  modelNameSourceCode = "CRSS",
  status = "Finalized Dec. 2012. To RISE v0.0.1",
  modelRunDescription = "desc"
)

good_tbl <- rdf_to_rwtbl2(ifile, keep_cols = keep_cols, scenario = "DNF,CT,IG")
rise_tbl <- rwtbl_add_rise_vars(good_tbl, good_ui)

# remove the lastUpdate object and value from the json file as this field will
# differ everytime the file is generated
remove_lastUpdate <- function(x)
{
  # "lastUpdate":"2019-11-01 11:09:24-06:00"
  lu_pattern <- paste(
    '\"lastUpdate\":\"\\d{4}-\\d{2}-\\d{2}',
    '\\d{2}:\\d{2}:\\d{2}[-|+]\\d{2}:\\d{2}\"'
  )

  x <- simplify2array(stringr::str_split(x, lu_pattern))
  x <- paste0(x[1,], x[2,])
  x
}

remove_modelRunDateTime_offset <- function(x)
{
  # 'somestuff\"modelRunDateTime\":\"2017-07-25 14:27:00+00:00\"morestuff'
  lu_pattern <- paste(
    '\"modelRunDateTime\":\"\\d{4}-\\d{2}-\\d{2}',
    '\\d{2}:\\d{2}:\\d{2}[-|+]\\d{2}:\\d{2}\"'
  )

  modelRunDateTime <- stringr::str_extract(x, lu_pattern) %>%
    # remove the offset
    stringr::str_split_fixed('[-|+]\\d{2}:\\d{2}', 2)

  before_after <- stringr::str_split_fixed(x, lu_pattern, 2)

  paste0(before_after[,1], modelRunDateTime[,1], modelRunDateTime[,2], before_after[,2])
}

# meta testing -------------------------------
# test the remove_lastUpdate to ensure it works with + and - GMT offsets
test_that("META - remove_lastUpdate test function is robust to GMT offsests", {
  t1 <- remove_lastUpdate(test_json)
  t2 <- remove_lastUpdate(gmt_plus)
  expect_identical(t1, t2)

  t1 <- remove_modelRunDateTime_offset(t1)
  t2 <- remove_modelRunDateTime_offset(t2)
  expect_identical(t1, t2)

  t1 <- paste(t1, collapse = "\n")
  t2 <- paste(t2, collapse = "\n")
  expect_identical(t1, t2)
})

# tbl_to_rise_json ---------------------------
test_json <- remove_lastUpdate(test_json) %>%
  remove_modelRunDateTime_offset() %>%
  paste(collapse = "\n")

test_that("tbl_to_rise_json matches as expected", {
  expect_type(x <- tbl_to_rise_json(rise_tbl), "character")
  expect_length(x, 1)

  # the newly created version should match the existing version (first 10 rows)
  # if the lastUpdate object is removed, because that object contains a time
  # stamp of when the file was created
  expect_type(x <- tbl_to_rise_json(rise_tbl[1:10, ]), "character")
  # split into 10 entries, remove lastUpdate, and then collapse
  x2 <- t(stringr::str_split_fixed(x, "\n", 10))
  expect_equal(dim(x2), c(10, 1))
  x3 <- remove_lastUpdate(x2) %>%
    remove_modelRunDateTime_offset() %>%
    paste(collapse = "\n")
  expect_equal(x3, test_json)
})
