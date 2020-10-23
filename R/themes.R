#' Default condition index theme
#' @export

theme_condition_index <- function() {
  theme_bw() %+replace%
    theme(plot.title = element_text(size = 18, face = "bold"),
          panel.grid.major = element_blank(),
          axis.text.x = element_text(size = 18),
          axis.text.y = element_text(size = 18),
          axis.title.x = element_text(size = 18),
          axis.title.y = element_text(size = 18, angle = 90),
          legend.title = element_text(size = 18, face = "bold"),
          legend.text = element_text(size = 18),
          legend.position = "right",
          panel.grid.minor = element_blank(),
          strip.text = element_text(size = 20),
          strip.background = element_blank())
} 

#' Default png theme
#' @export

theme_pngs <- function() {
  theme_bw() %+replace%
    theme(plot.title = element_text(size = 11, face = "bold"),
          panel.grid.major = element_blank(),
          axis.text.x = element_text(size = 11),
          axis.text.y = element_text(size = 11),
          axis.title.x = element_text(size = 11),
          axis.title.y = element_text(size = 11, angle = 90),
          legend.title = element_text(size = 11, face = "bold"),
          legend.text = element_text(size = 11),
          panel.grid.minor = element_blank(),
          strip.text = element_text(size = 11),
          strip.background = element_blank())
} 

#' Set species plotting order
#' @param COMMON_NAME Vector of common names
#' @param REGION Character vector of length one indicating whether the region is AI, GOA, or BS
#' @export

set_plot_order <- function(COMMON_NAME, REGION) {
  if(!(REGION %in% c("AI", "GOA", "BS"))) {
    stop("Region must be either: AI, BS, or GOA")
  }
  if(REGION == "AI") {
    return(factor(COMMON_NAME, 
                  levels = c("walleye pollock (>250 mm)",
                             "walleye pollock (100–250 mm)",
                             "Pacific cod",
                             "southern rock sole",
                             "arrowtooth flounder",
                             "Atka mackerel",
                             "northern rockfish",
                             "Pacific ocean perch"),
                  labels = c("walleye pollock (>250 mm)",
                             "walleye pollock (100–250 mm)",
                             "Pacific cod",
                             "southern rock sole",
                             "arrowtooth flounder",
                             "Atka mackerel",
                             "northern rockfish",
                             "Pacific ocean perch")))
  } else if(REGION == "GOA") {
  return(factor(COMMON_NAME,
                levels = c("walleye pollock (>250 mm)",
                           "walleye pollock (100–250 mm)",
                           "Pacific cod",
                           "arrowtooth flounder",
                           "southern rock sole",
                           "dusky rockfish",
                           "northern rockfish",
                           "Pacific ocean perch"),
                labels = c("walleye pollock (>250 mm)",
                           "walleye pollock (100–250 mm)",
                           "Pacific cod",
                           "arrowtooth flounder",
                           "southern rock sole",
                           "dusky rockfish",
                           "northern rockfish",
                           "Pacific ocean perch")))
  } else if(REGION == "BS") {
    return(factor(COMMON_NAME, 
                  levels = c("walleye pollock (>250 mm)",
                             "walleye pollock (100–250 mm)",
                             "Pacific cod",
                             "northern rock sole",
                             "yellowfin sole",
                             "arrowtooth flounder",
                             "Alaska plaice",
                             "flathead sole"),
                  labels = c("walleye pollock (>250 mm)",
                             "walleye pollock (100–250 mm)",
                             "Pacific cod",
                             "northern rock sole",
                             "yellowfin sole",
                             "arrowtooth flounder",
                             "Alaska plaice",
                             "flathead sole")))
}
}

#' Set stratum plotting order
#' @param COMMON_NAME Vector of stratum names
#' @param REGION Character vector of length one indicating whether the region is AI, GOA, or BS
#' @export

set_stratum_order <- function(STRATUM, REGION) {
  if(!(REGION %in% c("AI", "GOA"))) {
    stop("Region must be either: AI or GOA")
  }
  if(REGION == "GOA") {
    return(factor(STRATUM,
                  levels = c("Shumagin",
                             "Chirikof",
                             "Kodiak",
                             "Yakutat",
                             "Southeastern")))
  } else if(REGION == "AI") {
    return(factor(STRATUM,
                  levels = c("Southern Bering Sea", 
                             "Eastern Aleutians",
                             "Central Aleutians",
                             "Western Aleutians")))
  }
}