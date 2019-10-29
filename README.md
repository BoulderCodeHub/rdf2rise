rdf2rise
========================

<!-- badges: start -->
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/BoulderCodeHub/rdf2rise?branch=master&svg=true)](https://ci.appveyor.com/project/BoulderCodeHub/rdf2rise)  [![Travis build status](https://travis-ci.org/BoulderCodeHub/rdf2rise.svg?branch=master)](https://travis-ci.org/BoulderCodeHub/rdf2rise)  [![Codecov test coverage](https://codecov.io/gh/BoulderCodeHub/rdf2rise/branch/master/graph/badge.svg)](https://codecov.io/gh/BoulderCodeHub/rdf2rise?branch=master)
<!-- badges: end -->


## Overview

rdf2rise is a package to help translate [RiverWare<sup>TM</sup>](http://www.riverware.org) rdf files into the JSON files necessary to publish data to the Reclamation Information Sharing Environment (RISE). It is intended for pushing modeled data that is not stored in other Reclamation databases to the RISE data base. It works by making guesses about certain fields, so it can be used in a fully automatic fashion, but allows the user to easily override those gueses in a tidy process. 

## Installation

rdf2rise can be installed from GitHub:

```
# install.packages("devtools")
devtools::install_github("BoulderCodeHub/rdf2rise")
```

## Usage

## Log

## Disclaimer

This software is in the public domain because it contains materials that originally came from the U.S. Bureau of Reclamation, an agency of the United States Department of Interior.

Although this code has been used by Reclamation, no warranty, expressed or implied, is made by Reclamation or the U.S. Government as to the accuracy and functioning of the program and related program material nor shall the fact of distribution constitute any such warranty, and no responsibility is assumed by Reclamation in connection therewith.

This software is provided "AS IS."
