# setup ----------------------
my_time <- as.POSIXct("1983-11-05 11:59:59", format = "%Y-%m-%d %H:%M:%S")
json_char <- '\"modelRunSourceCode\":\"DNF,CT,IG\",\"sourceCode\":\"CRSS-BasinStudy\",\"dateTime\":\"2012-12-31 12:00:00-07:00\"'
# TODO: add in test of actual json character from the test rdf data.

opath <- tempdir()

# write_rise_json -----------------------------
test_that("write_rise_json works", {
  expect_error(write_rise_json(json_char, "randompathnottoexist"))
  expect_error(write_rise_json(c(json_char, "afa"), "randompathnottoexist"))
  expect_error(write_rise_json(json_char, c(".", ".")))
  expect_error(write_rise_json(json_char))

  expect_identical(write_rise_json(json_char, opath), json_char)
  # TODO: update this - it should have the format as below, but it will be
  # based on the time the file was created, not the my_time variable.
  # expect_true(
  #   file.exists(file.path(opath, "CRSS-BasinStudy_198311051159599900.json"))
  # )
})

# parse_sourceCode ----------------------------

test_that("parse_sourceCode works", {
  expect_length(x <- rdf2rise:::parse_sourceCode(json_char), 1)
  expect_identical(x, "CRSS-BasinStudy")
})

# parse_ms --------------------------
test_that("parse_ms works", {
  expect_error(rdf2rise:::parse_ms(c(1, 43)))
  expect_length(x <- rdf2rise:::parse_ms(my_time), 1)
  expect_identical(x, "00")
  expect_length(rdf2rise:::parse_ms(Sys.time()), 1)
})

# collapse_time -----------------------------
test_that("collapse_time works", {
  expect_error(rdf2rise:::collapse_time(c(1, 2)))
  expect_length(x <- rdf2rise:::collapse_time(my_time, "99"), 1)
  expect_equal(nchar(x), 16)
  expect_identical("1983110511595999", x)
})

