#' A function to calculate length-weight residuals
#'
#' This function makes a log-log regression of length and weight for individual fish and then calculates a residual. A Bonferroni-corrected outlier correction can be applied to remove outliers. Option to use separate covariates for different strata.
#' 
#' @param length Set of individual fish lengths.
#' @param weight Corresponding set of individual fish weights.
#' @param stratum Stratum code for length-weight regression by stratum.
#' @param bias_correction Bias corrected residuals following Brodziak (2012)
#' @param outlier_rm Should outliers be removed using Bonferoni test (cutoff = 0.7)
#' @param make_diagnostics Output diagnostic plots and summaries? Default FALSE produces no diagnostics and summaries. If true, species_code and region should be specified.
#' @param species_code Species code (provide if make_diagnostics = TRUE)
#' @param region Region (provide if make_diagnostics = TRUE)
#' @param year Year (provide if make_diagnostics = TRUE)
#' @param include_ci Include upper and lower estimates for the 95 pct confidence interval of residuals in the output.
#' @details Brodziak, J.2012. Fitting length-weight relationships with linear regression using the log-transformed allometric model with bias-correction. Pacific Islands Fish. Sci. Cent., Natl. Mar. Fish. Serv., NOAA, Honolulu, HI 96822-2396. Pacific Islands Fish. Sci. Cent. Admin. Rep. H-12-03, 4 p.
#' @export

calc_lw_residuals <- function(len, 
                              wt, 
                              stratum = NA, 
                              bias_correction = TRUE, 
                              outlier_rm = FALSE, 
                              make_diagnostics = FALSE, 
                              species_code = NA, 
                              year = NA, 
                              region = NA,
                              include_ci = TRUE) {
  
  if(exists("outlier_rm")) {
    outlier_rm <- outlier_rm
  }
  
  if(exists("bias_correction")) {
    bias_correction <- bias_correction
  }
  
  loglen <- log(len)
  logwt <- log(wt)
  
  run_lw_reg <- function(logwt, loglen, stratum) {
    if(is.na(stratum)[1]) {
      lw.mod <-lm(logwt~loglen, na.action = na.exclude)
      fitted_df <- predict(lw.mod, newdata = data.frame(len = len), se.fit = TRUE) %>% 
        as.data.frame()
    } else {
      stratum <- factor(stratum)
      lw.mod <- lm(logwt~loglen:stratum, na.action = na.exclude)
      fitted_df <- predict(lw.mod, newdata = data.frame(len = len), se.fit = TRUE) %>% 
        as.data.frame()
    }
    
    return(list(mod = lw.mod, 
                fitted_df = fitted_df))
  }
  
  # Run length-weight regression
  lw.reg <- run_lw_reg(logwt = logwt, loglen = loglen, stratum = stratum)
  
  #Assessing Outliers using Bonferroni Outlier Test
  if(outlier_rm) {
    #Produce a Bonferroni value for each point in your data
    bonf_p <- car::outlierTest(lw.reg$mod,n.max=Inf,cutoff=Inf,order=FALSE)$bonf.p 
    remove <- which(bonf_p < .05)
    print("Outlier rows removed")
    logwt[remove] <- NA
    loglen[remove] <- NA
    
    # Rerun without outliers
    lw.reg <- run_lw_reg(logwt = logwt, loglen = loglen, stratum = stratum)
  } 
  
  # Apply bias correction factor
  if(bias_correction) {
    syx <- summary(lw.reg$mod)$sigma
    cf <- exp((syx^2)/2) 
    
    # Correction for mean and SE
    lw.reg$fitted_df$fit <- log(cf *(exp(lw.reg$fitted_df$fit)))
    lw.reg$fitted_df$lwr <- log(cf *(exp(lw.reg$fitted_df$fit - 2*lw.reg$fitted_df$se.fit)))
    lw.reg$fitted_df$upr <- log(cf *(exp(lw.reg$fitted_df$fit + 2*lw.reg$fitted_df$se.fit)))
    
  }
  
  # Residual with confidence intervals
  lw.reg$fitted_df$lw.res_mean <- (logwt - lw.reg$fitted_df$fit)
  lw.reg$fitted_df$lw.res_lwr <- (logwt - lw.reg$fitted_df$lwr)
  lw.reg$fitted_df$lw.res_upr <- (logwt - lw.reg$fitted_df$upr)
  
  # Make diagnostic plots ----
  if(make_diagnostics) {
    
    # Create output directory if it doesn't exist ----
    out_path <- paste0("./output/", region[1], "/")
    
    if(!dir.exists(paste0("./output/"))) {
      dir.create(paste0("./output/"))
    }
    
    
    if(!dir.exists(out_path)) {
      dir.create(out_path)
    }
    
    # Allow diagnostic plots for NA
    if(is.na(stratum[1])) {
      stratum <- rep("none", length(stratum))
    }
    
    # Sample sizes
    sample_size_df <- data.frame(year, stratum) %>%
      dplyr::group_by(year, stratum) %>%
      dplyr::summarise(n = n())
    
    sample_size_plot <- ggplot(data = sample_size_df, 
                               aes(x = year, 
                                   y = factor(stratum), fill = n, label = n)) + 
      geom_tile() + 
      geom_text() +
      scale_x_continuous(name = "Year") +
      scale_y_discrete(name = "Stratum") +
      scale_fill_distiller(palette = "Purples", direction = 1) +
      theme_bw()
    
    sample_prop_df <- data.frame(year, stratum) %>%
      dplyr::group_by(year) %>%
      dplyr::summarise(n_year  = n()) %>%
      dplyr::inner_join(sample_size_df) %>%
      dplyr::mutate(prop = round(100*n/n_year, 1),
                    prop_raw = n/n_year)
    
    sample_prop_plot <- ggplot(data = sample_prop_df,
                               aes(x = year, 
                                   y = prop_raw, 
                                   fill = factor(stratum))) +
      geom_bar(position = "stack", stat = "identity") +
      scale_x_continuous(name = "Year") +
      scale_y_continuous(name = "Proportion") +
      theme_bw()
      
      
    
    # RMSE by year and stratum
    rmse <- function(x) {
      return(mean(sqrt(x^2)))
    }
    
    rmse_df <- data.frame(lw.reg$fitted_df$lw.res_mean, stratum) %>%
      dplyr::group_by(stratum) %>%
      dplyr::summarise(RMSE = rmse(lw.reg$fitted_df$lw.res_mean))
    
    write.csv(rmse_df, file = paste0(out_path, region[1], "_", species_code[1], "_rmse.csv"), row.names = FALSE)
    
    rmse_plot <- ggplot() + 
      geom_point(data = rmse_df,
                 aes(x = stratum, 
                     y = RMSE), 
                 size = rel(1.3)) +
      scale_x_discrete(name = "Stratum") +
      scale_color_discrete(name = "Stratum") + 
      theme_bw()
    
    size_dist_plot <- ggplot(data = data.frame(len, stratum, year)) +
      geom_density(aes(x = len, color = factor(stratum))) +
      scale_color_discrete(name = "Stratrum") +
      scale_x_continuous(name = "Length (mm)") +
      scale_y_continuous(name = "Density") +
      facet_wrap(~year, ncol = 5) + 
      theme_bw()
    
    pdf(paste0(out_path, region[1], "_", species_code[1], "_diagnostic_plots.pdf"), 
        onefile = TRUE, width = 16, height = 8)
    print(sample_size_plot)
    print(sample_prop_plot)
    print(rmse_plot)
    print(size_dist_plot) 
    dev.off()
    
    pdf(paste0(out_path, region[1], "_", species_code[1], "_regression_diagnostics.pdf"), onefile = TRUE)
    par(mfrow = c(2,2))
    plot(lw.reg$mod)
    dev.off()
    
    sink(file = paste0(out_path,region[1], "_", species_code[1], "_model_summary.txt"))
    print(summary(lw.reg$mod))
    sink()
    
  }
  
  if(!include_ci) {
    return(lw.reg$fitted_df$lw.res_mean)
  } else {
    return(lw.reg$fitted_df)
  }
  
}