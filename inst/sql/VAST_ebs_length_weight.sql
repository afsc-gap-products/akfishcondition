/* Query to retrieve length and weight samples for all eastern Bering Sea continental shelf strata for VAST. */
select a.hauljoin, floor(a.cruise/100) year, a.start_latitude latitude, a.start_longitude longitude, 
	b.species_code, c.common_name, length length_mm, weight weight_g
	from racebase.haul a, racebase.specimen b, racebase.species c, race_data.v_cruises d
	where a.hauljoin = b.hauljoin
	and a.cruise >= 199900
	and b.species_code in (21740, 21720, 10110, 10210, 10130, 10261, 10285)
	and b.species_code = c.species_code
	and a.cruisejoin = d.cruisejoin and d.survey_definition_id = 98
	and a.haul_type in (3,13)
	and a.region = 'BS'
	and length != 0 
	and weight != 0
	order by hauljoin