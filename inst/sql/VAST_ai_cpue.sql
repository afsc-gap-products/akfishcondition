/* Query to retrieve CPUE in kilograms per square kilometer from all Aleutian Islands strata for VAST. */

select a.hauljoin, a.year, c.start_latitude latitude, c.start_longitude longitude, c.start_time,
	b.species_code, b.common_name, a.wgtcpue cpue_kg_km2
	from ai.cpue a, racebase.species b, racebase.haul c, race_data.cruises f, race_data.surveys g
	where a.species_code = b.species_code
	and f.survey_id = g.survey_id
  and g.survey_definition_id = 52
  and c.cruisejoin = f.racebase_cruisejoin
	and a.hauljoin = c.hauljoin
	and a.species_code in (21740,21741,21720,30420,10262,10110,30060,21921)
	and (c.cruise >= 198401 and c.cruise != 198901)
