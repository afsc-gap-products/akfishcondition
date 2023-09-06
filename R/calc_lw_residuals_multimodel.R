#' Length-weight residuals from best linear regression among candidate models with 
#'
#' Fits 1 (no stratum or sex covariates), 4 (either no stratum or no sex covariates), or 15 (stratum and sex covariates) linear regression models to log-weight and log-length with varying combinations of stratum-specific and sex-specific coefficients for allometric slope and intercept terms. The most parsimonious model is selected based on AIC then length-weight residuals are calculated using the best-fit model. Can optionally remove outliers based on a Bonferroni test (outlier_rm = TRUE), bias correct log-weight predictions (bias_correction = TRUE), write regression diagnostics to /output/ directory (make_diagnostics = TRUE), and include confidence intervals for 
#' 
#' @param length Set of individual fish lengths.
#' @param weight Corresponding set of individual fish weights.
#' @param stratum Stratum code for length-weight regression by stratum.
#' @param sex Sex code for fish; convertible to a factor.
#' @param day_of_year Day of year as an integer.
#' @param bias_correct Bias corrected residuals following Brodziak (2012)
#' @param outlier_rm Should outliers be removed using Bonferroni test (cutoff = 0.7)
#' @param make_diagnostics Output diagnostic plots and summaries? Default FALSE produces no diagnostics and summaries. If true, species_code and region should be specified.
#' @param species_code Species code (provide if make_diagnostics = TRUE)
#' @param region Character vector for region (provide if make_diagnostics = TRUE)
#' @param year Numeric vector for year (provide if make_diagnostics = TRUE)
#' @param include_ci Include upper and lower estimates for the 95 pct confidence interval of residuals in the output.
#' @details Brodziak, J.2012. Fitting length-weight relationships with linear regression using the log-transformed allometric model with bias-correction. Pacific Islands Fish. Sci. Cent., Natl. Mar. Fish. Serv., NOAA, Honolulu, HI 96822-2396. Pacific Islands Fish. Sci. Cent. Admin. Rep. H-12-03, 4 p.
#' @export


calc_lw_residuals_multimodel <- function(len, 
                                         wt, 
                                         stratum = NULL, 
                                         sex = NULL, 
                                         day_of_year = NULL,
                                         year = NULL, 
                                         region = "all", 
                                         species_code = NA, 
                                         bias_correction = TRUE, 
                                         make_diagnostics = TRUE,
                                         outlier_rm = TRUE, 
                                         include_ci = TRUE,
                                         multiple_models = TRUE,
                                         ...) {
  
  
  ###
  # len = dat$length_mm[dat$species_code == spp_vec[i]]
  # wt = dat$weight_g[dat$species_code == spp_vec[i]]
  # sex = null_flag(use = use_sex, var = dat$sex[dat$species_code == spp_vec[i]])
  # year = dat$year[dat$species_code == spp_vec[i]]
  # day_of_year = null_flag(use = use_doy, var = dat$day_of_year[dat$species_code == spp_vec[i]])
  # stratum = null_flag(use = use_stratum, var = dat$survey_stratum[dat$species_code == spp_vec[i]])
  # make_diagnostics = TRUE # Make diagnostics
  # include_ci = FALSE
  # bias_correction = TRUE # Bias correction turned on
  # outlier_rm = TRUE # Outlier removal turned off
  # region = region
  # species_code = dat$species_code[dat$species_code == spp_vec[i]]
  ###
  
  if(exists("outlier.rm")) {
    outlier_rm <- outlier.rm
  }
  
  if(exists("bias.correction")) {
    bias_correction <- bias.correction
  }
  
  m_dat <- data.frame(len = len,
                      loglen = log(len),
                      wt = wt,
                      logwt = log(wt))
  
  
  if(!is.null(sex)) {
    m_dat$sex <- factor(sex)
  }
  
  if(!is.null(stratum)) {
    m_dat$stratum <- factor(stratum)
  }
  
  if(!is.null(day_of_year)) {
    m_dat$day_of_year <- day_of_year
  }
  
  if(!is.null(species_code)) {
    m_dat$species_code <- species_code
  }
  
  if(!is.null(year)) {
    m_dat$year <- year
  }
  
  if(!is.null(region)) {
    m_dat$region <- region
  }
  
  
  outlier_model <- lm(logwt ~ loglen, data = m_dat)
  
  # Outlier removal based on Bonferroni test
  remove <- NULL
  
  if(outlier_rm) {
    bonf_p <- car::outlierTest(outlier_model, n.max=Inf, cutoff=Inf, order=FALSE)$bonf.p
    remove <- which(bonf_p < .7)
  }
  
  if(length(remove) > 0 ) {
    print(paste0(length(remove), " outlier rows removed"))
    
    m_dat <- m_dat[-remove, ]
    
  }
  
  if(multiple_models) {
    
    mod_list <- vector(mode = "list", length = 1)
    
    # Fit models
    m_count <- 1
    
    mod_list[[m_count]] <- lm(logwt ~ loglen, na.action = na.exclude, data = m_dat)
    
    if(!is.null(day_of_year)) {
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen + day_of_year, na.action = na.exclude, data = m_dat)
    }
    
    if(!is.null(sex)) {
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen + sex + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:sex, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen*sex + 0, na.action = na.exclude, data = m_dat)
    }
    
    if(!is.null(stratum)) {
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen + stratum + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:stratum, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen*stratum + 0, na.action = na.exclude, data = m_dat)
    }
    
    if(!is.null(stratum) & !is.null(sex)) {
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen + stratum + sex + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen + stratum:sex + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:stratum + stratum*sex + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:sex + stratum + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:stratum + sex + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:stratum:sex + sex + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:stratum:sex + sex + stratum + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:stratum:sex + sex:stratum + 0, na.action = na.exclude, data = m_dat)
    }
    
    if(!is.null(day_of_year) & !is.null(sex)) {
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen + day_of_year + sex + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:sex + day_of_year + sex + 0, na.action = na.exclude, data = m_dat)
      
      m_count <- m_count + 1
      mod_list[[m_count]] <- lm(logwt ~ loglen:sex + day_of_year:sex + sex + 0, na.action = na.exclude, data = m_dat)
      
    }
    
    get_k <- function(x) {
      return(length(x$coefficients))
    }
    
    get_formula <- function(x) {
      return(deparse(formula(x)))
    }
    
    get_n <- function(x) {
      return(x$df.residual + x$rank)
    }
    
    # Compare models based on AIC
    mod_aic <- data.frame(mod = 1:length(mod_list),
                          formula = unlist(lapply(mod_list, get_formula)),
                          k = unlist(lapply(mod_list, get_k)),
                          n =  unlist(lapply(mod_list, get_n)),
                          AIC = unlist(lapply(mod_list, AIC))) |>
      dplyr::arrange(AIC)
    
    aic_table <- mod_aic
    
    while(any(mod_aic$AIC[which.min(mod_aic$AIC)] - mod_aic$AIC[-which.min(mod_aic$AIC)] > -2)) {
      mod_aic <- mod_aic[-which.min(mod_aic$AIC), ]
    }
    
    best_mod <- mod_list[[mod_aic$mod[which.min(mod_aic$AIC)]]]
    
  } else {
    
    if(is.null(stratum)) {
      best_mod <- lm(logwt ~ loglen, na.action = na.exclude, data = m_dat)
    } else {
      best_mod <- lm(logwt ~ loglen:stratum, na.action = na.exclude, data = m_dat)
    }
    
    aic_table <- NULL
    
  }
  
  if(bias_correction) {
    fitted_df <- dplyr::bind_cols(m_dat,  
                                  predict(best_mod, se.fit = TRUE) |> 
                                    as.data.frame() |>
                                    dplyr::select(-df)
    )
    
  }
  
  # Apply bias correction
  fitted_df$fit <- log(exp((fitted_df$residual.scale^2)/2) * (exp(fitted_df$fit)))
  fitted_df$lwr <- log(exp((fitted_df$residual.scale^2)/2) * (exp(fitted_df$fit - 2* fitted_df$se.fit)))
  fitted_df$upr <- log(exp((fitted_df$residual.scale^2)/2) * (exp(fitted_df$fit + 2* fitted_df$se.fit)))
  
  # Residual with confidence intervals
  fitted_df$lw.res_mean <- (fitted_df$logwt - fitted_df$fit)
  fitted_df$lw.res_lwr <- (fitted_df$logwt - fitted_df$lwr)
  fitted_df$lw.res_upr <- (fitted_df$logwt - fitted_df$upr)
  
  # Make diagnostic plots ----
  if(make_diagnostics) {
    
    # Create output directory if it doesn't exist ----
    out_path <- paste0("./output/", region[1], "/")
    
    if(!dir.exists(paste0("./output/"))) {
      dir.create(paste0("./output/"))
    }
    
    if(!dir.exists(out_path)) {
      dir.create(out_path, recursive = TRUE)
    }
    
    # Allow diagnostic plots for NA
    if(is.null(stratum)) {
      m_dat$stratum <- rep("none", nrow(m_dat))
    }
    
    # Save models
    saveRDS(object = mod_list, paste0(out_path, region[1], "_", species_code[1], "_models.rds"))
    
    write.csv(aic_table, 
              file = paste0(out_path,region[1], "_", species_code[1], "_aic_table.csv"),
              row.names = FALSE)
    
    # Sample sizes
    sample_size_df <- data.frame(year = m_dat$year, stratum = m_dat$stratum) %>%
      dplyr::group_by(year, stratum) %>%
      dplyr::summarise(n = dplyr::n())
    
    sample_size_plot <- ggplot(data = sample_size_df, 
                               aes(x = year, 
                                   y = factor(stratum), 
                                   fill = n, 
                                   label = n)) + 
      geom_tile() + 
      geom_text() +
      scale_x_continuous(name = "Year") +
      scale_y_discrete(name = "Stratum") +
      scale_fill_distiller(palette = "Purples", direction = 1) +
      theme_bw()
    
    sample_prop_df <- data.frame(year = m_dat$year, stratum = m_dat$stratum) %>%
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
    
    size_dist_plot <- ggplot(data = m_dat) +
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
    print(size_dist_plot) 
    dev.off()
    
    pdf(paste0(out_path, region[1], "_", species_code[1], "_regression_diagnostics.pdf"), onefile = TRUE)
    par(mfrow = c(2,2))
    plot(best_mod)
    dev.off()
    
    sink(file = paste0(out_path,region[1], "_", species_code[1], "_model_summary.txt"))
    print(summary(best_mod))
    sink()
    
  }
  
  if(!include_ci) {
    return(fitted_df$lw.res_mean)
  } else {
    return(fitted_df)
  }
  
}