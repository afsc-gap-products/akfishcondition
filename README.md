# akfishcondition
This repository contains a package to calculate morphometric condition indicators (length-weight residuals) based on length-weight relationships. It also contains R markdown files for generating the Groundfish Condition Indicator chapters for the Aleutian Islands, Bering Sea, and Gulf of Alaska Ecosystem Status Report and juvenile and adult condition indicators for Ecosystem and Socioeconomic Profiles. 

The most recent version of this package was built in R 4.1.1.

# Installation

akfishcondition can be installed using the following code:

```{r}
devtools::install_github("sean-rohan-noaa/akfishcondition")
```

# Instructions for generating ESR chapters

Groundfish morphometric condition indicators are included in this repository as R Markdown (.Rmd) files. To generate ESR chapters from ESR files:

1. Install the akfishcondition package by following the installation instructions above.
2. Download the chapter .rmd file from the akfishcondition repository.
3. Set your working directory to the folder containing the .rmd files.
4. Knit .rmd files to .docx.

# Instruction for updating condition indicators and akfishcondition package

1. Clone the akfishcondition package to a local directory.
2. Set up an R Studio project in the local directory.
3. Open 0_update_condition_data.Rmd and follow instructions for updating akfishcondition with new data.
4. Update ESR condition indicator chapters (.Rmds) and ESP files.
5. Update DESCRIPTION with new version number.
6. Push akfishcondition update to GitHub.
7. Create new version, with version number corresponding with the version listed in DESCRIPTION.