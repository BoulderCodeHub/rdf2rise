library(RWDataPlyr)

test_that("rwtbl_cols_for_rise works with RWDataPlyr", {
  expect_s3_class(
      rdf_to_rwtbl2(
      "../KeySlots.rdf",
      scenario = "DNF,CT",
      keep_cols = rwtbl_cols_for_rise
    ),
    "tbl_df"
  )
})
