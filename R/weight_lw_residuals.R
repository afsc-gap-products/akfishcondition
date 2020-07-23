#' A function to weight length-weight residuals by catch
#'
#' This function weights length-weight residuals by a catch column. This
#' catch can be CPUE from the tow where the fish was caught (most common) or
#' stratum CPUE or biomass. 
#' @param residual Residual that will be weighted by catch
#' @param year Year of sample must be the same length as the residuals
#' @param catch Catch for weighting residual (default = 1) must be the same length as residuals
#' @param stratum Vector of strata for weighting
#' @keywords length, weight, groundfish condition
#' @export
#' @examples

weight_lw_residuals <- function(residuals, year, stratum = NA, catch=1) {
  
  wtlw.res <- residuals
  
  if(length(catch) == 1){
    catch <- rep(1, length(residuals))
  }
  
  if(is.na(stratum)[1]) {
    
    unique_years <- unique(year)
    
    # Calculate residuals by year
    for(i in 1:length(unique_years)){
      year_ind <- which(year == unique_years[i])
      sel_resid <- residuals[year_ind]
      sel_catch <- catch[year_ind]
      var1 <- sel_resid * sel_catch
      var2 <- sum(sel_catch)
      var3 <- var1/var2*length(sel_catch)
      wtlw.res[year_ind] <- var3
    }
  } else {
    unique_years_stratum <- expand.grid(year = unique(year), stratum = unique(stratum))
    
    for(i in 1:nrow(unique_years_stratum)) {
      ind <- which(year == unique_years_stratum['year'] & stratum == unique_years_stratum['stratum'])
      sel_resid <- residuals[ind]
      sel_catch <- catch[ind]
      var1 <- sel_resid * sel_catch
      var2 <- sum(sel_catch)
      var3 <- var1/var2*length(sel_catch)
      wtlw.res[ind] <- var3
    }
  }
  
  return(wtlw.res)
}
