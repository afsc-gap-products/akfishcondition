/* Query to retrieve length and weight samples for all northern Bering Sea for VAST. */

SELECT
  a.hauljoin, 
  a.vessel, 
  a.cruise, 
  a.haul, 
  a.stratum, 
  floor(a.cruise/100) year, 
  a.start_latitude latitude, 
  a.start_longitude longitude, 
  a.start_time,
	b.species_code, 
	b.specimenid, 
	c.common_name, 
	b.length length_mm, 
	b.weight weight_g, 
	b.sex, 
	b.age
FROM 
  racebase.haul a, 
  racebase.specimen b, 
  racebase.species c, 
  race_data.v_cruises d
WHERE 
  a.hauljoin = b.hauljoin
	AND a.cruise > 201000
	AND b.species_code IN (21740, 21720, 10210, 10285)
	AND b.species_code = c.species_code
	AND a.cruisejoin = d.cruisejoin 
	AND d.survey_definition_id = 143
	AND a.region = 'BS'
	AND length != 0 
	AND weight != 0
ORDER BY hauljoin;