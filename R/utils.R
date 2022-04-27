#' Retrieve SQL query string from .sql files
#' 
#' This function extracts a query string from simple .sql file. The SQL file should only contain a comment block at the top and the SQL query itself.
#' 
#' @param sql_path File path to .sql file as a character vector.
#' @return Returns an SQL statement as a character vector, which can be executed on a database connection using functions in the RODBC or ROracle packages.
#' @export

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
    
    write.csv(combined_cpue_lw, paste0(getwd(),"/data/gcd_",i, "_all_species.csv"), row.names = FALSE)
    write.csv(dat_biomass, paste0(getwd(),"/data/stratum_biomass_",i, "_all_species.csv"), row.names = FALSE)
    
  }
}