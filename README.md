# akfishcondition
This repository contains a package to calculate morphometric condition indices for groundfishes collected during NOAA bottom trawl surveys in Alaska based on length-weight relationships.

The most recent version of this package was built in R 4.0.2.

# Installation

akfishcondition can be installed using the following code:

```{r}
devtools::install_github("sean-rohan-noaa/akfishcondition")
```

# Instructions to generate ESR chapters

This repository contains all of the files necessary to Groundfish Condition Indicator chapters for Aleutian Islands, Bering Sea, and Gulf of Alaska Ecosystem Status Reports. To generate the chapters:

1. Open R and install the akfishcondition package by following the installation intructions above.
2. Download the .rmd files from the akfishcondition repository.
3. Set your working directory to the folder containing the .rmd files.
4. Knit .rmd files to .docx.

If the. rmd knits successfully, the working directory will contain the following:
* Comma separated value (.csv) files containing data (length-weight and design-based index stratum biomass) used to calculated the condition indicator. 
* Unweighted residuals for the previous ESR: EBS (2019), GOA (2019), AI (2018).
* Model summaries and diagnostics in ~/output/.
* Length-weight residual figures and .csvs containing residuals.