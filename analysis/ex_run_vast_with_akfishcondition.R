library(akfishcondition)

akfishcondition::get_condition_data(channel = akfishcondition:::get_connected(schema = "AFSC"))

region <- "GOA"
x <- dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, region == region)
akfishcondition::run_vast_condition(x = x, region = region, n_knots = 250)