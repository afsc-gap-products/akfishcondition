# Load packages
library(VAST)
library(tictoc)
library(akfishcondition)
# source(paste0(getwd(),"/R/select_species.R"))


species_by_region <- read.csv(file = system.file("/extdata/species_by_region.csv", package = "akfishcondition")) |>
  dplyr::filter(region == "AI", species_code != 21741)

# load data set
#example = load_example( data_set = "GOA_arrowtooth_condition_and_density" )
#example <- readRDS(paste0(getwd(),"/data/",species_code,"_Data_Geostat.rds"))
# species_code <- c(30420,30060,21740,10110,10261,10262,10130,21720)[3] #c(northern rockfish, POP, pollock, arrowtooth, northern rock sole, southern rock sole, flathead sole, pacific cod)
## EBS/NBS years: 1999 - present
## EBS/NBS species: pollock (>250mm), pollock (100-250mm), Pcod, northern rock sole, yellowfin, arrowtooth, plaice, flathead 
## AI/GOA years: 1984 - present
## AI/GOA species: pollock (>250mm), pollock (100-250mm), Pcod, arrowtooth, southern rock sole, duskies, northern rockfish, POP
# region <- c("GOA","AI","NBS","EBS")[4]
ii <- 7
for(ii in 1:nrow(species_by_region)) {
  
  region <- species_by_region$region[ii]
  species_code <- species_by_region$species_code[ii]
  
  region_VAST <- ifelse(region == "GOA", "gulf_of_alaska", ifelse(region == "AI", "aleutian_islands", ifelse(region == "EBS","Eastern_Bering_Sea","Northern_Bering_Sea")))
  dir.create(paste0(getwd(),"/results/",region,"/",species_code,"/"), recursive = TRUE)
  
  specimen_sub <- akfishcondition:::select_species(species_code = species_code, region = region)
  if(region == "EBS" | region == "NBS")
  {
    specimen_sub <- specimen_sub[which(specimen_sub$year >= 1999),]
  }
  
  specimen_sub$yday <- lubridate::yday(as.POSIXct(specimen_sub$start_time, tz = "America/Anchorage"))
  ## length in mm
  ## weight in g
  
  
  # Format data
  ## turning length_mm into length_cm (and putting 1 as the length for any rows that were catch data - 
  ## aka just had a cpue and no length/weight measurement)
  catchability_data = data.frame( "length_cm" = ifelse(!is.na(specimen_sub[,'cpue_kg_km2']),
                                                       1, specimen_sub[,'length_mm']/10 ),
                                  "yday" = ifelse(!is.na(specimen_sub[,'cpue_kg_km2']),
                                                       1, specimen_sub[,'yday']/10))
  Q_ik = matrix( ifelse(!is.na(specimen_sub[,'cpue_kg_km2']), 0, log(specimen_sub[,'length_mm']/10) ), ncol=1 )
  
  # Make settings
  settings = make_settings( n_x = 250, #1000
                            Region = region_VAST,
                            purpose = "condition_and_density",
                            bias.correct = FALSE,
                            ObsModel = matrix(c(2,1,4,4),nrow=2,ncol=2), 
                            knot_method = "grid" )
  
  ##changing default 2 for omega_1 and epsilon_1 from 2 to IID
  # settings$FieldConfig[c("Omega","Epsilon"),"Component_1"] = "IID"
  settings$FieldConfig[c("Omega","Epsilon"),1] = "IID"
  #settings$FieldConfig[c("Omega","Epsilon","Beta"),] =  matrix( c(2,"IID","IID",0,0,"IID"), byrow = TRUE )
  ##to weight biomass by 
  Expansion_cz = matrix( c( 0, 2, 0, 0 ), nrow=2, ncol=2 ) ##two for two categories (lengthed or not lenghted)
  
  
  b_i = ifelse( !is.na(specimen_sub[,'cpue_kg_km2']), specimen_sub[,'cpue_kg_km2'], specimen_sub[,'weight_g'] )
  c_i = ifelse( !is.na(specimen_sub[,'cpue_kg_km2']), 0, 1 )
  
  # Run model
  fit = fit_model( settings = settings,
                   Lat_i = specimen_sub$latitude,
                   Lon_i = specimen_sub$longitude,
                   t_i = specimen_sub$year,
                   c_i = c_i, #categories (aka use for condition = 1, not = 0)
                   b_i = b_i, #biomass
                   a_i = rep(1, nrow(specimen_sub)), #area_swept
                   catchability_data = catchability_data, ##length data
                   Q2_formula= ~ log(length_cm),
                   Q2config_k = c(3), # Potential switch to make allometric weight-length a spatially varying term
                   Expansion_cz = Expansion_cz, ##tells code to expand as weighted-average of biomass for length category (aka c = 1)
                   #getReportCovariance = TRUE,
                   run_model = FALSE,
                   "working_dir" = paste0(getwd(),"/results/",region,"/",species_code,"/")
                   #getJointPrecision = TRUE#,
                   #"optimize_args" =list("lower"=-Inf,"upper"=Inf) #TMB argument (?fit_tmb)
  )
  Map = fit$tmb_list$Map
  Map$lambda2_k = factor(NA)
  
  tic("model fitting")
  fit = fit_model( settings = settings,
                   Lat_i = specimen_sub$latitude,
                   Lon_i = specimen_sub$longitude,
                   t_i = specimen_sub$year,
                   c_i = c_i, #categories (aka use for condition = 1, not = 0)
                   b_i = b_i, #biomass
                   a_i = rep(1, nrow(specimen_sub)), #area_swept
                   catchability_data = catchability_data, ##length data
                   Q2_formula= ~ log(length_cm),
                   Q2config_k = c(3), # Potential switch to make allometric weight-length a spatially varying term
                   Expansion_cz = Expansion_cz, ##tells code to expand as weighted-average of biomass for length category (aka c = 1)
                   #getReportCovariance = TRUE,
                   Map = Map,
                   run_model = TRUE,
                   test_fit = FALSE,
                   #getJointPrecision = TRUE#,
                   "optimize_args" =list("lower"=-Inf,"upper"=Inf),
                   "working_dir" = paste0(getwd(),"/results/",region,"/",species_code,"/") #TMB argument (?fit_tmb)
  )
  # save the VAST model
  saveRDS(fit,file = paste0(getwd(),"/results/",region,"/",species_code,"/",species_code,"_VASTfit.RDS"))
  
  save <- toc()
  print(paste0("Completion time: ",round((as.numeric(save$toc) - as.numeric(save$tic))/60, digits = 1) , " minutes"))
  
  # standard plots
  
  error_check <- try(plot( fit,
        Yrange=c(NA,NA),
        category_names=c("Biomass","Condition (grams per cm^power)"),
        "working_dir" = paste0(getwd(),"/results/",region,"/",species_code,"/") ), silent = TRUE)
  
  if(class(error_check) == "try-error") {
    
  }
}
