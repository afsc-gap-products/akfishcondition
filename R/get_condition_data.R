
#' Get data for index calculations
#'
#' Retrieve length-weight, and catch data, derive subarea biomass, and write outputs to .csv files in /data/.
#'
#' @param channel RODBC channel
#' @param species_by_region A named list containing numeric vectors with SPECIES_CODES to use for the indicator.
#' @param subareas_by_region A named list containing numeric vectors with subarea AREA_ID numbers to use for indicator calculations.
#' @param start_year_by_region A named list of numeric vectors indicating the start year for the indicator.
#' @export

get_condition_data <- function(
    channel = NULL, 
    species_by_region = NULL,
    subareas_by_region = NULL,
    start_year_by_region = NULL) {
  
  if(is.null(channel)) {
    channel <- gapindex::get_connected()
  }
  
  if(!dir.exists("data")) {
    dir.create("data")
  }
  
  if(is.null(species_by_region)) {
    
    species_by_region <-
      list(
        "EBS" = c(21740, 21720, 10110, 10210, 10130, 10261, 10285),
        "NBS" = c(21740, 21720, 10210, 10285),
        "GOA" = c(21740, 21720, 30420, 10262, 10110, 30060, 30152, 10261, 
                  10180, 10200, 10130, 30576, 30051, 30052, 30560),
        "AI" = c(21740, 21720, 30420, 10262, 10110, 30060, 21921)
      )
    
  }
  
  names(species_by_region) <- toupper(names(species_by_region))
  
  if(is.null(subareas_by_region)) {
    
    subareas_by_region <-
      list(
        "EBS" = c(1:6),
        "NBS" = c(70, 71, 81),
        "GOA" = c(610, 620, 630, 640, 650),
        "AI" = c(299, 799, 3499, 5699)
      )
    
  }
  
  names(subareas_by_region) <- toupper(names(subareas_by_region))
  
  if(is.null(start_year_by_region)) {
    
    start_year_by_region <-
      list(
        "EBS" = 1999,
        "NBS" = 2010,
        "GOA" = 1990,
        "AI" = 1991
      )
    
  }
  
  for(ii in 1:length(species_by_region)) {
    
    sel_region <- names(species_by_region)[[ii]]
    
    gapdata <- 
      gapindex::get_data(
        survey_set = sel_region,
        year_set = start_year_by_region[[sel_region]]:as.numeric(format(Sys.time(), "%Y")),
        channel = channel,
        spp_codes = species_by_region[[sel_region]]
      )
    
    # Reassign 1990-2023 GOA hauls to 2025 strata
    if(sel_region == "GOA") {
      message("get_condition_data: Post-stratifying GOA hauls.")
      gapdata <- poststratify_goa_hauls(gapdata = gapdata)
      
    }
    
    cpue <- 
      gapindex::calc_cpue(
        gapdata = gapdata
      )
    
    biomass_stratum <- 
      gapindex::calc_biomass_stratum(
        gapdata = gapdata,
        cpue = cpue
      )
    
    biomass_subarea <-
      gapindex::calc_biomass_subarea(
        gapdata = gapdata,
        biomass_stratum = biomass_stratum
      )
    
    if(sel_region == "NBS") {
      biomass_results <- biomass_stratum[biomass_stratum$STRATUM %in% subareas_by_region[[sel_region]], ]
      names(biomass_results)[names(biomass_results) == "STRATUM"] <- "AREA_ID"
    } else {
      biomass_results <- biomass_subarea[biomass_subarea$AREA_ID %in% subareas_by_region[[sel_region]], ]
    }
    
    
    # Get all length-weight samples (uses RACEBASE because, as of March 2025, gapindex only selects
    # LW samples that have been aged)
    lw_specimens <- 
      RODBC::sqlQuery(
        channel = channel,
        query = paste0("SELECT s.hauljoin, s.specimenid, s.species_code, s.length, s.weight, s.sex, s.age FROM racebase.specimen s, racebase.haul h
        WHERE
          h.region = '", ifelse(sel_region %in% c("NBS", "EBS"), "BS", sel_region), "' ",
                       "AND s.hauljoin = h.hauljoin 
           AND s.species_code in (", paste(species_by_region[[sel_region]], collapse = ", "), ")
           AND h.cruise >= ", min(gapdata$cruise$CRUISE),
                       " AND s.weight != 0
           AND s.length != 0")
      )
    
    # Append common names
    species_names <- 
      RODBC::sqlQuery(
        channel = channel,
        query = 
          paste0("SELECT DISTINCT 
                  species_code, 
                  common_name 
                 FROM 
                  gap_products.taxonomic_classification 
                 WHERE
                  species_code in (", paste(species_by_region[[sel_region]], collapse = ", "), ")")
      )
    
    # Only specimens from index station hauls
    lw_specimens <- lw_specimens[lw_specimens$HAULJOIN %in% gapdata$haul$HAULJOIN, ]
    
    # Format data for subsequent functions
    haul <- gapdata$haul |>
      dplyr::mutate(
        latitude = (START_LATITUDE + END_LATITUDE)/2,
        longitude = (START_LONGITUDE + END_LONGITUDE)/2,
        year = floor(CRUISE/100)
      )
    
    # Add AREA_ID field
    if(sel_region == "NBS") {
      haul$AREA_ID <- haul$STRATUM
    } else {
      subareas_groups <- 
        gapdata$stratum_groups |>
        dplyr::filter(
          DESIGN_YEAR == max(gapdata$stratum_groups$DESIGN_YEAR),
          AREA_ID %in% subareas_by_region[[sel_region]]
        ) |>
        dplyr::select(AREA_ID, STRATUM)
      
      haul <- dplyr::inner_join(haul, subareas_groups, by = "STRATUM")
    }

    
    names(lw_specimens) <- tolower(names(lw_specimens))
    names(biomass_results) <- tolower(names(biomass_results))
    names(cpue) <- tolower(names(cpue))
    names(haul) <- tolower(names(haul))
    names(species_names) <- tolower(names(species_names))

    combined_cpue_lw <- 
      lw_specimens |> 
      dplyr::inner_join(
        haul, 
        by = join_by("hauljoin")
      ) |>
      dplyr::inner_join(species_names, by = "species_code") |>
      dplyr::select(
        hauljoin, 
        vessel, 
        cruise, 
        haul, 
        stratum, 
        area_id,
        year,
        latitude, 
        longitude, 
        start_time, 
        species_code, 
        common_name,
        specimenid,
        length_mm = length,
        weight_g = weight,
        age,
        sex
      ) |>
      dplyr::bind_rows(
        cpue |> 
          dplyr::inner_join(
            haul, 
            by = join_by("cruise", "cruisejoin", "hauljoin", "stratum", "year")
          ) |>
          dplyr::inner_join(species_names, by = "species_code") |>
          dplyr::select(
            hauljoin, 
            vessel, 
            cruise, 
            haul, 
            stratum, 
            area_id,
            year,
            latitude, 
            longitude, 
            start_time, 
            species_code, 
            common_name,
            stationid, 
            cpue_kg_km2 = cpue_kgkm2,
            number_fish = count,
            cpue_no_km2 = cpue_nokm2,
            effot_km2 = area_swept_km2) 
      )
    
    biomass_by_stratum <-
      biomass_results |>
      dplyr::inner_join(species_names, by = "species_code") |>
      dplyr::select(species_code, year, area_id, biomass_mt, biomass_var)
    
    write.csv(combined_cpue_lw, paste0(getwd(),"/data/",sel_region, "_all_species.csv"), row.names = FALSE)
    write.csv(biomass_by_stratum, paste0(getwd(),"/data/",sel_region, "_stratum_biomass_all_species.csv"), row.names = FALSE)
    
  }
  
}