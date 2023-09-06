# akfishcondition: Fish morphometric condition
This repository contains an R package for calculating morphometric condition indicators based on residuals of length-weight relationships. The package also includes functions to generate morphometric condition indicators using the R package VAST ([https://github.com/James-Thorson-NOAA/VAST](https://github.com/James-Thorson-NOAA/VAST)). The code in this repository generates Groundfish Morphometric Condition Indicators for the Aleutian Islands, Bering Sea, and Gulf of Alaska Ecosystem Status Report and juvenile and adult Pacific cod condition indicators for Ecosystem and Socioeconomic Profiles.

The most recent version of this package was built in R 4.3.1.

# Installation

akfishcondition can be installed using the following code:

```{r}
devtools::install_github("afsc-gap-products/akfishcondition")
```
Estimating morphometric condition using the VAST package requires installation of the VAST package. 

# Data products and data sets included in the package


<dl>
<dt><b>AI_INDICATOR</b></dt>
<dd><p>Data frame containing Aleutian Islands length-weight residual condition indicator based on AFSC summer bottom trawl survey data from 1986 to 2022.</p></dd>
<dt><b>GOA_INDICATOR</b></dt>
<dd><p>Data frame containing Gulf of Alaska length-weight residual condition indicator (years: 1984-2023).</p></dd>
<dt><b>EBS_INDICATOR</b></dt>
<dd><p>Data frame containing Eastern Bering Sea length-weight residual condition indicator based on AFSC summer bottom trawl survey data from 1999 to 2023.</p></dd>
<dt><b>NBS_INDICATOR</b></dt>
<dd><p>Data frame containing Northern Bering Sea length-weight residual condition indicator based on AFSC summer bottom trawl survey data from 2010 to 2023</p></dd>
<dt><b>PCOD_ESP</b></dt>
<dd><p>List containing data frames with adult and juvenile Pacific cod length-weight residual condition indicator from AFSC summer bottom trawl survey data from the eastern Bering Sea (1999-2023), Aleutian Islands (1986-2022), Gulf of Alaska (1984-2023). Length cut-offs between adults and juveniles are region-specific and based on Essential Fish Habitat thresholds.</p></dd>
</dl>

Fish length, weight, and design-based biomass index data are included in the package as external data sets that are accessible through system commands.


# Instructions for updating condition indicators and built-in data sets

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