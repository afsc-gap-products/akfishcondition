/* Query to retrieve stratum biomass for Aleutian Islands INPFC strata  */

SELECT
     b.species_code,
     b.year,
     a.area_name inpfc_stratum,
     b.biomass_mt biomass,
     b.biomass_var
FROM
     gap_products.biomass b,
     gap_products.akfin_area a
WHERE
     b.species_code in (21740, 21720, 30420, 10262, 10110, 30060, 21921)
     AND b.survey_definition_id = 52
     AND b.area_id in (299, 799, 3499, 5699)
     AND a.survey_definition_id = b.survey_definition_id
     AND a.area_id = b.area_id;