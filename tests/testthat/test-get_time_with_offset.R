library(lubridate)

tt <- ymd_hms("1983-11-05 06:15:45 UTC")
t1 <- force_tz(tt, tzone = "US/Pacific") # should be -8
t2 <- force_tz(tt, tzone = "Europe/Brussels") # should be +1
t3 <- force_tz(tt, tzone = "Australia/Queensland") # shoudl be +10
t4 <- force_tz(tt, tzone = "Pacific/Samoa") # should be -11

test_that("get_time_with_offset works", {
  expect_identical(
    rdf2rise:::get_time_with_offset(t1),
    "1983-11-05 06:15:45-08:00"
  )
  expect_identical(
    rdf2rise:::get_time_with_offset(t2),
    "1983-11-05 06:15:45+01:00"
  )

  expect_identical(
    rdf2rise:::get_time_with_offset(t3),
    "1983-11-05 06:15:45+10:00"
  )

  expect_identical(
    rdf2rise:::get_time_with_offset(t4),
    "1983-11-05 06:15:45-11:00"
  )
})
