/* Query to retrieve length and weight samples for eastern Bering Sea continental shelf strata 10-62.
Omits corner stations from EBS shelf and does not include strata 82 and 90, following approach used by Chris Rooper prior to 2018, 
Prepared by: Ned Laman (ned.laman@noaa.gov), AFSC/RACE/GAP 
Query updated: September 22, 2021 

survey_definition_id != 78 eliminates Bering Slope stations
decode to combine strata  and stratum range between 10 and 99 per original intent
stratum not in (82, 90) because these are non-standard strata and were excluded a priori
*/
select a.haul, a.vessel, a.cruise, b.species_code, a.region, a.start_time,
decode(a.stratum, 31, 30, 32, 30, 61, 60, 62, 60, 41, 40, 42, 40, 43, 40, a.stratum) stratum, 
a.stationid, a.bottom_depth, a.start_latitude, a.start_longitude, d.specimenid,
e.common_name, d.sex, d.length, d.weight, b.weight catch_weight
from racebase.haul a, racebase.catch b, racebase.specimen d , racebase.species e, race_data.v_cruises c
where a.region = 'BS' and a.cruise >= 199900
and b.species_code in (21740, 21720, 10110, 10210, 10130, 10261, 10285)
and a.hauljoin = b.hauljoin and b.hauljoin = d.hauljoin
and b.species_code = e.species_code and b.species_code = d.species_code and d.length != 0 and d.weight != 0
and a.cruisejoin = c.cruisejoin and c.survey_definition_id = 98 and a.stratum not in (82, 90)
and a.stratum between 10 and 62
