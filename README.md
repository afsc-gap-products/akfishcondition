# akfishcondition
This package calculates fish condition indices based on length-weight relationships. Functions are based on GroundfishCondition package by Christoper N. Rooper (github.com/rooperc4/GroundfishCondition).

Modifications from CNR code are as follows: 
1. Function names have changed to facilitate testing.
2. Length-weight model fitting function (calc_lw_residuals) include options for stratum-specific slopes and bias correction for log-log models.
3. Residual weighting function can do weighting by haul within Year and weighting by Stratum x Year. 

The most recent version of this package was built in R 4.0.2.

# Installation

akfishcondition can be installed using the following code:

```{r}
devtools::install_github("sean-rohan-noaa/akfishcondition")
```