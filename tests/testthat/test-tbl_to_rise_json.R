library(RWDataPlyr)
# setup -------------------------------
test_json <- scan(
  "../CRSS-TestData_2019110112212725.json",
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
  print(paste0("****\n", x))
  # "lastUpdate":"2019-11-01 11:09:24-06:00"
  lu_pattern <- paste(
    '\"lastUpdate\":\"\\d{4}-\\d{2}-\\d{2}',
    '\\d{2}:\\d{2}:\\d{2}-\\d{2}:\\d{2}\"'
  )

  x <- simplify2array(stringr::str_split(x, lu_pattern))
  x <- paste(x[1,], x[2,],sep = '')
  x
}

test_json <- paste(remove_lastUpdate(test_json), collapse = "\n")

# tbl_to_rise_json ---------------------------

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
  x3 <- x2  %>%
    remove_lastUpdate() %>%
    paste(collapse = "\n")
  expect_identical(x3, test_json)
})


