library(akfishcondition)

region <- "GOA"
x <- dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, region == region)
run_vast_condition(x = x, region = region, n_knots = 250)