/* Query to retrieve length-weight samples for Aleutian Islands bottom trawl surveys */

SELECT
  h.haul, 
  c.vessel_id vessel,
  c.cruise,
  c.year,
  s.species_code,
  a.area_name inpfc_stratum,
  h.latitude_dd_start latitude,
  h.longitude_dd_start longitude,
  h.date_time_start start_time,
  s.specimen_id specimenid,
  t.common_name, 
  s.sex,
  s.length_mm,
  s.weight_g,
  s.age
FROM
  gap_products.akfin_specimen s,
  gap_products.akfin_area a,
  gap_products.akfin_haul h,
  gap_products.akfin_cruise c,
  gap_products.akfin_taxonomic_groups t,
  gap_products.akfin_stratum_groups sg
WHERE
  s.species_code IN (21740,21741,21720,30420,10262,10110,30060,21921)
  AND c.survey_definition_id = 52
  AND a.area_id IN (299, 799, 3499, 5699)
  AND a.survey_definition_id = c.survey_definition_id
  AND h.hauljoin = s.hauljoin
  AND h.cruisejoin = c.cruisejoin
  AND h.stratum = sg.stratum
  AND sg.area_id = a.area_id
  AND s.weight_g != 0
  AND s.length_mm != 0
  AND s.species_code = t.species_code;