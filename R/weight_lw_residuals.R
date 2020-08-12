#' A function to weight length-weight residuals by catch
#'
#' This function weights length-weight residuals by a catch column. This
#' catch can be CPUE from the tow where the fish was caught (most common) or
#' stratum CPUE or biomass. 
#' @param residuals Residual that will be weighted by catch
#' @param year Year of sample must be the same length as the residuals
#' @param catch Catch for weighting residual (default = 1) must be the same length as residuals
#' @param stratum Vector of strata for weighting
#' @param stratum_biomass Biomass in kg for the stratum.
#' @keywords length, weight, groundfish condition
#' @export
#' @examples

weight_lw_residuals <- function(residuals, year, stratum = NA, stratum_biomass = NA, catch = 1) {
  
  wtlw.res <- residuals
  
  if(length(catch) == 1){
    catch <- rep(1, length(residuals))
  }
  
  if(is.na(stratum)[1]) {
    
    unique_years <- unique(year)
    
    # Calculate residuals by year with stratum weighting by catch (CNR's code)
    for(i in 1:length(unique_years)){
      year_ind <- which(year == unique_years[i])
      sel_resid <- residuals[year_ind]
      sel_catch <- catch[year_ind]
      var1 <- sel_resid * sel_catch
      var2 <- sum(sel_catch)
      var3 <- var1/var2*length(sel_catch)
      wtlw.res[year_ind] <- var3
    }
  } else if(!is.na(stratum)[1] & is.na(stratum_biomass)) {
    # Calculate residuals by stratum without biomass expansion by stratum area 
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
    # 2020 ESR: Calculate residuals by stratum with biomass-weighted expansion (2020 ESR)
    # stratum_biomass <- c(rep(0.5,4), c(0.25, 0.25, 1.5, 1.5))
    # residuals <- c(c(0.05, 0.05, 0.5, 0.5), c(0.05, 0.05, 0.5, 0.5))
    # year <- c(rep(2018,4), rep(2019,4))
    # stratum <- c(c(1,1,2,2), c(1,1,2,2))
    
    biomass_df <- data.frame(stratum_biomass, stratum, year) %>% 
      unique()
    
    biomass_proportion_df <- biomass_df %>% 
      dplyr::group_by(year) %>%
      dplyr::summarise(year_biomass = sum(stratum_biomass)) %>%
      dplyr::inner_join(biomass_df) %>%
      dplyr::mutate(stratum_weight = stratum_biomass/year_biomass) %>%
      dplyr::select(year, stratum, stratum_weight)
    
    residuals_df <- data.frame(residuals, 
                               year, 
                               stratum) %>% 
      dplyr::inner_join(biomass_proportion_df) %>%
      dplyr::mutate(weighted_residuals = residuals * stratum_weight)
    
    wtlw.res <- residuals_df$weighted_residuals
      
  }
  
  return(wtlw.res)
}
