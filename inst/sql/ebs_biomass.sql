SELECT 
  species_code, 
  year, 
  area_id*10 stratum, 
  biomass_mt biomass, 
  biomass_var
FROM 
  gap_products.biomass
WHERE 
  species_code IN (21740, 21741, 21720, 10110, 10210, 10130, 10261, 10285)
  AND survey_definition_id = 98
  AND area_id BETWEEN 1 AND 6;