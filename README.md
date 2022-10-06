# akfishcondition
This repository contains an R package for calculating morphometric condition indicators (length-weight residuals) based on length-weight relationships and wrapper functions for estimating morphometric condition using the R package VAST ([https://github.com/James-Thorson-NOAA/VAST](https://github.com/James-Thorson-NOAA/VAST)). The code in this repository generates Groundfish Morphometric Condition Indicators for the Aleutian Islands, Bering Sea, and Gulf of Alaska Ecosystem Status Report and juvenile and adult Pacific cod condition indicators for Ecosystem and Socioeconomic Profiles. 

The most recent version of this package was built in R 4.1.3. Condition indicators estimated using VAST were produced with VAST 3.8.2, FishStatsUtils 2.11.0, INLA 21.11.22, and TMB 1.8.1.

# Installation

akfishcondition can be installed using the following code:

```{r}
devtools::install_github("afsc-gap-products/akfishcondition")
```

Estimating morphometric condition using the VAST package requires installation of the VAST package. 

# Instruction for updating condition indicators and built-in data sets

1. Clone the akfishcondition package to a local directory.
2. Set up an R Studio project in the local directory.
3. Open 0_update_condition_data.Rmd and follow instructions for updating akfishcondition with new data.
4. Update ESR condition indicator chapters (.Rmds) and ESP files.
5. Update DESCRIPTION with new version number.
6. Push akfishcondition update to GitHub.
7. Create new version, with version number corresponding with the version listed in DESCRIPTION.

# Instructions for generating ESR chapters

Groundfish morphometric condition indicators are included in this repository as R Markdown (.Rmd) files. To generate ESR chapters from ESR files:

1. Install the akfishcondition package by following the installation instructions above.
2. Download the chapter .rmd file from the akfishcondition repository.
3. Set your working directory to the folder containing the .rmd files.
4. Knit .rmd files to .docx