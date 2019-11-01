# setup -----------------------

# get_ruleset ----------------------
test_that("get_ruleset works", {
  expect_identical(
    rdf2rise:::get_ruleset("$CRSS_DIR/ruleset/rules.rls.gz"),
    "rules.rls.gz"
  )

  expect_identical(
    rdf2rise:::get_ruleset("$CRSS_DIR\\ruleset\\rules.rls"),
    "rules.rls"
  )

  expect_identical(
    rdf2rise:::get_ruleset(c("$CRSS_DIR\\ruleset\\rules.rls.gz",
                             "$CRSS_DIR/ruleset/rules.rls")),
    c("rules.rls.gz", "rules.rls")
  )
})


# get_modelRunAttributes -----------------------------------------
tst_df <- data.frame(
  ruleset = rep("$CRSS_DIR/ruleset/rules.rls", 4),
  dmi = c("This and that", "that", "this", "other"),
  stringsAsFactors = FALSE
)

my_atts <- list(
  mrm_config_name = "DNF with Salinity",
  description = "long description"
)

test_that("get_modelRunAttributes works", {
  expect_type(
    x <- rdf2rise:::get_modelRunAttributes(tst_df$dmi, tst_df$ruleset, my_atts),
    "character"
  )
  expect_length(x, 4)
  expect_identical(
    x[1],
    paste0(
      "Ruleset: rules.rls; ",
      "Input DMI: This and that; ",
      "MRM Config: DNF with Salinity; ",
      "MRM Desc: long description;"
    )
  )
  expect_identical(
    x[3],
    paste0(
      "Ruleset: rules.rls; ",
      "Input DMI: this; ",
      "MRM Config: DNF with Salinity; ",
      "MRM Desc: long description;"
    )
  )
})
