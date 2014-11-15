Scalable Data Analysis in R
===================

R is a great environment for interactive analysis on your desktop, but when your data needs outgrow your 
personal computer, it's not clear what to do next.

This is material for a day-long tutorial on scalable data analysis in R.  It covers:

* A brief introduction to R for those coming from a Python background;
* The [bigmemory](http://cran.r-project.org/web/packages/bigmemory/index.html) package for out-of-core computation on large data matrices, with a simple physical sciences example;
* The standard parallel package, including what was the snow and multicore facilities, using [airline data](http://stat-computing.org/dataexpo/2009/the-data.html) as an example
* The [foreach](http://cran.r-project.org/web/packages/foreach/index.html) package, using airline data and simple stock data;
* The [Rdsm](http://cran.r-project.org/web/packages/Rdsm/index.html) package for shared memory; and
* a brief introduction to the powerful [pbdR](http://r-pbd.org) pacakges for extremely large-scale computation.

The presentation for the material, in R markdown (so including the sourcecode) is in the presentation directory; 
you can read the resulting presentation [as markdown here](presentation/ScalableDataAnalysis-R.md), or 
[as a PDF here]( https://github.com/ljdursi/scalable-analysis-R/blob/master/presentation/ScalableDataAnalysisInR.pdf?raw=true ).

The R code from the slides can be found in the R directory. 

Some data can be found in the data directory; but as you might expect in a workshop on scalable data analysis, the
files are quite large!  Mostly you can just find scripts for downloading the data; running make in the main directory
will pull almost everything down, but a little more work needs go to into automating some of the production of the
data products used.
