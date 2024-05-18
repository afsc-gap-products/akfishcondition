library(akfishcondition)

# Make ESR/ESP settings ----

ESR_SETTINGS <- list(ESR_SPECIES = data.frame(common_name = c(
  "walleye pollock", "walleye pollock (100-250 mm)", "walleye pollock (>250 mm)", "Pacific cod", 
  "Pacific cod (juvenile)", "Pacific cod (adult)", "Atka mackerel", "arrowtooth flounder", 
  "flathead sole", "yellowfin sole", "northern rock sole", "southern rock sole", "Alaska plaice",
  "Pacific ocean perch", "dusky rockfish", "northern rockfish", "Dover sole", "rex sole", "shortraker rockfish", "rougheye rockfish", "blackspotted rockfish", "sharpchin rockfish"),
  species_code = c(21740, 21741, 21742, 21720, 21721, 21722, 21921, 10110, 10130,
                   10210, 10261, 10262, 10285, 30060, 30152, 30420, 10180, 10200, 30576, 30051, 30052, 30560),
  AI = c(FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
  GOA = c(FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
  EBS = c(FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
  NBS = c(FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)),
  VAST_SETTINGS = data.frame(species_code = c(30420, 30060, 10262, 21720, 21740, 10110, 30152,
                                              30420, 30060, 10262, 21720, 21740, 21921, 10110, 21741, 21742, 
                                              10130, 10210, 10285, 21740, 21720, 10110, 10261, 21741, 21742,
                                              21740, 21720, 10210, 10285, 21741, 21742
  ),
  region = c("GOA", "GOA", "GOA", "GOA", "GOA", "GOA", "GOA",
             "AI", "AI", "AI", "AI", "AI", "AI", "AI", "AI", "AI",
             "EBS", "EBS", "EBS", "EBS", "EBS", "EBS", "EBS", "EBS", "EBS",
             "NBS", "NBS", "NBS", "NBS", "NBS", "NBS"),
  ObsModel_1 = c(2, 2, 2, 2, 2, 2, 2,
                 2, 2, 2, 2, 2, 2, 2, 2, 2,
                 2, 2, 2, 2, 2, 2, 2, 2, 2,
                 2, 2, 2, 2, 2, 2), 
  ObsModel_2 = c(1, 1, 1, 1, 1, 1, 1,
                 1, 1, 1, 1, 1, 1, 1, 1, 1,
                 1, 1, 1, 1, 1, 1, 1, 1, 1,
                 1, 1, 1, 1, 1, 1), 
  ObsModel_3 = c(3, 3, 3, 3, 4, 4, 4,
                 3, 3, 3, 3, 4, 3, 4, 4, 4,
                 3, 3, 3, 4, 3, 4, 3, 4, 4,
                 4, 4, 3, 4, 4, 4),
  ObsModel_4 = c(3, 3, 3, 3, 4, 4, 4,
                 3, 3, 3, 3, 4, 3, 4, 4, 4,
                 3, 3, 3, 4, 3, 4, 3, 4, 4,
                 4, 4, 3, 4, 4, 4),
  fl_min = c(0, 0, 0, 0, 0, 0, 0,
             0, 0, 0, 0, 0, 0, 0, 100, 251,
             0, 0, 0, 0, 0, 0, 0, 100, 251,
             0, 0, 0, 0, 100, 251),
  fl_max = c(1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 1e7,
             1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 250, 1e7,
             1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 250, 1e7,
             1e7, 1e7, 1e7, 1e7, 250, 1e7),
  n_knots = c(400, 400, 400, 400, 400, 400, 400,
              400, 600, 400, 400, 400, 400, 400, 400, 400,
              400, 600, 400, 400, 750, 400, 400, 400, 400,
              200, 200, 200, 200, 200, 200))
)

ESP_SETTINGS <- list(ESP_SPECIES = 
                       data.frame(
                         common_name = c("Pacific cod (juvenile)", "Pacific cod (adult)"),
                         species_code = c(21721, 21722),
                         AI = c(TRUE, TRUE),
                         GOA = c(TRUE, TRUE),
                         EBS = c(TRUE, TRUE),
                         NBS = c(FALSE, FALSE)),
                     VAST_SETTINGS = data.frame(species_code = c(21721, 21722,
                                                                 21721, 21722,
                                                                 21721, 21722),
                                                region = c("GOA", "GOA",
                                                           "AI", "AI",
                                                           "EBS", "EBS"),
                                                ObsModel_1 = c(2, 2,
                                                               2, 2,
                                                               2, 2),
                                                ObsModel_2 = c(1, 1,
                                                               1, 1,
                                                               1, 1),
                                                ObsModel_3 = c(3, 3,
                                                               4, 4,
                                                               3, 3),
                                                ObsModel_4 = c(3, 3,
                                                               4, 4,
                                                               3, 3),
                                                n_knots = c(400, 400,
                                                            400, 600,
                                                            750, 750),
                                                fl_min = c(0, 504,
                                                           0, 581,
                                                           0, 581),
                                                fl_max = c(503, 1e7,
                                                           580, 1e7,
                                                           580, 1e7))
)

devtools::install()

# Get data ---

library(akfishcondition)

channel <- akfishcondition:::get_connected(schema = "AFSC")

akfishcondition::get_condition_data(channel = channel)


# Generate data visualizations ---

akfishcondition:::make_data_summary(dat_csv = here::here("data", "nbs_all_species.csv"), region = "NBS")
akfishcondition:::make_data_summary(dat_csv = here::here("data", "ebs_all_species.csv"), region = "EBS")
akfishcondition:::make_data_summary(dat_csv = here::here("data", "ai_all_species.csv"), region = "AI")
akfishcondition:::make_data_summary(dat_csv = here::here("data", "goa_all_species.csv"), region = "GOA")


# Calculate residual condition indicator  ----

ai_sbw <- akfishcondition:::run_sbw_condition_multimodel(
  region = "AI",
  covariates_to_use = c('sex', 'stratum'),
  min_n = 10)

goa_sbw <- akfishcondition:::run_sbw_condition_multimodel(
  region = "GOA",
  covariates_to_use = c('sex', 'stratum'),
  min_n = 10)

ebs_sbw <- akfishcondition:::run_sbw_condition_multimodel(
  region = "EBS",
  covariates_to_use = c('sex', 'stratum'),
  min_n = 10)

nbs_sbw <- akfishcondition:::run_sbw_condition_multimodel(
  region = "NBS",
  covariates_to_use = c('sex', 'stratum'),
  min_n = 10)


# Add updated indicator to built-in data sets ---- 

EBS_INDICATOR <- list(
  FULL_REGION = as.data.frame(
    ebs_sbw$full_sbw) |> 
    dplyr::filter(common_name %in% ESR_SETTINGS$ESR_SPECIES$common_name[ESR_SETTINGS$ESR_SPECIES$EBS]),
  STRATUM = as.data.frame(
    dplyr::filter(
      ebs_sbw$stratum_sbw, 
      common_name %in% ESR_SETTINGS$ESR_SPECIES$common_name[ESR_SETTINGS$ESR_SPECIES$EBS])
  ),
  LAST_UPDATE = Sys.Date()
)

NBS_INDICATOR <- list(
  FULL_REGION = as.data.frame(
    nbs_sbw$full_sbw) |>
    dplyr::filter( 
      common_name %in% ESR_SETTINGS$ESR_SPECIES$common_name[ESR_SETTINGS$ESR_SPECIES$NBS]),
  STRATUM = as.data.frame(
    dplyr::filter(
      nbs_sbw$stratum_sbw, 
      common_name %in% ESR_SETTINGS$ESR_SPECIES$common_name[ESR_SETTINGS$ESR_SPECIES$EBS])
  ),
  LAST_UPDATE = Sys.Date()
)

GOA_INDICATOR <- list(
  FULL_REGION = as.data.frame(
    goa_sbw$full_sbw) |> 
    dplyr::filter(common_name %in% ESR_SETTINGS$ESR_SPECIES$common_name[ESR_SETTINGS$ESR_SPECIES$GOA]),
  STRATUM = as.data.frame(
    dplyr::filter(
      goa_sbw$stratum_sbw, 
      common_name %in% ESR_SETTINGS$ESR_SPECIES$common_name[ESR_SETTINGS$ESR_SPECIES$GOA])
  ),
  LAST_UPDATE = Sys.Date()
)

AI_INDICATOR <- list(
  FULL_REGION = as.data.frame(
    ai_sbw$full_sbw) |> 
    dplyr::filter(common_name %in% ESR_SETTINGS$ESR_SPECIES$common_name[ESR_SETTINGS$ESR_SPECIES$AI]),
  STRATUM = as.data.frame(
    dplyr::filter(
      ai_sbw$stratum_sbw, 
      common_name %in% ESR_SETTINGS$ESR_SPECIES$common_name[ESR_SETTINGS$ESR_SPECIES$AI])
  ),
  LAST_UPDATE = Sys.Date()
)

PCOD_ESP <- list(
  FULL_REGION_EBS = as.data.frame(
    dplyr::filter(ebs_sbw$full_sbw,
                  common_name %in% ESP_SETTINGS$ESP_SPECIES$common_name
    )),
  FULL_REGION_GOA = as.data.frame(
    dplyr::filter(goa_sbw$full_sbw,
                  common_name %in% ESP_SETTINGS$ESP_SPECIES$common_name
    )),
  FULL_REGION_AI = as.data.frame(
    dplyr::filter(ai_sbw$full_sbw,
                  common_name %in% ESP_SETTINGS$ESP_SPECIES$common_name
    )),
  FULL_REGION_NBS = as.data.frame(
    dplyr::filter(
      nbs_sbw$full_sbw, common_name %in% ESP_SETTINGS$ESP_SPECIES$common_name
    )),
  STRATUM_EBS = as.data.frame(
    dplyr::filter(
      ebs_sbw$stratum_sbw, common_name %in% ESP_SETTINGS$ESP_SPECIES$common_name
    )),
  STRATUM_GOA = as.data.frame(
    dplyr::filter(
      goa_sbw$stratum_sbw, common_name %in% ESP_SETTINGS$ESP_SPECIES$common_name
    )),
  STRATUM_AI = as.data.frame(
    dplyr::filter(
      ai_sbw$stratum_sbw, common_name %in% ESP_SETTINGS$ESP_SPECIES$common_name
    )),
  stratum_NBS = NA,
  LAST_UPDATE = Sys.Date()
)

usethis::use_data(EBS_INDICATOR, overwrite = TRUE)
usethis::use_data(AI_INDICATOR, overwrite = TRUE)
usethis::use_data(GOA_INDICATOR, overwrite = TRUE)
usethis::use_data(NBS_INDICATOR, overwrite = TRUE)
usethis::use_data(PCOD_ESP, overwrite = TRUE)

save(
  EBS_INDICATOR,
  NBS_INDICATOR,
  GOA_INDICATOR,
  AI_INDICATOR,
  PCOD_ESP,
  ESR_SETTINGS,
  ESP_SETTINGS,
  file = here::here("R", "sysdata.rda")
)

AI_raw <- ai_sbw$input_data
GOA_raw <- goa_sbw$input_data
EBS_raw <- ebs_sbw$input_data
NBS_raw <- nbs_sbw$input_data

save(AI_raw,
     GOA_raw,
     EBS_raw,
     NBS_raw,
     file = here::here("inst", "extdata", "raw_lw_bio.rda"))

# Check update ----

library(akfishcondition)

print(akfishcondition::AI_INDICATOR$LAST_UPDATE)
print(akfishcondition::GOA_INDICATOR$LAST_UPDATE)
print(akfishcondition::EBS_INDICATOR$LAST_UPDATE)
print(akfishcondition::NBS_INDICATOR$LAST_UPDATE)