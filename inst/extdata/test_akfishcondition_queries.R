# Test queries for akfishcondition

library(devtools)
devtools::install_github("sean-rohan-noaa/akfishcondition")

library(akfishcondition)

channel <- akfishcondition::get_connected()

goa_biomass <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/goa_biomass.sql", package = "akfishcondition")))
ai_biomass <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/ai_biomass.sql", package = "akfishcondition")))
ebs_biomass <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/ebs_biomass.sql", package = "akfishcondition")))
nbs_biomass <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/nbs_biomass.sql", package = "akfishcondition")))

ai_lw <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/ai_length_weight.sql", package = "akfishcondition")))
ebs_lw <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/ebs_nbs_length_weight.sql", package = "akfishcondition")))
goa_lw <- RODBC::sqlQuery(channel, akfishcondition::sql_to_rqry(system.file("./sql/goa_length_weight.sql", package = "akfishcondition")))
