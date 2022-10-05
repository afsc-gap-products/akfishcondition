library(akfishcondition)

akfishcondition::get_condition_data(channel = akfishcondition:::get_connected(schema = "AFSC"))


x <-  dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, 
                    region == "AI",
                    species_code == 30060)
akfishcondition::run_vast_condition(x = x, region = "AI", n_knots = 600, response = "count")
