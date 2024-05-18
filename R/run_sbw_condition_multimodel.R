#' Run stratum-biomass-weighted condition for EBS, NBS, AI, and GOA
#' 
#' Wrapper function for running SBW condition using calc_lw_residuals_multimodel().
#' 
#' @param region Region as a character vector ("EBS", "NBS", "AI", or "GOA")
#' @param stratum_col Optional. Name of the stratum column as a character vector.
#' @param biomass_col Optional. Name of the biomass column as a charcater vector.
#' @param cod_juv_cutoff_mm Optional. Fork length cutoff for adult and juvenile.
#' @param covariates_to_use Character vector indicating which variables to use ('sex', 'day_of_year', 'stratum').
#' @param min_n Minimum number of samples for data from a stratum to be included in condition indicator calculations. Default = 10.
#' @noRd

run_sbw_condition_multimodel <- function(region,
                                         stratum_col = NULL, 
                                         biomass_col = NULL, 
                                         cod_juv_cutoff_mm = NULL, 
                                         covariates_to_use = c('sex', 'day_of_year', 'stratum'), 
                                         min_n = 10) {
  
  region_index <- match(region, c("AI", "EBS", "NBS", "GOA"))
  
  null_flag <- function(use, var) {
    return(unlist(ifelse(use, list(var), list(NULL))))
  }
  
  use_doy <- use_sex <- use_stratum <- FALSE
  
  if("day_of_year" %in% covariates_to_use) {
    use_doy <- TRUE
  }
  
  if("sex" %in% covariates_to_use) {
    use_sex <- TRUE
  }
  
  if("stratum" %in% covariates_to_use) {
    use_stratum <- TRUE
  }
  
  if(is.null(cod_juv_cutoff_mm)) {
    cod_juv_cutoff_mm <- c(460, 460, 460, 420)[region_index]
  }
  
  if(is.null(stratum_col)) {
    stratum_col <- c("inpfc_stratum", "stratum", "stratum", "inpfc_stratum")[region_index]
  }
  
  if(is.null(biomass_col)) {
    biomass_col <- "biomass"
  }
  
  biomass <- read.csv(file = here::here("data",  paste0(region, "_stratum_biomass_all_species.csv")))
  names(biomass)[which(names(biomass) == stratum_col)] <- "survey_stratum"
  names(biomass)[which(names(biomass) == biomass_col)] <- "stratum_biomass"
  
  lw <- read.csv(file = here::here("data", paste0(region, "_all_species.csv")))
  
  lw$start_time <- as.POSIXct(lw$start_time)
  lw$day_of_year <- lubridate::yday(lw$start_time)
  
  if(region == "EBS") {
    lw <- lw |>
      dplyr::filter(stratum < 70) |>
      dplyr::mutate(stratum = floor(stratum/10)*10)
  }
  
  lw <- lw |> 
    dplyr::filter(!is.na(length_mm)) |>
    dplyr::mutate(ID = paste(cruise, vessel, haul, specimenid, sep = "_"))
  
  names(lw)[which(names(lw) == stratum_col)] <- "survey_stratum"
  
  nsamp <- table(lw$survey_stratum, lw$common_name) |>
    as.data.frame() |>
    dplyr::rename(n_raw = Freq)
  
  dat <- lw |> 
    dplyr::inner_join(biomass,
                      by = c("year", "species_code", "survey_stratum")) |>
    dplyr::select(-vessel, -cruise, -haul, -hauljoin)
  
  # Checks (stratum count match should be TRUE)
  
  qc_df <- table(dat$survey_stratum, dat$common_name) |> 
    as.data.frame() |>
    dplyr::rename(n_filtered = Freq) |>
    dplyr::inner_join(nsamp) |>
    dplyr::mutate(equal = n_filtered == n_raw)
  
  count_match <- sum(qc_df$equal) == nrow(qc_df)
  message(paste0(region, " stratum count match: ", count_match))
  message(paste0("Year range: ", min(dat$year), "-",  max(dat$year)))
  
  raw <- list(LW = lw,
              BIOMASS = biomass,
              AKFISHCONDITION_VERSION = utils::packageVersion("akfishcondition"),
              LAST_UPDATE = Sys.Date())
  
  message("Splitting Pacific cod and pollock for ESP and ESR length cutoffs.")
  
  # Create separate data.frames for adult and juvenile pollock and cod
  pcod <- dat |> dplyr::filter(species_code == 21720)
  pcod$species_code[pcod$length < cod_juv_cutoff_mm] <- 21721
  pcod$species_code[pcod$length >= cod_juv_cutoff_mm] <- 21722
  pcod$common_name[pcod$species_code == 21721] <- "Pacific cod (juvenile)"
  pcod$common_name[pcod$species_code == 21722] <- "Pacific cod (adult)"
  pollock <- dplyr::filter(dat, species_code == 21740)
  dat$species_code[dat$species_code == 21740 & dat$length_mm >= 100 & dat$length_mm <= 250] <- 21741
  dat$common_name[dat$species_code == 21741] <- "walleye pollock (100-250 mm)"
  dat$species_code[dat$species_code == 21740] <- 21742
  dat$common_name[dat$species_code == 21742] <- "walleye pollock (>250 mm)"
  
  # Bind adult and juvenile pollock and cod to dat
  dat <- dplyr::bind_rows(dat, pollock)
  dat <- dplyr::bind_rows(dat, pcod)
  
  spp_vec <- unique(dat$species_code)
  
  # Calculate length weight residuals
  for(i in 1:length(spp_vec)) {
    
    # Separate slope for each stratum. Bias correction according to Brodziak, no outlier detection.
    raw_resid_df <- akfishcondition::calc_lw_residuals_multimodel(
      len = dat$length_mm[dat$species_code == spp_vec[i]], 
      wt = dat$weight_g[dat$species_code == spp_vec[i]], 
      sex = null_flag(use = use_sex, var = dat$sex[dat$species_code == spp_vec[i]]),
      year = dat$year[dat$species_code == spp_vec[i]],
      day_of_year = null_flag(use = use_doy, var = dat$day_of_year[dat$species_code == spp_vec[i]]),
      stratum = null_flag(use = use_stratum, var = dat$survey_stratum[dat$species_code == spp_vec[i]]),
      make_diagnostics = TRUE, # Make diagnostics
      bias_correction = TRUE, # Bias correction turned on
      outlier_rm = TRUE, # Outlier removal turned off
      region = region,
      species_code = dat$species_code[dat$species_code == spp_vec[i]]
    )
    
    dat$resid_mean[dat$species_code == spp_vec[i]] <- raw_resid_df$lw.res_mean
    dat$resid_lwr[dat$species_code == spp_vec[i]] <- raw_resid_df$lw.res_lwr
    dat$resid_upr[dat$species_code == spp_vec[i]] <- raw_resid_df$lw.res_upr
    
  }
  
  # Estimate mean and std. err for each stratum, filter out strata with less than min_n samples
  stratum_resids <- dat |> 
    dplyr::group_by(common_name, year, species_code, survey_stratum, stratum_biomass) |>
    dplyr::summarise(stratum_resid_mean = mean(resid_mean),
                     stratum_resid_sd = sd(resid_mean),
                     n = n()) |>
    dplyr::filter(n >= min_n) |>
    dplyr::mutate(stratum_resid_se = stratum_resid_sd/sqrt(n))
  
  # Weight strata by biomass
  for(i in 1:length(spp_vec)) {
    stratum_resids$weighted_resid_mean[stratum_resids$species_code == spp_vec[i]] <- 
      weight_lw_residuals(residuals = stratum_resids$stratum_resid_mean[stratum_resids$species_code == spp_vec[i]], 
                          year = stratum_resids$year[stratum_resids$species_code == spp_vec[i]], 
                          stratum = stratum_resids$survey_stratum[stratum_resids$species_code == spp_vec[i]], 
                          stratum_biomass = stratum_resids$stratum_biomass[stratum_resids$species_code == spp_vec[i]])
    stratum_resids$weighted_resid_se[stratum_resids$species_code == spp_vec[i]] <- 
      weight_lw_residuals(residuals = stratum_resids$stratum_resid_se[stratum_resids$species_code == spp_vec[i]], 
                          year = stratum_resids$year[stratum_resids$species_code == spp_vec[i]], 
                          stratum = stratum_resids$survey_stratum[stratum_resids$species_code == spp_vec[i]], 
                          stratum_biomass = stratum_resids$stratum_biomass[stratum_resids$species_code == spp_vec[i]])
  }
  
  # Biomass-weighted residual and SE by year
  ann_mean_resid_df <- stratum_resids |> 
    dplyr::group_by(year, common_name) |>
    dplyr::summarise(mean_wt_resid = mean(weighted_resid_mean),
                     se_wt_resid = mean(weighted_resid_se))
  
  stratum_resids <- stratum_resids |>
    dplyr::select(-stratum_biomass, - stratum_resid_sd)
  
  names(stratum_resids)[which(names(stratum_resids) == "survey_stratum")] <- stratum_col
  
  names(biomass)[which(names(biomass) == "survey_stratum")] <- stratum_col
  names(lw)[which(names(lw) == "survey_stratum")] <- stratum_col
  names(biomass)[which(names(biomass) == "stratum_biomass")] <- biomass_col
  
  stratum_resids <- stratum_resids |>  dplyr::ungroup() |> dplyr::select(-species_code)
  
  return(list(full_sbw = ann_mean_resid_df,
              stratum_sbw = stratum_resids,
              input_data = list(LW = lw,
                                BIOMASS = biomass,
                                AKFISHCONDITION_VERSION = utils::packageVersion("akfishcondition"),
                                LAST_UPDATE = Sys.Date())))
}