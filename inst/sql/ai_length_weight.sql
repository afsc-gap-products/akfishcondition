/* Query to retrieve length-weight samples for Aleutian Islands bottom trawl surveys
Prepared by: Ned Laman (ned.laman@noaa.gov), AFSC/RACE/GAP 
Query updated: September 22, 2021 
*/
select a.haul, a.vessel, a.cruise, b.species_code, a.region, a.start_time, c.inpfc_area,
a.stratum, a.stationid, a.bottom_depth, a.start_latitude, a.start_longitude, d.specimenid,
e.common_name, d.sex, d.length, d.weight, b.weight catch_weight
from racebase.haul a, racebase.catch b, goa.goa_strata c, racebase.specimen d , racebase.species e
where a.region = 'AI' and (a.cruise >= 198401 and a.cruise != 198901) 
and b.species_code in (21740,21741,21720,30420,10262,10110,30060,21921)
and a.hauljoin = b.hauljoin and b.hauljoin = d.hauljoin
and b.species_code = e.species_code and b.species_code = d.species_code and a.stratum = c.stratum
and a.region = c.survey and d.length != 0 and d.weight != 0