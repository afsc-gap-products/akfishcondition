#' A function to weight length-weight residuals by catch
#'
#' This function weights length-weight residuals by a catch column. This
#' catch can be CPUE from the tow where the fish was caught (most common) or
#' stratum CPUE or biomass. 
#' @param residuals Residual that will be weighted by catch
#' @param year Year of sample must be the same length as the residuals
#' @param catch Catch for weighting residual (default = 1) must be the same length as residuals
#' @param stratum Vector of strata for weighting
#' @param stratum_area Stratum area in hectares
#' @keywords length, weight, groundfish condition
#' @export
#' @examples

weight_lw_residuals <- function(residuals, year, stratum = NA, stratum_area = NA, catch = 1) {
  
  wtlw.res <- residuals
  
  if(length(catch) == 1){
    catch <- rep(1, length(residuals))
  }
  
  if(is.na(stratum)[1]) {
    
    unique_years <- unique(year)
    
    # Calculate residuals by year (Pre-2020 morphometric condition index approach)
    for(i in 1:length(unique_years)){
      year_ind <- which(year == unique_years[i])
      sel_resid <- residuals[year_ind]
      sel_catch <- catch[year_ind]
      var1 <- sel_resid * sel_catch
      var2 <- sum(sel_catch)
      var3 <- var1/var2*length(sel_catch)
      wtlw.res[year_ind] <- var3
    }
  } else if(!is.na(stratum)[1] & is.na(stratum_area)) {
    # Calculate residuals by stratum without biomass expansion by stratum area (CR's code)
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
  } else {
    # Stratum biomass expansion based on Wakabayashi index estimator
    stratum <- c(c(1,1,2,2), c(1,1,2,2))
    year <- c(rep(2018,4), rep(2019,4))
    stratum_area <- c(c(10,10,20,20),c(10,10,20,20))
    cpue <- c(c(10,20,10,20),c(1,2,1,2))
    residuals <- c(c(0.1, 0.1, 0.5, 0.5), c(0.1, 0.1, 0.5, 0.5))
    
    # Calculate stratum area by proportion
    df_stratum <- data.frame(stratum, stratum_area) %>%
      unique() %>%
      dplyr::mutate(stratum_prop = stratum_area/sum(stratum_area)) %>%
      dplyr::select(stratum, stratum_prop)
    
    # Calculate Wakabayashi biomass estimator
    df_cpue <- data.frame(cpue, stratum, year, stratum_area, residuals = residuals) %>%
      dplyr::group_by(stratum, year) %>%
      dplyr::summarise(stratum_area = mean(stratum_area), 
                       cpue = mean(cpue),
                       n = n(),
                       residuals = mean(residuals)) %>%
      dplyr::mutate(cpue_var = (ifelse(n() <= 1, 0, var(cpue)/n))) %>%
      dplyr::inner_join(df_stratum) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(weighted_biomass = cpue * stratum_prop,
                    weighted_var = cpue_var * stratum_prop)
      
    # Weight residuals by proportion of biomass in the stratum
    df_residuals <- df_cpue %>%
      dplyr::group_by(year) %>%
      dplyr::mutate(prop_biomass = weighted_biomass / sum(weighted_biomass)) %>%
      dplyr::mutate(stratum_weighted_residual = residuals * prop_biomass) %>%
      dplyr::select(stratum, year, stratum_weighted_residual)
    
    wt.lwres <- df_residuals
    
  }
  
  return(wtlw.res)
}
