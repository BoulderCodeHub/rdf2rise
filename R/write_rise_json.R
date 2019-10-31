#' Write the RISE json object to disk
#'
#' `write_rise_json()` takes the json character object and writes the data to
#' the specified location. RISE requires a file format named
#' sourceCode_YYYYMMDDHHMMSSMS.json, so this function creates a file following
#' that naming convention. `sourceCode` is a field that exists in the json
#' character object, so it is used for the file name.
#'
#' @param x json character vector. Likely output from [`tbl_to_rise_json()`].
#'
#' @param path File path to save the file to. Should be an existing directory.
#'
#' @return Invisibly returns `x`. Saves `x` to `path` as .json file.
#'
#' @export

write_rise_json <- function(x, path)
{
  assert_that(length(path) == 1)
  assert_that(is.character(path))
  assert_that(dir.exists(path))
  assert_that(length(x) == 1)
  assert_that(is.character(x))

  # sourceCode does not vary by object, so get the first sourceCode object
  # and its value
  source_code <- parse_sourceCode(x)

  time_stamp <- Sys.time()
  # get the mili seconds
  time_stamp_ms <- parse_ms(time_stamp)
  # collapse together
  time_stamp <- collapse_time(time_stamp, time_stamp_ms)

  write(x, file.path(path, paste0(source_code, "_", time_stamp, ".json")))

  invisible(x)
}

# gets the miliseconds from the time and returns it as astring
parse_ms <- function(x)
{
  assert_that(length(x) == 1)

  ms <- round(as.numeric(x) * 100, 0) %% 100
  ms <- as.character(ms) %>%
    stringr::str_pad(2, pad = "0")
  ms
}

# takes the time and collapse down to yyyymmddhhmmss and appends ms
collapse_time <- function(x, ms)
{
  assert_that(length(x) == 1)

  strftime(x) %>%
    stringr::str_remove_all("-") %>%
    stringr::str_remove_all(" ") %>%
    stringr::str_remove_all(":") %>%
    paste0(ms)
}

# from the massive json string, get the first occurrence of the sourceCode
parse_sourceCode <- function(x)
{
  assert_that(length(x) == 1)

  stringr::str_extract(x, 'sourceCode\\"\\:\\"([^\\,]+)') %>%
    # now just key the value
    stringr::str_extract('\\:\\"([^\\,]+)') %>%
    stringr::str_replace_all(':', '') %>%
    stringr::str_replace_all('\\"', '')
}
