% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_plots.R
\name{make_vast_table}
\alias{make_vast_table}
\title{Generate tables with b coefficient and VAST Settings}
\usage{
make_vast_table(region, write_table = TRUE)
}
\arguments{
\item{region}{One or more region as a character vector ("EBS", "NBS", "AI", "GOA")}

\item{write_table}{Should the table be written as a .csv file to /plots/[region]/[region]_VAST_summary_table.csv?}
}
\description{
Generate tables containing settings for VAST and the VAST estimate of the allometric slope of the length-weight (b in W = a*L^b) relationship.
}
