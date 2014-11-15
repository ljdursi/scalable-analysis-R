#!/bin/bash
export RMDFILE="ScalableDataAnalysis-R"
Rscript -e "require(knitr); require(markdown); knit('$RMDFILE.Rmd', '$RMDFILE.md'); markdownToHTML('$RMDFILE.md', '$RMDFILE.html', options=c('use_xhml'))"
