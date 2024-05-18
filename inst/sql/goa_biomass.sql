/* Query to retrieve stratum biomass for Gulf of Alaska INPFC strata  */

SELECT
     b.species_code,
     b.year,
     b.area_id,
     a.area_name inpfc_stratum,
     b.biomass_mt biomass,
     b.biomass_var
FROM
     gap_products.biomass b,
     gap_products.akfin_area a
WHERE
     b.species_code in (21740,21741,21720,30420,10262,10110,30060,30152,10261,10180,10200,10130,30576,30051,30052,30560) 
     AND b.survey_definition_id = 47
     AND b.area_id in (919, 929, 939, 949, 959)
     AND a.survey_definition_id = b.survey_definition_id
     AND a.area_id = b.area_id;