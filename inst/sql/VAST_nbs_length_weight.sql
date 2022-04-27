/* Query to retrieve length and weight samples for all northern Bering Sea for VAST. */

select a.hauljoin, floor(a.cruise/100) year, start_latitude latitude, start_longitude longitude, 
	b.species_code, common_name, null cpue_kg_km2, length length_mm, weight weight_g
	from racebase.haul a, racebase.specimen b, racebase.species c, race_data.v_cruises d
	where a.hauljoin = b.hauljoin
	and a.cruise > 201000
	and b.species_code in (21740, 21720, 10210, 10285)
	and b.species_code = c.species_code
	and a.cruisejoin = d.cruisejoin and d.survey_definition_id = 143
	and a.region = 'BS'
	and length != 0 
	and weight != 0
	order by hauljoin