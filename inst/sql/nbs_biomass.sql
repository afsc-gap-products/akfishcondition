SELECT 
  species_code, 
  year, 
  area_id stratum, 
  biomass_mt biomass, 
  biomass_var
FROM 
  gap_products.biomass
WHERE 
  species_code IN (21740, 21741, 21720, 10210, 10285)
  AND survey_definition_id = 143
  AND area_id < 90;