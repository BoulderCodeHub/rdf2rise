# setup ----------------------
my_time <- as.POSIXct("1983-11-05 11:59:59", format = "%Y-%m-%d %H:%M:%S")
json_char <- '\"modelRunSourceCode\":\"DNF,CT,IG\",\"sourceCode\":\"CRSS-BasinStudy\",\"dateTime\":\"2012-12-31 12:00:00-07:00\"'
source_code <- "CRSS-BasinStudy"
# .json file pattern:
file_pattern <- paste0(source_code, "_", "[0-9]{16}", ".json")

# TODO: add in test of actual json character from the test rdf data.
full_json <- scan(
  "../CRSS-BasinStudy_2019110110394311.json",
  what = character(),
  sep = "\n",
  quiet = TRUE
)

full_json <- paste(full_json, collapse = "\n")

opath <- tempdir()

# write_rise_json -----------------------------
test_that("write_rise_json works", {
  expect_error(write_rise_json(json_char, "randompathnottoexist"))
  expect_error(write_rise_json(c(json_char, "afa"), "randompathnottoexist"))
  expect_error(write_rise_json(json_char, c(".", ".")))
  expect_error(write_rise_json(json_char))
browser()
  expect_identical(write_rise_json(json_char, opath), json_char)

  # check that there is a file that matches the expected .json pattern
  files <- list.files(opath)
  expect_true(any(x <- stringr::str_detect(files, file_pattern)))
  file.remove(file.path(opath, files[x]))
  # do it a second time with full data
  expect_identical(write_rise_json(full_json, opath), full_json)

  # check that there is a file that matches the expected .json pattern
  files <- list.files(opath)
  expect_equal(sum(stringr::str_detect(files, file_pattern)), 1)
})

# parse_sourceCode ----------------------------

test_that("parse_sourceCode works", {
  expect_length(x <- rdf2rise:::parse_sourceCode(json_char), 1)
  expect_identical(x, source_code)

  expect_length(x <- rdf2rise:::parse_sourceCode(full_json), 1)
  expect_identical(x, source_code)
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

