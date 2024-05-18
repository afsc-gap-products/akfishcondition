#' Generate tables with b coefficient and VAST Settings
#' 
#' Generate tables containing settings for VAST and the VAST estimate of the allometric slope of the length-weight (b in W = a*L^b) relationship.
#' 
#' @param region One or more region as a character vector ("EBS", "NBS", "AI", "GOA")
#' @param write_table Should the table be written as a .csv file to /plots/{region{/{region}_VAST_summary_table.csv?
#' @export

make_vast_table <- function(region, write_table = TRUE) {
  
  library(VAST)

  output_region_dir <- c("BS", "BS", "AI", "GOA")[match(region, c("EBS", "NBS", "AI", "GOA"))]
  
  sel_region <- region
  
  sel_spp <- dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, 
                           region %in% sel_region )
  
  out_df <- data.frame()
  
  for(ii in 1:length(sel_spp)) {
    vast_file <- here::here("results", 
                            sel_spp$region[ii], 
                            sel_spp$species_code[ii],
                            paste0(sel_spp$species_code[ii], "_VASTfit.rds"))
    
    if(file.exists(vast_file)) {
      message("make_vast_tables: Reading VASTfit.rds for species ", sel_spp$species_code[ii], " in ", sel_spp$region[ii], ".")
      vast_fit <- readRDS(file = vast_file)
      
      if(!is.na(vast_fit$parameter_estimates$SD$par.fixed['log_sigmaPhi2_k'])) {
        bb <- vast_fit$parameter_estimates$SD$par.fixed['lambda2_k']
        se <- exp(vast_fit$parameter_estimates$SD$par.fixed['log_sigmaPhi2_k'])
      } else {
        fixed_summary <- summary(vast_fit$parameter_estimates$SD, "fixed")
        bb <- fixed_summary[which(row.names(fixed_summary) == "lambda2_k"), 1]
        se <- fixed_summary[which(row.names(fixed_summary) == "lambda2_k"), 2]
      }

      
      out_df <- dplyr::bind_rows(out_df,
                                 dplyr::bind_cols(sel_spp[ii,],
                                                  data.frame(b_est = bb,
                                                             b_se = se,
                                                             max_gradient = vast_fit$parameter_estimates['max_gradient']$max_gradient,
                                                             convergence_check = vast_fit$parameter_estimates['Convergence_check']$Convergence_check,
                                                             knots_match = vast_fit$spatial_list$n_x == sel_spp$n_knots[ii])))
      
    } else {
      warning("\nmake_vast_tables: VASTfit file for species ", sel_spp$species_code[ii], " in ", sel_spp$region[ii], " cannot be found in ", vast_file, "\n")
    }
  }
  
  if(write_table) {
    if(length(region) > 1) {
      out_loc <- here::here("plots", paste0(paste0(region, collapse = "_"), "_VAST_summary_table.csv"))
    } else {
      out_loc <- here::here("plots", output_region_dir, paste0(region, "_VAST_summary_table.csv"))
    }
    
    message("make_vast_tables: Writing table to ", out_loc)
    
    write.csv(x = out_df, file = out_loc, row.names = FALSE)
    
  }
  
  row.names(out_df) <- 1:nrow(out_df)
  
  return(out_df)
  
}