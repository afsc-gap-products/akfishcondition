# akfishcondition: Fish morphometric condition
This repository contains an R package for calculating morphometric condition indicators based on the residuals of length-weight relationships. The package also includes wrapper functions to generate morphometric condition indicators using the R package VAST ([https://github.com/James-Thorson-NOAA/VAST](https://github.com/James-Thorson-NOAA/VAST)). The code in this repository generates Groundfish Morphometric Condition Indicators for the Aleutian Islands, Bering Sea, and Gulf of Alaska [Ecosystem Status Reports](https://www.fisheries.noaa.gov/alaska/ecosystems/ecosystem-status-reports-gulf-alaska-bering-sea-and-aleutian-islands) and juvenile and adult Pacific cod condition indicators for Ecosystem and Socioeconomic Profiles.

# Installation

akfishcondition can be installed using the following code:

```{r}
devtools::install_github("afsc-gap-products/akfishcondition")
```
Estimating morphometric condition using VAST package requires installation of the VAST package. 

# Morphometric condition indicators

# Data products in the package

Fish length, weight, and design-based biomass index data are included in the package as built-in data sets.

<dl>
<dt><b>AI_INDICATOR</b></dt>
<dd><p>Data frame containing Aleutian Islands length-weight residual condition indicator based on AFSC summer bottom trawl survey data from 1986 to 2024.</p></dd>
<dt><b>GOA_INDICATOR</b></dt>
<dd><p>Data frame containing Gulf of Alaska length-weight residual condition indicator (years: 1984-2023).</p></dd>
<dt><b>EBS_INDICATOR</b></dt>
<dd><p>Data frame containing Eastern Bering Sea length-weight residual condition indicator based on AFSC summer bottom trawl survey data from 1999 to 2025.</p></dd>
<dt><b>NBS_INDICATOR</b></dt>
<dd><p>Data frame containing Northern Bering Sea length-weight residual condition indicator based on AFSC summer bottom trawl survey data from 2010 to 2025</p></dd>
<dt><b>PCOD_ESP</b></dt>
<dd><p>List containing data frames with adult and juvenile Pacific cod length-weight residual condition indicator from AFSC summer bottom trawl survey data from the eastern Bering Sea (1999-2023), Aleutian Islands (1986-2022), Gulf of Alaska (1984-2025). Length cut-offs between adults and juveniles are region-specific and based on Essential Fish Habitat thresholds.</p></dd>
</dl>
