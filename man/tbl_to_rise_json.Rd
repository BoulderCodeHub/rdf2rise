% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tbl_to_rise_json.R
\name{tbl_to_rise_json}
\alias{tbl_to_rise_json}
\title{Convert a tbl_df to the RISE json format}
\usage{
tbl_to_rise_json(tbl)
}
\arguments{
\item{tbl}{A tbl_df with all required columns (objects for the RISE json
file).}
}
\value{
Invisibly returns data in RISE json format, currently just a
character vector of length == 1.
}
\description{
\code{tbl_to_rise_json()} converts a tbl_df to the RISE json format.
}
\details{
The RISE json format is a specific json format that (1) has one complete
object per row and (2) does not include any arrays. Each object on a row
contains 16 required object-value pairs. The provided \code{tbl} should have
column names that match the required json objects (see \link{rise_json_req_obj})
and the package
\href{https://github.com/BoulderCodeHub/rdf2rise}{GitHub site README}.
The function will error if this is not the case. It is probably best to
create the \code{tbl} using \code{\link[=rwtbl_add_rise_vars]{rwtbl_add_rise_vars()}}, but it is possible it
could be created some other way.
}
\examples{
ifile <- system.file(
  'extdata/Scenario/ISM1988_2014,2007Dems,IG,Most',
  "KeySlots.rdf",
 package = "RWDataPlyr"
)

# get the tbl using RWDataPlyr
rwtbl <- RWDataPlyr::rdf_to_rwtbl2(
  ifile,
  scenario = "test",
  keep_cols = rwtbl_cols_for_rise
)

# manually specify some parameters:
ui_vars <- list(
  sourceCode = "CRSS-TestData",
  modelNameSourceCode = "CRSS",
  status = "Finalized Dec. 2012. To RISE v0.0.1",
  modelRunDescription = "desc"
)

# get the rest of the parameters automatically
rise_tbl <- rwtbl_add_rise_vars(rwtbl, ui_vars)

# and then convert to the RISE json format
rise_json <- tbl_to_rise_json(rise_tbl)

}
