#' A function to calculate length-weight residuals
#'
#' This function makes a log-log regression of length and weight for individual fish and then calculates a residual. A Bonferroni-corrected outlier correction can be applied to remove outliers. Option to use separate covariates for different strata.
#' 
#' @param length Set of individual fish lengths.
#' @param weight Corresponding set of individual fish weights.
#' @param stratum Stratum code for length-weight regression by stratum.
#' @param bias.correct Bias corrected residuals following Brodziak (2012)
#' @param outlier.rm Should outliers be removed using Bonferoni test (cutoff = 0.7)
#' @keywords length, weight, groundfish condition
#' @references Brodziak, J.2012. Fitting length-weight relationships with linear regression using the log-transformed allometric model with bias-correction. Pacific Islands Fish. Sci. Cent., Natl. Mar. Fish. Serv., NOAA, Honolulu, HI 96822-2396. Pacific Islands Fish. Sci. Cent. Admin. Rep. H-12-03, 4 p.

calc_lw_residuals <- function(len, wt, stratum = NA, bias.correction = TRUE, outlier.rm=FALSE) {
  
  loglen <- log(len)
  logwt <- log(wt)
  
  run_lw_reg <- function(logwt, loglen, stratum) {
    if(is.na(stratum)[1]) {
      lw.mod <-lm(logwt~loglen, na.action = na.exclude)
      fitted_wt <- predict(lw.mod, newdata = data.frame(len = len)) 
    } else {
      stratum <- factor(stratum)
      lw.mod <- lm(logwt~loglen:stratum, na.action = na.exclude)
      fitted_wt <- predict(lw.mod, newdata = data.frame(len = len, stratum = stratum)) 
    }
    
    return(list(mod = lw.mod, fitted_wt  = fitted_wt))
  }
  
  # Run length-weight regression
  lw.reg <- run_lw_reg(logwt = logwt, loglen = loglen, stratum = stratum)
  
  length(lw.reg$fitted_wt)
  
  #Assessing Outliers using Bonferroni Outlier Test
  #Identify if there are any outliers in your data that exceed cutoff = 0.05 (default)
  if(outlier.rm) {
    #Produce a Bonferroni value for each point in your data
    bonf_p <- car::outlierTest(lw.reg$mod,n.max=Inf,cutoff=Inf,order=FALSE)$bonf.p 
    remove <- which(bonf_p < .7)
    print("Outlier rows removed")
    logwt[remove] <- NA
    loglen[remove] <- NA
    
    # Rerun without outliers
    lw.reg <- run_lw_reg(logwt = logwt, loglen = loglen, stratum = stratum)
  } 
  
  # Apply bias correction factor
  if(bias.correction) {
    syx <- summary(lw.reg$mod)$sigma
    cf <- exp((syx^2)/2) 
    lw.reg$fitted_wt <- log(cf *(exp(lw.reg$fitted_wt)))
  }
  
  lw.res <- (logwt - lw.reg$fitted_wt)
  
  return(lw.res)
}