% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rwtbl_add_rise_vars.R
\name{rwtbl_add_rise_vars}
\alias{rwtbl_add_rise_vars}
\title{Add required RISE variables to rwtbl}
\usage{
rwtbl_add_rise_vars(rwtbl, ui_vars)
}
\arguments{
\item{rwtbl}{A tbl_df with expected columns. Likely this is output from
\code{\link[RWDataPlyr:rdf_to_rwtbl2]{RWDataPlyr::rdf_to_rwtbl2()}}}

\item{ui_vars}{User specified values (as a list) for the \code{sourceCode},
\code{modelNameSourceCode}, \code{status}, and \code{modelRunDescription} fields in the
RISE json file.}
}
\value{
tbl with all required objects for RISE json file as column names
}
\description{
\code{rwtbl_add_rise_vars()} takes in an rwtbl and adds in the variables required
for publication in RISE. It does so by converting variables from the rwtbl
to the corresponding required object name in the RISE json format. Some
columns some are constructed from one or more variables in the rwtbl, a
few must be provided by the user (\code{ui_vars}), and others are constructed
from attributes in the rwtbl. \code{\link{rwtbl_cols_for_rise}} includes all of the
columns that are required in the rwtbl for this function to work properly.
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

}
