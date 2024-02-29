/* Query to retrieve stratum biomass for Aleutian Islands INPFC strata  */

select a.year, a.species_code, a.area_biomass, a.biomass_var, b.inpfc_area inpfc_stratum
from ai.biomass_inpfc a, (select inpfc_area, summary_area, sum(area) inpfc_Stratum_area from goa.goa_strata where nvl(stratum,1) != 0
and survey = 'AI' group by inpfc_area, summary_area) b where (a.year >= 1991) 
and a.species_code in
(21740,21741,21720,30420,10262,10110,30060,21921) 
and a.summary_Area = b.summary_area 
order by a.year, a.species_code, b.inpfc_Area