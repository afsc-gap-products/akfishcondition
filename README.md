# akfishcondition
This repository contains a package to calculate morphometric condition indicators (length-weight residuals) based on length-weight relationships. It also contains R markdown files for generating the Groundfish Condition Indicator chapters for the Aleutian Islands, Bering Sea, and Gulf of Alaska Ecosystem Status Report and juvenile and adult condition indicators for Ecosystem and Socioeconomic Profiles. 

The most recent version of this package was built in R 4.0.2.

# Installation

akfishcondition can be installed using the following code:

```{r}
devtools::install_github("sean-rohan-noaa/akfishcondition")
```

# Instructions for generating ESR chapters

To generate the chapters:

1. Install the akfishcondition package by following the installation intructions above.
2. Download the .rmd files from the akfishcondition repository.
3. Set your working directory to the folder containing the .rmd files.
4. Knit .rmd files to .docx.

If the. rmd knits successfully, the working directory will contain the following:
* Comma separated value (.csv) files containing data (length-weight and design-based index stratum biomass) used to calculated the condition indicator. 
* Model summaries and diagnostics in ~/output/.
* Length-weight residual figures and .csvs containing residuals.
* For 2020: Unweighted residuals for the EBS/NBS (2019), GOA (2019), AI (2018).