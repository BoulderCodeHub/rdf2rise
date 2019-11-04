rdf2rise
========================

<!-- badges: start -->
[![Appveyor build](https://ci.appveyor.com/api/projects/status/580nvuavt8c7mnar?svg=true)](https://ci.appveyor.com/project/rabutler-usbr/rdf2rise-63aa8) [![Travis build status](https://travis-ci.org/BoulderCodeHub/rdf2rise.svg?branch=master)](https://travis-ci.org/BoulderCodeHub/rdf2rise)  [![Codecov test coverage](https://codecov.io/gh/BoulderCodeHub/rdf2rise/branch/master/graph/badge.svg)](https://codecov.io/gh/BoulderCodeHub/rdf2rise?branch=master)
<!-- badges: end -->


## Overview

rdf2rise is a package to help translate [RiverWare<sup>TM</sup>](http://www.riverware.org) rdf files into the JSON files necessary to publish data to the Reclamation Information Sharing Environment (RISE). It is intended for pushing modeled data (specifically from RiverWare) that are not stored in other Reclamation databases to the RISE database. It works by making guesses about certain fields, so it can be used in a fully automatic fashion, but allows the user to easily override those gueses in a dplyr pipeline. 

## Installation

rdf2rise can be installed from GitHub:

```
# install.packages("devtools")
devtools::install_github("BoulderCodeHub/rdf2rise", build_vignettes = TRUE)
```

## Usage

The three main functions in rdf2rise provide a process to convert the rwtbl to the RISE json file and save it on your computer. Start with an rwtbl from `RWDataPlyr::rdf_to_rwtbl2()`.

- `rwtbl_add_rise_vars()` - convert the rwtbl to a tbl_df with all required RISE json objects
- `tbl_to_rise_json()` - convert a tbl_df to a character vector written in RISE json format
- `write_rise_json()` - save the data in the RISE json format, with the RISE required naming convention of the json file. 

The following sections present how `rwtbl_add_rise_vars()` creates the required json objects, and then provide a simple example of the process.

### Constructing json object from rwtbl

rdf2rise creates the necessary json file for RISE by converting an rwtbl (converted from an rdf file) to a json object as one long string. RISE requires 16 json objects to fully describe each entry in the database. rdf2rise creates these objects from the rwtbl and user input (`rwtbl_add_rise_vars()`). The table below summarizes the required json objects and what rwtbl variables are used to create them. **Link to RISE for full description of the json objects.** It is up to the user to ensure the RISE json object values created here match those they have provided to RISE in the data identification steps. The values created by `rwtbl_add_rise_vars()` can be overwritten before creating the RISE json object using `dplyr::mutate()` or similar (see `vignette('custom_object_values', package = 'rdf2rise')`).

| Required RISE json object | How is json object constructed? |
| --- | --- |
| `sourceCode` | User Input (UI) |
| `locationSourceCode` | = `rwtbl$ObjectName` |
| `dateTime` | = `rwtbl$Timestep`* |
| `result` | = `rwtbl$Value` |
| `status` | UI |
| `lastUpdate` | `Sys.time()` when `rwtbl_add_rise_vars()` is executed. |
| `resultAttributes` | `"null"` |
| `parameterSourceCode` | = `rwtbl$ObjectSlot` |
| `modelRunSourceCode` | = `rwtbl$Scenario` |
| `modelRunName` | = `rwtbl$Scenario` |
| `modelRunDescription` | UI |
| `modelRunAttributes` | from `rwtbl$InputDMINAme`, `rwtbl$RulesetFileName`, and `attributes(rwtbl)`** |
| `modelRunMemberSourceCode` | = `rwtbl$TraceNumber` |
| `modelRunMemberDesc` | `rwtbl$Scenario` and `rwtbl$TraceNumber`*** |
| `modelRunDateTime` | `attributes(rwtbl)$create_date)`**** |
| `modelNameSourceCode` | UI |

*Clarifying notes:*

\* All data being processed to date are for monthly data, so the `dateTime` field is being hard coded to 12:00:00 PM on the last day of the month, with a MST offset from GMT. This will be enhanced in future releases and is an [open issue](https://github.com/BoulderCodeHub/rdf2rise/issues/5).

** The `modelRunAttributes` object is constructed by pasting together the `InputDMIName` and`RulesetFileName` (filename only, not complete file path) variables/columns, along with the `mrm_config_name` and  `description` attributes of the rwtbl. `RWDataPlyr::rdf_to_rwtbl2()` sets these two attributes in the rwtbl from information RiverWare saves in the rdf file. `modelRunAttributes` is a character vector of key value pairs that are `;` seperated. Ex: `"Ruleset: rules.rls; Input DMI: Some input DMI; MRM Config: MRM Configuration; MRM Desc: a longer desription;"`.

*** `modelRunMemberDesc` is constructed as `Scenario - Trace N`, ex: `DNF,CT,IG - Trace 22`. 

**** RISE requires an offset from GMT, which is not output included from RiverWare. So, rdf2rise assumes that the GMT offset is the same for the model data as it is for the computer runing the rdf2rise code.

### Example process

The defults values of the json objects can be modified using `dplyr::mutate` or similar. See the "Cusomizing RISE json Object Values" (`vignette('custom_object_values', package = 'rdf2rise')`) vignette for an exmaple on modifying the default json objects values. 

1 - start with an rdf file and convert it to a rwtbl using RWDataPlyr.

```
library(RWDataPlyr)
library(dplyr)
library(rdf2rise)

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
```

2 - specify the user provided object values:

```
ui_vars = list(
  sourceCode = "CRSS-TestData",
  modelNameSourceCode = "CRSS",
  status = "Finalized Dec. 2012. To RISE v0.0.1",
  modelRunDescription = "desc"
)
```

3 - chain the rdf2rise functions together for a final result. Note, this example will add all slots that are found in the provided rdf file to the json file.

```
rwtbl %>% 
  # ** dplyr::filter() on ObjectSlot if you want to limit slots
  # or on other columns as desired
  
  # create the tbl with required RISE json objects
  rwtbl_add_rise_vars(ui_vars) %>%
  
  # ** dplyr::mutate() here to overwrite default values

  # and then convert to the RISE json format
  tbl_to_rise_json() %>%

  # finally write the file (replace tempdir())
  write_rise_json(path = tempdir())
```

## Log

- 2019-11-04: v0.1.0

## Disclaimer

This software is in the public domain because it contains materials that originally came from the U.S. Bureau of Reclamation, an agency of the United States Department of Interior.

Although this code has been used by Reclamation, no warranty, expressed or implied, is made by Reclamation or the U.S. Government as to the accuracy and functioning of the program and related program material nor shall the fact of distribution constitute any such warranty, and no responsibility is assumed by Reclamation in connection therewith.

This software is provided "AS IS."
