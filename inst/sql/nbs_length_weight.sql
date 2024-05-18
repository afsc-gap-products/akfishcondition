/* Query to retrieve length and weight samples for northern Bering Sea strata. */

SELECT
  h.haul, 
  c.vessel_id vessel,
  c.cruise,
  c.year,
  s.species_code,
  h.stratum,
  h.latitude_dd_start latitude,
  h.longitude_dd_start longitude,
  h.date_time_start start_time,
  s.specimen_id,
  t.common_name, 
  s.species_code,
  s.sex,
  s.length_mm,
  s.weight_g,
  s.age
FROM
  gap_products.akfin_specimen s,
  gap_products.akfin_haul h,
  gap_products.akfin_cruise c,
  gap_products.akfin_taxonomic_groups t
WHERE
  s.species_code IN (21740, 21720, 10210, 10285)
  AND c.survey_definition_id = 143
  AND h.hauljoin = s.hauljoin
  AND h.cruisejoin = c.cruisejoin
  AND h.stratum BETWEEN 70 and 81
  AND s.weight_g != 0
  AND s.length_mm != 0
  AND s.species_code = t.species_code;