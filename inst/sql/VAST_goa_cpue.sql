/* Query to retrieve CPUE in kilograms per square kilometer from all Gulf of Alaska strata for VAST. */

select a.hauljoin, year, start_latitude latitude, start_longitude longitude, 
	b.species_code, common_name, wgtcpue cpue_kg_km2, null length_mm, null weight_g
	from goa.cpue a, racebase.species b, racebase.haul c
	where a.species_code = b.species_code
	and a.hauljoin = c.hauljoin
	and a.species_code in (21740,21741,21720,30420,10262,10110,30060,30152)