#!/bin/bash
Rscript -e "require(knitr); purl('ScalableDataAnalysis-R.Rmd',output='../R/Code-snippets.R');"
