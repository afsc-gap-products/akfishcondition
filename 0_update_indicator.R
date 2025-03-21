library(akfishcondition)
# library(VAST)

# Retrieve length-weight, cpue, and biomass data; write to /data/
channel <- akfishcondition:::get_connected(schema = "AFSC")

akfishcondition::get_condition_data(channel = channel)

akfishcondition:::make_data_summary(dat_csv = here::here("data", "nbs_all_species.csv"), region = "NBS")
akfishcondition:::make_data_summary(dat_csv = here::here("data", "ebs_all_species.csv"), region = "EBS")
akfishcondition:::make_data_summary(dat_csv = here::here("data", "ai_all_species.csv"), region = "AI")
akfishcondition:::make_data_summary(dat_csv = here::here("data", "goa_all_species.csv"), region = "GOA")

# Setup ESR chapter settings
ESR_SETTINGS <- 
  list(
    ESR_SPECIES = data.frame(
      common_name = c(
        "walleye pollock", "walleye pollock (100-250 mm)", "walleye pollock (>250 mm)", "Pacific cod", 
        "Pacific cod (juvenile)", "Pacific cod (adult)", "Atka mackerel", "arrowtooth flounder", 
        "flathead sole", "yellowfin sole", "northern rock sole", "southern rock sole", "Alaska plaice",
        "Pacific ocean perch", "dusky rockfish", "northern rockfish", "Dover sole", "rex sole", 
        "shortraker rockfish", "rougheye rockfish", "blackspotted rockfish", "sharpchin rockfish"),
      species_code = 
        c(21740, 21741, 21742, 21720, 21721, 21722, 21921, 10110, 10130,
          10210, 10261, 10262, 10285, 30060, 30152, 30420, 10180, 10200, 30576, 30051, 30052, 30560),
      AI = 
        c(FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, 
          FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
      GOA = 
        c(FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, 
          TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
      EBS = 
        c(FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, 
          FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
      NBS = 
        c(FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, 
          FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
    ),
    VAST_SETTINGS = 
      data.frame(
        species_code = c(30420, 30060, 10262, 21720, 21740, 10110, 30152,
                         30420, 30060, 10262, 21720, 21740, 21921, 10110, 21741, 21742, 
                         10130, 10210, 10285, 21740, 21720, 10110, 10261, 21741, 21742,
                         21740, 21720, 10210, 10285, 21741, 21742
        ),
        region = 
          c("GOA", "GOA", "GOA", "GOA", "GOA", "GOA", "GOA",
            "AI", "AI", "AI", "AI", "AI", "AI", "AI", "AI", "AI",
            "EBS", "EBS", "EBS", "EBS", "EBS", "EBS", "EBS", "EBS", "EBS",
            "NBS", "NBS", "NBS", "NBS", "NBS", "NBS"
          ),
        ObsModel_1 = 
          c(2, 2, 2, 2, 2, 2, 2,
            2, 2, 2, 2, 2, 2, 2, 2, 2,
            2, 2, 2, 2, 2, 2, 2, 2, 2,
            2, 2, 2, 2, 2, 2
          ), 
        ObsModel_2 = 
          c(1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1
          ), 
        ObsModel_3 = 
          c(3, 3, 3, 3, 4, 4, 4,
            3, 3, 3, 3, 4, 3, 4, 4, 4,
            3, 3, 3, 4, 3, 4, 3, 4, 4,
            4, 4, 3, 4, 4, 4
          ),
        ObsModel_4 = 
          c(3, 3, 3, 3, 4, 4, 4,
            3, 3, 3, 3, 4, 3, 4, 4, 4,
            3, 3, 3, 4, 3, 4, 3, 4, 4,
            4, 4, 3, 4, 4, 4
          ),
        fl_min = 
          c(0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 100, 251,
            0, 0, 0, 0, 0, 0, 0, 100, 251,
            0, 0, 0, 0, 100, 251
          ),
        fl_max = 
          c(1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 1e7,
            1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 250, 1e7,
            1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 1e7, 250, 1e7,
            1e7, 1e7, 1e7, 1e7, 250, 1e7
          ),
        n_knots = 
          c(400, 400, 400, 400, 400, 400, 400,
            400, 600, 400, 400, 400, 400, 400, 400, 400,
            400, 600, 400, 400, 750, 400, 400, 400, 400,
            200, 200, 200, 200, 200, 200
          )
      )
  )

# Setup ESP Pacific cod
ESP_SETTINGS <- 
  list(
    ESP_SPECIES = 
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
                                          580, 1e7)
    )
  )

# 1. Update stratum-biomass weighted condition indicators

# Aleutian Islands
ai_sbw <- 
  akfishcondition:::run_sbw_condition_multimodel(
    stratum_col = "area_id",
    biomass_col = "biomass_mt",
    region = "AI",
    covariates_to_use = c('sex', 'stratum'),
    min_n = 10
  )

# Gulf of Alaska
goa_sbw <- 
  akfishcondition:::run_sbw_condition_multimodel(
    stratum_col = "area_id",
    biomass_col = "biomass_mt",
    region = "GOA",
    covariates_to_use = c('sex', 'stratum'),
    min_n = 10
  )

# Eastern Bering Sea
ebs_sbw <- 
  akfishcondition:::run_sbw_condition_multimodel(
    stratum_col = "area_id",
    biomass_col = "biomass_mt",
    region = "EBS",
    covariates_to_use = c('sex', 'stratum'),
    min_n = 10
  )

# Northern Bering Sea
nbs_sbw <- 
  akfishcondition:::run_sbw_condition_multimodel(
    stratum_col = "area_id",
    biomass_col = "biomass_mt",
    region = "NBS",
    covariates_to_use = c('sex', 'stratum'),
    min_n = 10
  )

# 2. Save raw data to inst/extdata

AI_raw <- ai_sbw$input_data
GOA_raw <- goa_sbw$input_data
EBS_raw <- ebs_sbw$input_data
NBS_raw <- nbs_sbw$input_data

save(
  AI_raw,
  GOA_raw,
  EBS_raw,
  NBS_raw,
  file = here::here("inst", "extdata", "raw_lw_bio.rda")
)

# 3. Run VAST indicator

## 3.1 Run VAST: Aleutian Islands

# ai_spp <-  dplyr::filter(ESR_SETTINGS$VAST_SETTINGS, 
#                           region == "AI")
# 
# for(ii in 1:nrow(ai_spp)) {
#     akfishcondition::run_vast_condition(x = ai_spp[ii,], 
#                                         response = "count")
#   gc()
# }

## 3.2 Run VAST: Gulf of Alaska

# goa_spp <-  dplyr::filter(ESR_SETTINGS$VAST_SETTINGS, 
#                          region == "GOA")
# 
# for(ii in 1:nrow(goa_spp)) {
# 
#     akfishcondition::run_vast_condition(x = goa_spp[ii,], 
#                                         response = "count")
#   gc()
# }

## 3.3 Run VAST: EBS Shelf

# ebs_spp <-  dplyr::filter(ESR_SETTINGS$VAST_SETTINGS, 
#                     region == "EBS")
# 
# for(ii in 1:nrow(ebs_spp)) {
#     akfishcondition::run_vast_condition(x = ebs_spp[ii,], 
#                                         response = "count")
#   gc()
# }

## 3.4 Run VAST: NBS

# nbs_spp <-  dplyr::filter(ESR_SETTINGS$VAST_SETTINGS, 
#                           region == "NBS")
# 
# for(ii in 1:nrow(nbs_spp)) {
#     akfishcondition::run_vast_condition(x = nbs_spp[ii,], 
#                                         response = "count")
#   gc()
# }

## 3.5 Run VAST: ESP Pacific cod

# pcod_spp <-  dplyr::filter(ESP_SETTINGS$VAST_SETTINGS, 
#                     region == "EBS")
# 
# for(ii in 1:nrow(pcod_spp)) {
#     akfishcondition::run_vast_condition(x = pcod_spp[ii,], 
#                                         response = "count")
#   gc()
# }


# 4. Load VAST indicators

# akfishcondition:::make_vast_table(region = "GOA", write_table = TRUE)
# akfishcondition:::make_vast_table(region = "EBS", write_table = TRUE)
# akfishcondition:::make_vast_table(region = "NBS", write_table = TRUE)
# akfishcondition:::make_vast_table(region = "AI", write_table = TRUE)
# 
# # goa_vast_df <-bundle_vast_condition(region = "GOA", years = c(seq(1984, 1999, 3), seq(2001, 2022, 2)))
# ebs_vast_df <- akfishcondition::bundle_vast_condition(region = "EBS", years = c(1999:2019, 2021:2022))
# nbs_vast_df <- akfishcondition::bundle_vast_condition(region = "NBS", years = c(2010, 2017, 2019, 2021, 2022))
# ai_vast_df <- akfishcondition::bundle_vast_condition(region = "AI", 
#                                     years = c(1986, seq(1991, 2000, 3), 
#                                               seq(2002, 2006, 2), 
#                                               seq(2010, 2018, 2), 2022))

# 5. Update version in DESCRIPTION file

# Update sysdata.rda with raw data for the condition indicator and write raw data to inst/extdata.

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

# 6. Update documentation, install, and restart
# Update version number in DESCRIPTION and update documentation using:
devtools::document(roclets = c('rd', 'collate', 'namespace'))

# After updating, reinstall the akfishcondition package.

# 7. Check that data appears correctly

# Check that the updated condition data is included in the package.
print(akfishcondition::AI_INDICATOR$LAST_UPDATE)
print(akfishcondition::GOA_INDICATOR$LAST_UPDATE)
print(akfishcondition::EBS_INDICATOR$LAST_UPDATE)
print(akfishcondition::NBS_INDICATOR$LAST_UPDATE)
