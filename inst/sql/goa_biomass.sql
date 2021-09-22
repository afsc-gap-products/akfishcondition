/* Query to retrieve stratum biomass for Gulf of Alaska INPFC strata 
Prepared by: Ned Laman (ned.laman@noaa.gov), AFSC/RACE/GAP
Query updated: September 22, 2021 */

select a.year, a.species_code, a.haul_count, a.catch_count, a.area_biomass, a.biomass_var, b.inpfc_area inpfc_stratum, b.inpfc_stratum_area
from goa.biomass_inpfc a, (select inpfc_area, summary_area, sum(area) inpfc_Stratum_area from goa.goa_strata where nvl(stratum,1) != 0
and survey = 'GOA' group by inpfc_area, summary_area) b where (a.year >= 1984 and a.year != 1989) 
and a.species_code in
(21740,21741,21720,30420,10262,10110,30060,30152) 
and a.summary_Area = b.summary_area 
order by a.year, a.species_code, b.inpfc_Area