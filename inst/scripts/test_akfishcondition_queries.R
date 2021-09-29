# Queries to retrieve data for ESR and ESP contributions

library(akfishcondition)

channel <- akfishcondition::get_connected()

ai_biomass <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/ai_biomass.sql", package = "akfishcondition"))) %>%
  dplyr::select(-HAUL_COUNT, -CATCH_COUNT, -INPFC_STRATUM_AREA)

ai_lw <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/ai_length_weight.sql", package = "akfishcondition"))) %>%
  dplyr::rename(INPFC_STRATUM = INPFC_AREA) %>%
  dplyr::mutate(YEAR = floor(CRUISE/100),
                ID = paste(CRUISE, VESSEL, HAUL, SPECIMENID, sep = "_")) %>%
  dplyr::select(ID, REGION, INPFC_STRATUM, COMMON_NAME, SPECIES_CODE, SEX, LENGTH, WEIGHT)

ai_nsamp <- table(ai_lw$INPFC_STRATUM, ai_lw$COMMON_NAME)

ai_check <- ai_lw %>% 
  dplyr::inner_join(ai_biomass)

print(paste0("AI stratum count match: ", sum(ai_nsamp == table(ai_check$INPFC_STRATUM, ai_check$COMMON_NAME)) == length(ai_nsamp)))
print(paste0("Year range: ", min(ai_check$YEAR), "-",  max(ai_check$YEAR)))

AI_dat <- list(LW = ai_lw,
               BIOMASS = ai_biomass,
              AKFISHCONDITION_VERSION = utils::packageVersion("akfishcondition"),
              LAST_UPDATE = Sys.Date())
# Retrieve GOA biomass for GOA INPFC strata
goa_biomass <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/goa_biomass.sql", package = "akfishcondition"))) %>%
  dplyr::select(-HAUL_COUNT, -CATCH_COUNT, -INPFC_STRATUM_AREA)

# Retrieve GOA length-weight, rename INPFFC_AREA to INPFC_STRATUM and create YEAR field.
goa_lw <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/goa_length_weight.sql", package = "akfishcondition"))) %>%
  dplyr::rename(INPFC_STRATUM = INPFC_AREA) %>%
  dplyr::mutate(YEAR = floor(CRUISE/100)) %>%
  dplyr::select(HAUL, VESSEL, CRUISE, REGION, INPFC_STRATUM, SPECIMENID, COMMON_NAME, SPECIES_CODE, SEX, LENGTH, WEIGHT) %>%
  dplyr::filter(YEAR != 1985) # No estimates for 1985

goa_nsamp <- table(goa_lw$INPFC_STRATUM, goa_lw$COMMON_NAME)

goa_check <- goa_lw %>% 
  dplyr::inner_join(goa_biomass)

print(paste0("GOA stratum count match: ", sum(goa_nsamp == table(goa_check$INPFC_STRATUM, goa_check$COMMON_NAME)) == length(goa_nsamp)))
print(paste0("Year range: ", min(goa_check$YEAR), "-",  max(goa_check$YEAR)))

goa_nsamp == table(goa_lw$INPFC_STRATUM, goa_lw$COMMON_NAME) 

goa_lw %>% 
  dplyr::anti_join(goa_biomass)

GOA_dat <- list(LW = goa_lw,
                BIOMASS = goa_biomass,
                AKFISHCONDITION_VERSION = utils::packageVersion("akfishcondition"),
                LAST_UPDATE = Sys.Date())

# Retrieve EBS biomass for aggregated strata (1=10, 2=20, 3=31-32, 4=41-43, 5=50, 6=61-62)
ebs_biomass <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/ebs_biomass.sql", package = "akfishcondition")))

# Retrieve EBS length-weight, update STRATUM field and create YEAR field.
ebs_lw <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/ebs_length_weight.sql", package = "akfishcondition"))) %>%
  dplyr::mutate(YEAR = floor(CRUISE/100),
                STRATUM = floor(STRATUM/10)) %>%
  dplyr::select(HAUL, VESSEL, CRUISE, REGION, STRATUM, SPECIMENID, COMMON_NAME, SPECIES_CODE, SEX, LENGTH, WEIGHT)
ebs_nsamp <- table(ebs_lw$STRATUM, ebs_lw$COMMON_NAME)

ebs_check <- ebs_lw %>% 
  dplyr::inner_join(ebs_biomass)

print(paste0("EBS stratum count match: ", sum(ebs_nsamp == table(ebs_check$STRATUM, ebs_check$COMMON_NAME)) == length(ebs_nsamp)))
print(paste0("Year range: ", min(ebs_check$YEAR), "-",  max(ebs_check$YEAR)))

EBS_dat <- list(LW = ebs_lw,
                BIOMASS = ebs_biomass,
                AKFISHCONDITION_VERSION = utils::packageVersion("akfishcondition"),
                LAST_UPDATE = Sys.Date())

# Retrieve NBS length-weight, update STRATUM field and create YEAR field.
nbs_lw <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/nbs_length_weight.sql", package = "akfishcondition"))) %>%
  dplyr::mutate(YEAR = floor(CRUISE/100),
                STRATUM = 999) %>%
  dplyr::select(HAUL, VESSEL, CRUISE, REGION, STRATUM, SPECIMENID, COMMON_NAME, SPECIES_CODE, SEX, LENGTH, WEIGHT)
print(paste0("Year range: ", min(nbs_lw$YEAR), "-",  max(nbs_lw$YEAR)))

NBS_dat <- list(LW = nbs_lw,
                biomass = NA,
                AKFISHCONDITION_VERSION = utils::packageVersion("akfishcondition"),
                LAST_UPDATE = Sys.Date())


# verify that all samples are included
# last update
# akfishcondition version
# documentation
# add to sysdata

