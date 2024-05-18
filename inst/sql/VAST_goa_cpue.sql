/* Query to retrieve CPUE in kilograms per square kilometer from all Gulf of Alaska strata for VAST. */

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
  a.cruise >= 199000
  AND a.hauljoin = b.hauljoin 
  AND a.haul_type = 3
  AND a.cruisejoin = c.cruisejoin
  AND c.survey_definition_id = 47
  AND b.species_code = d.species_code
  AND b.species_code IN (21740,21720,30420,10262,10110,30060,30152,10261,10180,10200,10130,30576,30051,30052,30560)
ORDER BY hauljoin;