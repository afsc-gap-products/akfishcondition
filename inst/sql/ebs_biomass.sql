SELECT species_code, year, area_id*10 stratum, biomass_mt biomass, biomass_var
FROM gap_products.biomass
WHERE (((species_code) in (21740, 21741, 21720, 10110, 10210, 10130, 10261, 10285))) and
survey_definition_id = 98
and area_id between 1 and 6