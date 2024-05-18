/* Query to retrieve CPUE in kilograms per square kilometer from all eastern Bering Sea continental shelf strata for VAST. */

SELECT 
  a.hauljoin, 
  a.start_latitude latitude, 
  a.start_longitude longitude, 
  a.start_time, 
  a.stationid, 
  b.species_code, 
  floor(a.cruise/100) year, 
  b.cpue_kgkm2 cpue_kg_km2, 
  b.count number_fish, 
  b.area_swept_km2 effort_km2, 
  d.common_name
FROM 
  racebase.haul a, 
  gap_products.cpue b, 
  race_data.v_cruises c, 
  racebase.species d 
WHERE 
  a.cruise > 199900 
  AND a.hauljoin = b.hauljoin 
  AND a.haul_type IN (3,13)
  AND a.cruisejoin = c.cruisejoin
  AND c.survey_definition_id = 98
  AND b.species_code = d.species_code
  AND b.species_code IN (21740, 21720, 10110, 10210, 10130, 10261, 10285)
ORDER BY hauljoin
