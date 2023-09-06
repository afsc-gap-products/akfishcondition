SELECT species_code, year, area_id stratum, biomass_mt biomass, biomass_var
FROM gap_products.biomass
WHERE (((species_code) in (21740, 21741, 21720, 10210, 10285))) and
survey_definition_id = 143
and area_id < 90