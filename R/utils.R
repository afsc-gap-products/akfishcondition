#' Retrieve SQL query string from .sql files
#' 
#' This function extracts a query strings from simple .sql file that only contain a comment block describing an SQL query and the query itself.
#' 
#' @param sql_path File path to .sql file as a character vector.
#' @export


sql_to_rqry <- function(sql_path) {
  in_string <- readr::read_file(sql_path)
  in_string <- sub("/*.*/", "", in_string)
  out_string <- stringr::str_replace_all(in_string, pattern = "\r\n", replacement = " ")
  
  return(in_string)
}


#' Connect to Oracle using RODBC
#' 
#' This function connects to oracle using RODBC.
#' 
#' @param schema Oracle dsn as a character vector.
#' @export

get_connected <- function(schema = NA){
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