/* Query to retrieve length and weight samples for all northern Bering Sea for VAST. */

select a.hauljoin, a.vessel, a.cruise, a.haul, a.stratum, floor(a.cruise/100) year, a.start_latitude latitude, a.start_longitude longitude, a.start_time,
	b.species_code, b.specimenid, c.common_name, b.length length_mm, b.weight weight_g, b.sex, b.age
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