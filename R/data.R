#' Aleutian Islands (1991-2024)
#' 
#' Morphometric condition indicators based on residuals from length-weight regressions for Pacific cod, walleye pollock (> 250 mm), walleye pollock (100-250 mm), southern rock sole, arrowtooth flounder, Atka mackerel, northern rockfish, and Pacific ocean perch in the Aleutian Islands.
#' 
#' @format A list containing two data frames (indicator for the full region, indicator by stratum) and a character vector.
#' \describe{
#'      \itemize{
#'        \item FULL_REGION (data frame): Residuals for the full region
#'          \itemize{
#'          \item{year}{: Year}
#'          \item{common_name}{: Year}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          }
#'        \item STRATUM (data frame): Residuals by stratum
#'         \itemize{
#'          \item{common_name}{: Species Common name}
#'          \item{year}{: Year}
#'          \item{inpfc_stratum}{: INPFC Stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{stratum_resid_se}{: Standard error of the stratum mean residual}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_se}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
#' @export
"AI_INDICATOR"

#' Gulf of Alaska (1990-2023)
#' 
#' Morphometric condition indicators based on residuals from length-weight regressions for Pacific cod, walleye pollock (> 250 mm), walleye pollock (100-250 mm), Pacific cod, northern rock sole, southern rock sole, arrowtooth flounder, Dover sole, rex sole, flathead sole, Atka mackerel, blackspotted rockfish, rougheye rockfish, northern rockfish, shortraker rockfish, shaprchin rockfish, and Pacific ocean perch in the Gulf of Alaska.
#' 
#' @format A list containing two data frames (indicator for the full region, indicator by stratum) and a character vector.
#' \describe{
#'      \itemize{
#'        \item FULL_REGION (data frame): Residuals for the full region
#'          \itemize{
#'          \item{year}{: Year}
#'          \item{common_name}{: Year}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          }
#'        \item STRATUM (data frame): Residuals by stratum
#'         \itemize{
#'          \item{common_name}{: Species Common name}
#'          \item{year}{: Year}
#'          \item{inpfc_stratum}{: INPFC Stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{stratum_resid_sd}{: Standard error of the stratum mean residual}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_se}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
#' @export
"GOA_INDICATOR"

#' Eastern Bering Sea continental shelf (1999-2022)
#' 
#' Morphometric condition indicators based on length-weight regressions for Pacific cod, walleye pollock (> 250 mm), walleye pollock (100-250 mm), northern rock sole, arrowtooth flounder, flathead sole, Alaska plaice, and yellowfin sole in the eastern Bering Sea.
#' 
#' @format A list containing two data frames (indicator for the full region, indicator by stratum) and a character vector.
#' \describe{
#'      \itemize{
#'        \item FULL_REGION (data frame): Residuals for the full region
#'          \itemize{
#'          \item{year}{: Year}
#'          \item{common_name}{: Year}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          \item{species_code}{: RACE/GAP species code}
#'          }
#'        \item STRATUM (data frame): Residuals by stratum
#'         \itemize{
#'          \item{common_name}{: Species Common name}
#'          \item{year}{: Year}
#'          \item{stratum}{: Survey Stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{stratum_resid_sd}{: Standard error of the stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_se}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
#' @export
"EBS_INDICATOR"

#' Northern Bering Sea (2010-2022)
#' 
#' Morphometric condition indicators based on length-weight regressions for Pacific cod, walleye pollock (> 250 mm), walleye pollock (100-250 mm), Alaska plaice, and yellowfin sole in the northern Bering Sea.
#' 
#' @format A list containing a data frames (indicator for the full region) and a character vector.
#' \describe{
#'      \itemize{
#'        \item FULL_REGION (data frame): Residuals for the full region
#'          \itemize{
#'          \item{year}{: Year}
#'          \item{common_name}{: Species common name}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          \item{species_code}{: RACE/GAP species code}
#'          \item{vast_relative_condition_se}{: Standard error of vast_relative_condition.}
#'          }
#'          \item STRATUM (data frame): Residuals by stratum
#'         \itemize{
#'          \item{common_name}{: Species Common name}
#'          \item{year}{: Year}
#'          \item{stratum}{: Survey stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{stratum_resid_sd}{: Standard error of the stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_se}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
#' @export
"NBS_INDICATOR"

#' Pacific cod Ecosystem and Socioeconomic Profile (ESP) indicator
#' 
#' Morphometric condition indicators based on residuals from a length-weight regression for adult and juvenile Pacific cod. Separate indicator for each region.
#' 
#' @format Eight data frames (indicator for the full region and indicator by stratum for the EBS, NBS, GOA, AI) and a character vector.
#' \describe{
#'      \itemize{
#'        \item FULL_REGION_* (data frame): Residuals for the full region
#'          \itemize{
#'          \item{year}{: Year}
#'          \item{common_name}{: Species common name}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          }
#'        \item STRATUM_* (data frame): Residuals by stratum
#'         \itemize{
#'          \item{year}{: Year}
#'          \item{common_name}{: Species Common name}
#'          \item{species_code}{: RACE/GAP species code}
#'          \item{inpfc_stratum}{: INPFC Stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{stratum_resid_sd}{: Standard error of the stratum mean residual}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_se}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
#' @export
"PCOD_ESP"



#' Settings for Ecosystem Status Reports
#' 
#' ESR species and VAST settings for ESR species.
#' 
#' @format A list containing two data.frames (list of species for each region, VAST settings)
#' \describe{
#'      \itemize{
#'        \item ESR_SPECIES (data frame): Species common names and species code to use for ESR regions
#'          \itemize{
#'            \item{common_name}{: Species common name}
#'            \item{species_code}{: RACE/GAP species code}
#'            \item{AI}{: Is the species used in the Aleutian Islands Ecosystem Status Report?}
#'            \item{GOA}{: Is the species used in the Gulf of Alaska Ecosystem Status Report?}
#'            \item{EBS}{: Is the EBS indicator used in the Bering Sea Ecosystem Status Report?}
#'            \item{NBS}{: Is the NBS indicator used in the Bering Sea Ecosystem Status Report?}
#'          }
#'          }
#'      \itemize{
#'        \item VAST_SETTINGS (data.frame): Settings to use for VAST
#'          \itemize{
#'           \item{species_code}{: RACE/GAP species code}
#'           \item{region}{: bottom trawl survey region}
#'           \item{ObsModel_1}{: Setting for ObsModel_1 in VAST}
#'           \item{ObsModel_2}{: Setting for ObsModel_2 in VAST}
#'           \item{ObsModel_3}{: Setting for ObsModel_3 in VAST}
#'           \item{ObsModel_4}{: Setting for ObsModel_4 in VAST}
#'           \item{fl_min}{: Minimum fork length to include in millimeters}
#'           \item{fl_max}{: Maximum fork length to include in millimeters}
#'           \item{n_knots}{: Number of vertices ("knots") to use to construct the SPDE mesh}
#'          }
#'          }
#'     }
#' @export        
"ESR_SETTINGS"


#' #' Ecosystem and Socioeconomic Profile (ESP) settings
#' #' 
#' #' ESP species and VAST settings for ESP species.
#' #' 
#' #' @format A list containing two data.frames (list of species for each region, VAST settings)
#' #' \describe{
#' #'      \itemize{
#' #'        \item ESP_SPECIES (data frame): Species common names and species code to use for ESR regions
#' #'          \itemize{
#' #'            \item{common_name}{: Species common name}
#' #'            \item{species_code}{: RACE/GAP species code}
#' #'            \item{AI}{: Is the species used in the Aleutian Islands Ecosystem Status Report?}
#' #'            \item{GOA}{: Is the species used in the Gulf of Alaska Ecosystem Status Report?}
#' #'            \item{EBS}{: Is the EBS indicator used in the Bering Sea Ecosystem Status Report?}
#' #'            \item{NBS}{: Is the NBS indicator used in the Bering Sea Ecosystem Status Report?}
#' #'          }
#' #'          }
#' #'        \item VAST_SETTINGS (data.frame): Settings to use for VAST
#' #'          \itemize{
#' #'           \item{species_code}{: RACE/GAP species code}
#' #'           \item{region}{: bottom trawl survey region}
#' #'           \item{ObsModel_1}{: Setting for ObsModel_1 in VAST}
#' #'           \item{ObsModel_2}{: Setting for ObsModel_2 in VAST}
#' #'           \item{ObsModel_3}{: Setting for ObsModel_3 in VAST}
#' #'           \item{ObsModel_4}{: Setting for ObsModel_4 in VAST}
#' #'           \item{fl_min}{: Minimum fork length to include in millimeters}
#' #'           \item{fl_max}{: Maximum fork length to include in millimeters}
#' #'           \item{n_knots}{: Number of vertices ("knots") to use to construct the SPDE mesh.}
#' #'          }
#' #'     }
#' #' @export   
#' "ESP_SETTINGS"