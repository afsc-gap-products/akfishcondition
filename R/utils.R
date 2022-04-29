#' Retrieve SQL query string from .sql files
#' 
#' This function extracts a query string from simple .sql file. The SQL file should only contain a comment block at the top and the SQL query itself.
#' 
#' @param sql_path File path to .sql file as a character vector.
#' @return Returns an SQL statement as a character vector, which can be executed on a database connection using functions in the RODBC or ROracle packages.
#' @noRd

sql_to_rqry <- function(sql_path) {
  in_string <- readr::read_file(sql_path)
  in_string <- sub("/*.*/", "", in_string)
  out_string <- stringr::str_replace_all(in_string, pattern = "\r\n", replacement = " ")
  
  return(out_string)
}


#' Create a database connection using RODBC
#'
#' A function that accepts a data source name, username, and password to establish returns an Oracle DataBase Connection (ODBC) as an RODBC class in R.
#'
#' @param schema Data source name (DSN) as a character vector.
#' @return An RODBC class ODBC connection.
#' @noRd

get_connected <- function(channel = NULL, schema = NA){
  if(is.null(channel)) {
    (echo = FALSE)
    if(is.na(schema)) {
      schema <- getPass::getPass(msg = "Enter ORACLE schema: ")
    }
    username <- getPass::getPass(msg = "Enter your ORACLE Username: ")
    password <- getPass::getPass(msg = "Enter your ORACLE Password: ")
    channel  <- RODBC::odbcConnect(dsn = paste(schema),
                                   uid = paste(username),
                                   pwd = paste(password),
                                   believeNRows = FALSE)
  }
  return(channel)
}

#' Get data for stratum-weighted and VAST methods
#' 
#' Retrieve length-weight, CPUE, and stratum-weighted biomass data from RACEBASE for the AI, GOA, EBS, and NBS using queries included in the akfishcondition package. Write output as csvs to /data/ directory.
#' 
#' @param channel RODBC channel
#' @export

get_condition_data <- function(channel = NULL) {
  
  if(!dir.exists("data")) {
    dir.create("data")
  }
  
  channel <- akfishcondition:::get_connected(channel = channel)
  
  for(i in c("goa","ebs", "nbs", "ai")){
    
    qry_cpue <- system.file(paste0("sql/VAST_", i, "_cpue.sql"), package = "akfishcondition")
    qry_stratum_biomass <- system.file(paste0("sql/", i, "_biomass.sql"), package = "akfishcondition")
    
    if(i %in% c("ebs", "nbs")) {
      qry_lw <- system.file(paste0("sql/VAST_", i, "_length_weight.sql"), package = "akfishcondition")
    } else {
      qry_lw <- system.file(paste0("sql/", i, "_length_weight.sql"), package = "akfishcondition")
    }
    
    dat_lw <- RODBC::sqlQuery(channel = channel, query = readr::read_file(qry_lw))
    dat_cpue <- RODBC::sqlQuery(channel = channel, query = readr::read_file(qry_cpue))
    dat_biomass <- RODBC::sqlQuery(channel = channel, query = readr::read_file(qry_stratum_biomass))
    
    if(class(dat_lw) != "data.frame") {
      message(print(dat_lw))
      stop("get_condition_data: RODBC error - no length/weight returned.")
    }
    
    if(class(dat_cpue) != "data.frame") {
      message(print(dat_cpue))
      stop("get_condition_data: RODBC error - no CPUE data returned.")
    }
    
    if(class(dat_biomass) != "data.frame") {
      message(print(dat_biomass))
      stop("get_condition_data: RODBC error - no stratum biomass data returned.")
    }
    
    names(dat_lw) <- casefold(names(dat_lw))
    names(dat_cpue) <- casefold(names(dat_cpue))
    names(dat_biomass) <- casefold(names(dat_biomass))
    combined_cpue_lw <- dplyr::bind_rows(dat_lw, dat_cpue)
    
    write.csv(combined_cpue_lw, paste0(getwd(),"/data/",i, "_all_species.csv"), row.names = FALSE)
    write.csv(dat_biomass, paste0(getwd(),"/data/",i, "_stratum_biomass_all_species.csv"), row.names = FALSE)
    
  }
}

#' Select species
#' 
#' Select length, weight, and CPUE (kg/km2) from csv files based on region and species code.
#' 
#' @param species_code RACE species code as a 1L numeric vector
#' @param region Region as a character vector. One of "GOA", "AI", "NBS", "EBS")
#' @noRd

select_species <- function(species_code, region){
  
  if(file.exists(paste0(getwd(),"/data/", region, "_all_species.csv"))) {
    all_species <- read.csv(paste0(getwd(),"/data/", region, "_all_species.csv"))
  } else {
    stop(paste0("select_species: Species file not found (", getwd(),"/data/", region, "_all_species.csv)"))
  }
  
  all_species$latitude <- as.numeric(all_species$latitude)
  all_species$longitude <- as.numeric(all_species$longitude)
  all_species$year <- as.numeric(all_species$year)
  all_species$cpue_kg_km2 <- as.numeric(all_species$cpue_kg_km2)
  
  specimen_sub <- all_species[which(all_species$species_code == species_code),]
  
  if(!(nrow(specimen_sub) > 1)) {
    stop(paste0("select_species: Species code", species_code, "not found for region ", region))
  }
  
  saveRDS(specimen_sub, paste0(getwd(),"/data/",species_code,"_Data_Geostat.Rds"))
  return(specimen_sub)
}  


#' Generate data summaries for QA/QC
#' 
#' Summaries of length-weight and CPUE data from a csv file containing the following columns: year, cruise, vessel, common_name, cpue_kg_km2, length_mm, weight_g, start_time
#' 
#' @param dat_csv csv file containing 
#' @param region Region name ("EBS", "NBS", "GOA" or "AI")
#' @noRd

make_data_summary <- function(dat_csv, region) {
  dat <- read.csv(file = dat_csv) |>
    dplyr::mutate(start_time = as.POSIXct(start_time)) |>
    dplyr::mutate(yday = lubridate::yday(start_time)) |>
    dplyr::arrange(year)
  
  n_spp_by_year <- dat |>
    dplyr::filter(!is.na(length_mm)) |>
    dplyr::group_by(common_name, year) |>
    dplyr::summarise(n = n()) 
  
  
  out <- list(n_cpue_by_year = dat |>
                dplyr::filter(!is.na(cpue_kg_km2)) |>
                dplyr::group_by(common_name, year) |>
                dplyr::summarise(n = n()) |>
                tidyr::pivot_wider(names_from = c("common_name"), values_from = "n", values_fill = 0) |>
                data.frame(),
              n_specimen_by_year = n_spp_by_year|>
                tidyr::pivot_wider(names_from = c("common_name"), values_from = "n", values_fill = 0) |>
                dplyr::arrange(year) |>
                data.frame(),
              n_specimen_by_vessel =dat |>
                dplyr::filter(!is.na(length_mm)) |>
                dplyr::group_by(vessel, cruise) |>
                dplyr::summarise(n = n()) |>
                tidyr::pivot_wider(names_from = c("vessel"), values_from = "n", values_fill = 0) |>
                dplyr::arrange(cruise) |>
                data.frame())
  
  saveRDS(object = out, file = here::here("output", region, paste0(region, "_sample_tables.rds")))
  
  yday_df <- dat |>
    dplyr::filter(!is.na(length_mm))
  
  yday_range <- range(yday_df$yday)
  yday_years <- unique(yday_df$year)
  
  
  png(file = here::here("output", region, paste0(region, "_species_samples.png")), width = 7, height = 7, units = "in", res = 120)
  print(ggplot(data = n_spp_by_year, 
               aes(x = year, y = n, color = common_name)) +
          geom_point() +
          geom_line() +
          scale_x_continuous(name = "Year") +
          scale_color_colorblind() +
          facet_wrap(~common_name, scales = "free_y") +
          theme_bw() +
          theme(legend.position = "none"))
  dev.off()
  
  for(jj in 1:ceiling(length(yday_years)/6)) {
    png(file = here::here("output", region, paste0(region, "_ecdf_samples_by_year_", jj, ".png")), width = 7, height = 7, units = "in", res = 120)
    print(ggplot(data = yday_df |>
                   dplyr::filter(year %in% yday_years[(1+6*(jj-1)):min(c((6+6*(jj-1)), length(yday_years)))]),
                 aes(x = yday, color = common_name)) +
            stat_ecdf(size = rel(1.2)) +
            facet_wrap(~year) +
            scale_color_colorblind() +
            scale_y_continuous(name = "Cumulative proportion of samples") +
            scale_x_continuous(name = "Day of Year",
                               limits = yday_range) +
            theme_few() +
            theme(legend.title = element_blank()))
    dev.off()
  }
  
  ecdf_files <- list.files(here::here('output', region), pattern = 'ecdf_samples_by_year', full.names = TRUE)
  
  # Make summary docx
  make_figs <- ""
  for(ii in 1:length(ecdf_files)) {
    make_figs <- paste0(make_figs,
                        "```{r echo=FALSE, fig.cap='\\\\label{fig:figs}Cumulative samples by day of year, by survey year.'}
  knitr::include_graphics('", ecdf_files[ii], "')
```\n\n")
  }
  
  fileConn<-file(here::here("output", region, paste0(region, "_data_summary.Rmd")))
  writeLines(paste0("---
title: '", region, " Condition Data Summary'
date: '", Sys.Date(),"'
output: word_document
---\n
```{r include=FALSE}
library(akfishcondition)
out <- readRDS(here::here('output','", region, "', paste0('", region, "' ,'_sample_tables.rds')))
```\n\n", make_figs, "
```{r echo=FALSE, fig.cap='\\\\label{fig:figs}Annual samples by species.'}
  knitr::include_graphics('", here::here("output", region, paste0(region, "_species_samples.png")), "')
```\n\n
```{r echo=FALSE}
knitr::kable(out$n_cpue_by_year, caption = 'Table 1. Hauls with CPUE by species')
```\n\n
```{r echo=FALSE}
knitr::kable(out$n_specimen_by_year, caption = 'Table 2. Number of length-weight samples by species and year')
```\n\n
```{r echo=FALSE}
knitr::kable(out$n_specimen_by_vessel, caption = 'Table 3. Number of length-weight samples by vessel and cruise')
```"), fileConn)
  close(fileConn)
  
  rmarkdown::render(input = here::here("output", region, paste0(region, "_data_summary.Rmd")),
                    output_file = here::here("output", region, paste0(region, "_data_summary.docx")))
  
}
