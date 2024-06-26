/* Query to retrieve length and weight samples for eastern Bering Sea continental shelf strata 10-62. */

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
  s.specimen_id specimenid,
  t.common_name, 
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
  s.species_code IN (21740, 21720, 10110, 10210, 10130, 10261, 10285)
  AND c.survey_definition_id = 98
  AND h.hauljoin = s.hauljoin
  AND h.cruisejoin = c.cruisejoin
  AND h.stratum BETWEEN 10 and 62
  AND s.weight_g != 0
  AND s.length_mm != 0
  AND s.species_code = t.species_code
  AND c.year >= 1999;
