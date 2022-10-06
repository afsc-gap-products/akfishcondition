#' Read-in VAST index outputs from .csv
#' 
#' Combines VAST index.csv files from the /results/region/ directory. 
#' 
#' @param region Region. AI, BS, or GOA. Character (1L).
#' @param years Vector of years to retain in index (i.e. survey years)
#' @return A data frame with condition indicators for all species.
#' @examples 
#' # Combine index.csv files for GOA
#' bundle_vast_condition(region = "GOA",
#' years = c(seq(1984, 1999, 3), 
#' seq(2001, 2022, 2)))
#' @export

bundle_vast_condition <- function(region, years) {

  region <- toupper(region)
  if(region == "BS") {
    region <- "EBS"
  }
  
  stopifnot("Invalid region in plot_anomaly_timeseries. Must be 'BS', 'AI', or 'GOA'"  = (region %in% c("BS", "NBS", "EBS", "AI", "GOA")))
  
  vast_condition_df <- data.frame()
  
  spp_folders <- list.files(here::here("results", region))
  
  for(jj in 1:length(spp_folders)) {
    if(file.exists(here::here("results", region, spp_folders[jj], "index.csv"))) {
      
      sel_spp_df <- read.csv(file = here::here("results", region, spp_folders[jj], "index.csv")) |>
        dplyr::filter(Category == "Condition (grams per cm^power)", 
                      Time %in% years) |>
        dplyr::mutate(species_code = as.numeric(spp_folders[jj])) |> 
        dplyr::rename(year = Time,
                      vast_condition = Estimate,
                      vast_condition_se = Std..Error.for.Estimate) |>
        dplyr::select(-Stratum, -Units, -Category, -Std..Error.for.ln.Estimate.)
      
      # Handle corner cases
      if(region == "EBS") {
        sel_spp_df <- sel_spp_df |>
          dplyr::filter(!(year == 2015 & species_code == 10285)) |>
          dplyr::filter(!(year == 2007 & species_code == 10110)) |>
          dplyr::filter(!(year == 2013 & species_code == 10110))
      }
      
      sel_spp_df <- sel_spp_df |>
        dplyr::mutate(scaled_vast_condition = scale(vast_condition)[,1],
                      vast_relative_condition = vast_condition/mean(vast_condition),
                      vast_relative_condition_se = vast_condition_se/mean(vast_condition))
      
      vast_condition_df <- dplyr::bind_rows(vast_condition_df, sel_spp_df)
    }
  }
  
  # Append common name
  vast_condition_df <- akfishcondition:::add_common_name(x = vast_condition_df) |>
    dplyr::select(-AI, -GOA, -EBS, -NBS)
  
  return(vast_condition_df)
  
}



#' Run VAST to estimate fish condition
#' 
#' 
#' @param x data.frame containing species_code, region, ObsModel_1, ObsModel_2, ObsModel_3, and ObsModel_4.
#' @param n_knots Number of knots to use to generate the mesh. Default NULL = use n_knots from the input data.frame.
#' @param response "count" or "biomass"
#' @param fork_lengths_mm Optional. Lengths in millimeters to use. Passed to akfishcondition::select_species()
#' @examples
#' x <- dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, region == "EBS")
#' x <- dplyr::filter(x, species_code == 21740)
#' run_vast_condition(x = x, n_knots = 250)
#' @export

run_vast_condition <- function(x, n_knots = NULL, response = "count", fork_lengths_mm = NULL) {
  
  library(VAST)
  
  stopifnot("run_vast_condition: x does not contain all of the required columns (species_code, region, ObsModel_1, ObsModel_2, ObsModel_3, ObsModel_4)" = all(c("species_code", "region", "ObsModel_1", "ObsModel_2", "ObsModel_3", "ObsModel_4") %in% names(x)))
  for(ii in 1:nrow(x)) 
  {
    
    region_VAST <- ifelse(x$region[ii] == "GOA", "gulf_of_alaska", 
                          ifelse(x$region[ii] == "AI", "aleutian_islands", 
                                 ifelse(x$region[ii] == "EBS","Eastern_Bering_Sea","Northern_Bering_Sea")))
    
    message(paste0("Optimizing ", x$species_code[ii], " in ", x$region[ii]))
    start_time <- Sys.time()
    dir.create(paste0(getwd(),"/results/", x$region[ii], "/", x$species_code[ii],"/"), recursive = TRUE)
    
    if(is.null(fork_lengths_mm)) {
      fork_lengths_mm <- c(x$fl_min[ii], x$fl_max[ii])
    }
    
    specimen_sub <- akfishcondition:::select_species(species_code = x$species_code[ii], 
                                                     region = x$region[ii],
                                                     fork_lengths_mm = fork_lengths_mm)
    
    # Exclude years without both weights and counts
    weight_and_n <- table(c(
      names(table(specimen_sub$year[specimen_sub$number_fish > 0])),
      names(table(specimen_sub$year[specimen_sub$weight_g> 0]))))
    
    specimen_sub <- specimen_sub[which(specimen_sub$year %in% as.numeric(names(weight_and_n)[which(weight_and_n == 2)])), ]
    
    # Format data
    ## turning length_mm into length_cm (and putting 1 as the length for any rows that were catch data - 
    ## aka just had a cpue and no length/weight measurement)
    catchability_data = data.frame( "length_cm" = ifelse(!is.na(specimen_sub[,'cpue_kg_km2']),
                                                         1, specimen_sub[,'length_mm']/10 ))
    
    ObsModel <- matrix(c(
      x$ObsModel_1[ii],
      x$ObsModel_2[ii],
      x$ObsModel_3[ii],
      x$ObsModel_4[ii]), nrow = 2, ncol = 2)
    
    # Make settings
    settings = make_settings( n_x = ifelse(is.null(n_knots), x$n_knots[ii], n_knots),
                              Region = region_VAST,
                              purpose = "condition_and_density",
                              bias.correct = FALSE,
                              ObsModel = ObsModel, 
                              knot_method = "grid" )
    
    ##changing default 2 for omega_1 and epsilon_1 from 2 to IID
    # settings$FieldConfig[c("Omega","Epsilon"),"Component_1"] = "IID"
    logit_obs_model <- matrix(c(2,1,3,3),nrow=2,ncol=2)
    if(ObsModel[1,2] == logit_obs_model[1,2])
    { 
      settings$FieldConfig[c("Omega","Epsilon"),1] <- 0
      settings$FieldConfig[c("Omega","Epsilon"),2] <-  "IID"
    }else{
      settings$FieldConfig[c("Omega","Epsilon"),1] <-  "IID"
      settings$FieldConfig[c("Omega","Epsilon"),2] <-  0
    }
    #settings$FieldConfig[c("Omega","Epsilon","Beta"),] =  matrix( c(2,"IID","IID",0,0,"IID"), byrow = TRUE )
    ##to weight biomass by 
    Expansion_cz = matrix( c( 0, 2, 0, 0 ), nrow=2, ncol=2 ) ##two for two categories (lengthed or not lenghted)
    
    n_i = ifelse( !is.na(specimen_sub[,'number_fish']), specimen_sub[,'number_fish'], specimen_sub[,'weight_g'] )
    c_i = ifelse( !is.na(specimen_sub[,'number_fish']), 0, 1 )
    specimen_sub$effort_km2[is.na(specimen_sub$effort_km2)] <- 1
    
    gc()
    #fit_model( b_i = as_units(X, "count"), ... )
    #where `as_units` is the function that defines the units-class explicitly
    if(response == "count") {
      # n_i = ifelse( !is.na(specimen_sub[,'number_fish']), specimen_sub[,'number_fish'], specimen_sub[,'weight_g'] )
      # c_i = ifelse( !is.na(specimen_sub[,'number_fish']), 0, 1 )
      # specimen_sub$effort_km2[is.na(specimen_sub$effort_km2)] <- 1
      
      fit = fit_model( settings = settings,
                       Lat_i = specimen_sub$latitude,
                       Lon_i = specimen_sub$longitude,
                       t_i = specimen_sub$year,
                       c_i = c_i, #categories (aka condition = 1, not condition = 0)
                       b_i = n_i, #number
                       #a_i = rep(1, nrow(specimen_sub)), #area_swept
                       a_i = specimen_sub$effort_km2, #area_swept
                       catchability_data = catchability_data, ##length data
                       Q2_formula= ~ log(length_cm),
                       # Q2config_k = c(3), # Spatially varying allometric slope (b) for the length-weight equation (W=a*L^b)
                       Expansion_cz = Expansion_cz, ##tells code to expand as weighted-average of biomass for length category (aka c = 1)
                       #getReportCovariance = TRUE,
                       run_model = TRUE,
                       test_fit = FALSE,
                       #getJointPrecision = TRUE,
                       "optimize_args" =list("lower"=-Inf,"upper"=Inf),
                       "working_dir" = paste0(getwd(),"/results/",x$region[ii],"/",x$species_code[ii],"/") #TMB argument (?fit_tmb)
      )
    }
    
    if(response == "biomass") {
      # Q_ik = matrix( ifelse(!is.na(specimen_sub[,'cpue_kg_km2']), 0, log(specimen_sub[,'length_mm']/10) ), ncol=1 )
      b_i = ifelse( !is.na(specimen_sub[,'cpue_kg_km2']), specimen_sub[,'cpue_kg_km2'], specimen_sub[,'weight_g'] )
      c_i = ifelse( !is.na(specimen_sub[,'cpue_kg_km2']), 0, 1 )
    
      fit = fit_model( settings = settings,
                       Lat_i = specimen_sub$latitude,
                       Lon_i = specimen_sub$longitude,
                       t_i = specimen_sub$year,
                       c_i = c_i, #categories (aka use for condition = 1, not = 0)
                       b_i = b_i, #biomass
                       #a_i = rep(1, nrow(specimen_sub)), #area_swept
                       a_i = specimen_sub$effort_km2, #area_swept
                       catchability_data = catchability_data, ##length data
                       Q2_formula= ~ log(length_cm),
                       Q2config_k = c(3), # Potential switch to make allometric weight-length a spatially varying term
                       Expansion_cz = Expansion_cz, ##tells code to expand as weighted-average of biomass for length category (aka c = 1)
                       #getReportCovariance = TRUE,
                       run_model = TRUE,
                       test_fit = FALSE,
                       #getJointPrecision = TRUE,
                       "optimize_args" =list("lower"=-Inf,"upper"=Inf),
                       "working_dir" = paste0(getwd(),"/results/",x$region[ii],"/",x$species_code[ii],"/") #TMB argument (?fit_tmb)
      )
    }
    # save the VAST model
    saveRDS(fit,file = paste0(getwd(),"/results/",x$region[ii],"/", x$species_code[ii], "/", x$species_code[ii], "_VASTfit.RDS"))
    
    # standard plots
    plot(fit,
         plot_set = c(3,20,21),
         category_names=c("Numbers","Condition (grams per cm^power)"),
         "working_dir" = paste0(getwd(),"/results/",x$region[ii],"/",x$species_code[ii],"/") )
    
    # plot( fit, plot_value = sd )
    # plot( fit,
    #       Yrange=c(NA,NA),
    #       category_names=c("Numbers","Condition (grams per cm^power)"),
    #       "working_dir" = paste0(getwd(),"/results/",x$region[ii],"/",x$species_code[ii],"/") )
    end_time <- Sys.time()
    message(paste0("Completion time: ", round(difftime(end_time, start_time)), " minutes"))
    
  }
}