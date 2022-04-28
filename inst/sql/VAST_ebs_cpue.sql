/* Query to retrieve CPUE in kilograms per square kilometer from all eastern Bering Sea continental shelf strata for VAST. */

select a.hauljoin, a.start_latitude latitude, a.start_longitude longitude, a.stationid, b.species_code, b.year, b.wgtcpue cpue_kg_km2, d.common_name
                        from racebase.haul a, haehnr.ebsshelf_cpue b, race_data.v_cruises c, racebase.species d 
                        where b.year > 1998
                        and a.hauljoin = b.hauljoin
                        and a.haul_type in (3,13)
                        and a.cruisejoin = c.cruisejoin
                        and c.survey_definition_id = 98
                        and b.species_code = d.species_code
                        and b.species_code in (21740, 21720, 10110, 10210, 10130, 10261, 10285)
                        order by hauljoin
