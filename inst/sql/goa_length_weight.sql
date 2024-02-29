/* Query to retrieve length-weight samples for Gulf of Alaska bottom trawl surveys */

select a.haul, a.vessel, a.cruise, floor(a.cruise/100) year, b.species_code, a.region, c.inpfc_area inpfc_stratum, a.start_latitude latitude, a.start_longitude longitude, a.start_time,
d.specimenid, e.common_name, d.sex, d.length length_mm, d.weight weight_g, d.age
from racebase.haul a, racebase.catch b, goa.goa_strata c, racebase.specimen d, racebase.species e, race_data.cruises f, race_data.surveys g
where a.region = 'GOA' and (a.cruise >= 199000)
and b.species_code in (21740,21741,21720,30420,10262,10110,30060,30152,10261,10180,10200,10130,30576,30051,30052,30560)
and a.hauljoin = b.hauljoin and b.hauljoin = d.hauljoin
and f.survey_id = g.survey_id
and g.survey_definition_id = 47
and a.cruisejoin = f.racebase_cruisejoin
and b.species_code = e.species_code and b.species_code = d.species_code and a.stratum = c.stratum
and a.region = c.survey and d.length != 0 and d.weight != 0