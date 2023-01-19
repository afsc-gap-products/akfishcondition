library(akfishcondition)

akfishcondition::get_condition_data(channel = akfishcondition:::get_connected(schema = "AFSC"))

ai_spp <-  dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, 
                          region == "AI")

ai_run_check <- character()

for(ii in 1:nrow(ai_spp)) {
  fit_check <- NA
  fit_check <- try(
    akfishcondition::run_vast_condition(x = ai_spp[ii,], 
                                        response = "count"),
    silent = TRUE)
  
  ai_run_check <- c(ai_run_check, class(fit_check)[1])
}


goa_spp <-  dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, 
                         region == "GOA")

goa_run_check <- character()

for(ii in 1:nrow(goa_spp)) {
  fit_check <- NA
  fit_check <- try(
    akfishcondition::run_vast_condition(x = goa_spp[ii,], 
                                        response = "count"),
    silent = TRUE)
  
  goa_run_check <- c(goa_run_check, class(fit_check)[1])
}


ebs_spp <-  dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, 
                    region == "EBS")

ebs_run_check <- character()

for(ii in 1:nrow(ebs_spp)) {
  fit_check <- NA
  fit_check <- try(
    akfishcondition::run_vast_condition(x = ebs_spp[ii,], 
                                        response = "count"),
    silent = TRUE)
  
  ebs_run_check <- c(ebs_run_check, class(fit_check)[1])
}



nbs_spp <-  dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, 
                          region == "NBS")

nbs_run_check <- character()

for(ii in 1:nrow(nbs_spp)) {
  fit_check <- NA
  fit_check <- try(
    akfishcondition::run_vast_condition(x = nbs_spp[ii,], 
                                        response = "count"),
    silent = TRUE)
  
  nbs_run_check <- c(nbs_run_check, class(fit_check)[1])
}



