#' Aleutian Islands (1986-2018)
#' 
#' Morphometric condition indicators based on residuals from a length-weight regression for Pacific cod, walleye pollock (> 250 mm), walleye pollock (100-250 mm), southern rock sole, arrowtooth flounder, Atka mackerel, northern rockfish, and Pacific ocean perch in the Aleutian Islands.
#' 
#' @format A list containing two data frames (indicator for the full region, indicator by stratum) and a character vector.
#' \describe{
#'      \itemize{
#'        \item FULL_REGION (data frame): Residuals for the full region
#'          \itemize{
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Year}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          }
#'        \item STRATUM (data frame): Residuals by stratum
#'         \itemize{
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Species Common name}
#'          \item{SPECIES_CODE}{: RACE/GAP species code}
#'          \item{INPFC_STRATUM}{: INPFC Stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{stratum_resid_sd}{: Standard error of the stratum mean residual}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_mean}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
"AI_INDICATOR"

#' Gulf of Alaska (1984-2021)
#' 
#' Morphometric condition indicators based on residuals from a length-weight regression for Pacific cod, walleye pollock (> 250 mm), walleye pollock (100-250 mm), southern rock sole, arrowtooth flounder, Atka mackerel, northern rockfish, and Pacific ocean perch in the Gulf of Alaska.
#' 
#' @format A list containing two data frames (indicator for the full region, indicator by stratum) and a character vector.
#' \describe{
#'      \itemize{
#'        \item FULL_REGION (data frame): Residuals for the full region
#'          \itemize{
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Year}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          }
#'        \item STRATUM (data frame): Residuals by stratum
#'         \itemize{
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Species Common name}
#'          \item{SPECIES_CODE}{: RACE/GAP species code}
#'          \item{INPFC_STRATUM}{: INPFC Stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{stratum_resid_sd}{: Standard error of the stratum mean residual}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_mean}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
"GOA_INDICATOR"

#' Eastern Bering Sea continental shelf (1999-2021)
#' 
#' Morphometric condition indicators based on residuals from a length-weight regression for Pacific cod, walleye pollock (> 250 mm), walleye pollock (100-250 mm), northern rock sole, arrowtooth flounder, flathead sole, Alaska plaice, and yellowfin sole in the eastern Bering Sea.
#' 
#' @format A list containing two data frames (indicator for the full region, indicator by stratum) and a character vector.
#' \describe{
#'      \itemize{
#'        \item FULL_REGION (data frame): Residuals for the full region
#'          \itemize{
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Year}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          }
#'        \item STRATUM (data frame): Residuals by stratum
#'         \itemize{
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Species Common name}
#'          \item{SPECIES_CODE}{: RACE/GAP species code}
#'          \item{INPFC_STRATUM}{: INPFC Stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{stratum_resid_sd}{: Standard error of the stratum mean residual}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_mean}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
"EBS_INDICATOR"

#' Northern Bering Sea (2010-2021)
#' 
#' Morphometric condition indicators based on residuals from a length-weight regression for Pacific cod, walleye pollock (> 250 mm), walleye pollock (100-250 mm), Alaska plaice, and yellowfin sole in the northern Bering Sea.
#' 
#' @format A list containing two data frames (indicator for the full region, indicator by stratum) and a character vector.
#' \describe{
#'      \itemize{
#'        \item FULL_REGION (data frame): Residuals for the full region
#'          \itemize{
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Species common name}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          }
#'        \item STRATUM (data frame): None for the NBS as of 2021
#'         \itemize{
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Species common name}
#'          \item{SPECIES_CODE}{: RACE/GAP species code}
#'          \item{INPFC_STRATUM}{: INPFC Stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{stratum_resid_sd}{: Standard error of the stratum mean residual}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_mean}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
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
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Year}
#'          \item{mean_wt_resid}{: Mean residual for the full region}
#'          \item{se_wt_resid}{: Standard error of the indicator for the full region}
#'          }
#'        \item STRATUM_* (data frame): Residuals by stratum
#'         \itemize{
#'          \item{YEAR}{: Year}
#'          \item{COMMON_NAME}{: Species Common name}
#'          \item{SPECIES_CODE}{: RACE/GAP species code}
#'          \item{INPFC_STRATUM}{: INPFC Stratum}
#'          \item{stratum_resid_mean}{: Unweighted stratum mean residual}
#'          \item{n}{: Sample size for the stratum}
#'          \item{stratum_resid_sd}{: Standard error of the stratum mean residual}
#'          \item{weighted_resid_mean}{: Stratum mean Residual weighted in proportion to stratum biomass}
#'          \item{weighted_resid_mean}{: Standard error of the stratum mean residual weighted in proportion to stratum biomass}
#'          }
#'        \item LAST_UPDATE: Date when indicator and data were last updated.
#'      }
#' }
#' @source \url{https://www.fisheries.noaa.gov/contact/groundfish-assessment-program}
"PCOD_ESP"