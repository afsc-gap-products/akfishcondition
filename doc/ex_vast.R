# Running VAST condition
# Example of how to run VAST condition in R

# Load library
library(akfishcondition)

# Get data from RACEBASE
akfishcondition::get_condition_data(channel = NULL)

# Jim's example:
# https://github.com/James-Thorson-NOAA/VAST/wiki/Correlations-between-fish-condition-and-density

n_knots <- 200 # Number of knots to use for VAST
species_code <- 10210
region_esr <- "EBS"

region_VAST <- ifelse(region_esr == "GOA", "gulf_of_alaska", 
                      ifelse(region_esr == "AI", "aleutian_islands", 
                             ifelse(region_esr == "EBS","Eastern_Bering_Sea","Northern_Bering_Sea")))

# Create a directory to save results
dir.create(paste0(getwd(),"/results/",region_esr,"/",species_code,"/"),
           recurive = TRUE)


# EBS ... let's try ATF and YFS
specimen_sub <- akfishcondition:::select_species(species_code = species_code, 
                               region = region_esr)

# Format data
## turning length_mm into length_cm (and putting 1 as the length for any rows that were catch data - 
## aka just had a cpue and no length/weight measurement)
data_df = data.frame( "length_cm" = ifelse(!is.na(specimen_sub[,'cpue_kg_km2']),
                                           1, specimen_sub[,'length_mm']/10 ))


# Observation model matrix (?VAST::make_data)
# ObsModel <- matrix(c(2,1,3,3),nrow=2,ncol=2) # Delta-gamma; delta-lognormal conventional delta model
ObsModel <- matrix(c(2,1,4,4),nrow=2,ncol=2) # Delta-gamma; delta-lognormal Poisson-link delta model

# Make settings
settings = make_settings( n_x = n_knots,
                          Region = region_VAST,
                          purpose = "condition_and_density",
                          bias.correct = FALSE,
                          ObsModel = ObsModel, 
                          knot_method = "grid" )

# Setup variables
n_i = ifelse( !is.na(specimen_sub[,'number_fish']), specimen_sub[,'number_fish'], specimen_sub[,'weight_g'] ) # Catch in numbers
c_i = ifelse( !is.na(specimen_sub[,'number_fish']), 0, 1 ) # Data a density or condition observation
specimen_sub$effort_km2[is.na(specimen_sub$effort_km2)] <- 1 # Effort for condition = 1

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
##to weight biomass by; 2 = calculates a weighted average of local condition weighted by local density.
Expansion_cz = matrix( c( 0, 2, 0, 0 ), nrow=2, ncol=2 ) 


#fit_model( b_i = as_units(X, "count"), ... )
#where `as_units` is the function that defines the units-class explicitly
fit = fit_model( settings = settings,
                 Lat_i = specimen_sub$latitude,
                 Lon_i = specimen_sub$longitude,
                 t_i = specimen_sub$year,
                 c_i = c_i, #categories (aka use for condition = 1, not = 0)
                 b_i = n_i, #number
                 a_i = specimen_sub$effort_km2, #area_swept
                 catchability_data = data_df, ##length data
                 Q2_formula= ~ log(length_cm),
                 # Q2config_k = c(3), # Potential switch to make allometric weight-length a spatially varying term
                 Expansion_cz = Expansion_cz, ##tells code to expand as weighted-average of biomass for length category (aka c = 1)
                 #getReportCovariance = TRUE,
                 run_model = TRUE,
                 test_fit = FALSE,
                 #getJointPrecision = TRUE,
                 "optimize_args" =list("lower"=-Inf,"upper"=Inf),
                 "working_dir" = paste0(getwd(),"/results/",region,"/",species_code,"/") #TMB argument (?fit_tmb)
)

# save the VAST model
saveRDS(fit,file = paste0(getwd(),"/results/",region_esr,"/",species_code,"/",species_code,"_VASTfit.RDS"))

# standard plots
plot(fit,
     plot_set = c(3,20,21),
     category_names=c("Numbers","Condition (grams per cm^power)"),
     "working_dir" = paste0(getwd(),"/results/",region_esr,"/",species_code,"/") )

