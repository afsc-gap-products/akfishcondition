% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vast_functions.R
\name{run_vast_condition}
\alias{run_vast_condition}
\title{Run VAST to estimate fish condition}
\usage{
run_vast_condition(
  x,
  n_knots = NULL,
  response = "count",
  fork_lengths_mm = NULL
)
}
\arguments{
\item{x}{data.frame containing species_code, region, ObsModel_1, ObsModel_2, ObsModel_3, and ObsModel_4.}

\item{n_knots}{Number of knots to use to generate the mesh. Default NULL = use n_knots from the input data.frame.}

\item{response}{"count" or "biomass"}

\item{fork_lengths_mm}{Optional. Lengths in millimeters to use. Passed to akfishcondition::select_species()}
}
\description{
Run VAST to estimate fish condition
}
\examples{
x <- dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, region == "EBS")
x <- dplyr::filter(x, species_code == 21740)
run_vast_condition(x = x, n_knots = 250)
}
