
# gets the time with offset from UTC
get_time_with_offset <- function(t1)
{
  t2 <- lubridate::force_tz(t1, "UTC")
  offset <- lubridate::interval(t1, t2) / lubridate::hours(1)
  
  # pad the offset with a zero, but have to treat negatives and positives 
  # differently
  if (offset < 0) {
    offset <- paste0(sprintf("%03d", offset), ":00")
  } else {
    offset <- paste0("+", sprintf("%02d", offset), ":00")
  }
  
  ct <- paste0(format(t1, "%Y-%m-%d %H:%M:%S", usetz = FALSE), offset)
  
  ct
}