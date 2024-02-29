#' Default condition index theme
#' @export

theme_condition_index <- function() {
  theme_bw() %+replace%
    theme(plot.title = element_text(size = 20),
          panel.grid.major = element_blank(),
          axis.text.x = element_text(size = 22),
          axis.text.y = element_text(size = 22),
          axis.title.x = element_text(size = 26),
          axis.title.y = element_text(size = 26, angle = 90),
          legend.title = element_text(size = 26),
          legend.text = element_text(size = 24),
          legend.position = "right",
          panel.grid.minor = element_blank(),
          strip.text = element_text(size = 24,
                                    color = "white",
                                    face = "bold",
                                    margin = margin(0.5, 0, 0.5, 0, "mm")),
          strip.background = element_rect(fill = "#0055a4",
                                          color = NA))
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
          strip.text = element_text(size = 11, face = "bold"),
          strip.background = element_blank())
} 

#' Multi-panel map theme with blue strip
#' 
#' Theme for multipanel maps with blue strip
#' 
#' @export

theme_blue_strip <- function() {
  theme_bw() %+replace%
    theme(axis.title = element_text(color = "black", face = "bold", size = 10),
          axis.text = element_text(color = "black"),
          axis.ticks = element_line(color = "black"),
          axis.text.x = element_text(size = 9),
          axis.text.y = element_text(size = 9),
          panel.grid = element_blank(),
          legend.title = element_blank(),
          legend.position = "bottom",
          strip.text = element_text(size = 9,
                                    color = "white",
                                    face = "bold",
                                    margin = margin(0.5, 0, 0.5, 0, "mm")),
          strip.background = element_rect(fill = "#0055a4",
                                          color = NA))
}



#' Set species plotting order
#' @param common_name Vector of common names
#' @param region Character vector of length one indicating whether the region is AI, GOA, or BS
#' @export

set_plot_order <- function(common_name, region) {
  if(!(region %in% c("AI", "GOA", "BS", "EBS"))) {
    stop("Region must be either: AI, BS, or GOA")
  }
  if(region == "AI") {
    return(factor(common_name, 
                  levels = c("walleye pollock", 
                             "walleye pollock (>250 mm)",
                             "walleye pollock (100–250 mm)",
                             "Pacific cod",
                             "Pacific cod (juvenile)",
                             "Pacific cod (adult)",
                             "arrowtooth flounder",
                             "southern rock sole",
                             "Atka mackerel",
                             "northern rockfish",
                             "Pacific ocean perch"),
                  labels = c("walleye pollock", 
                             "walleye pollock (>250 mm)",
                             "walleye pollock (100–250 mm)",
                             "Pacific cod",
                             "Pacific cod (juvenile)",
                             "Pacific cod (adult)",
                             "arrowtooth flounder",
                             "southern rock sole",
                             "Atka mackerel",
                             "northern rockfish",
                             "Pacific ocean perch")))
  } else if(region == "GOA") {
  return(factor(common_name,
                levels = c("walleye pollock", 
                           "walleye pollock (>250 mm)",
                           "walleye pollock (100–250 mm)",
                           "Pacific cod",
                           "Pacific cod (juvenile)",
                           "Pacific cod (adult)",
                           "Pacific ocean perch",
                           "northern rockfish",
                           "dusky rockfish",
                           "shortraker rockfish", 
                           "rougheye rockfish", 
                           "blackspotted rockfish", 
                           "sharpchin rockfish",
                           "arrowtooth flounder",
                           "flathead sole",
                           "southern rock sole",
                           "northern rock sole",
                           "Dover sole", 
                           "rex sole"),
                labels = c("walleye pollock", 
                           "walleye pollock (>250 mm)",
                           "walleye pollock (100-250 mm)",
                           "Pacific cod",
                           "Pacific cod (juvenile)",
                           "Pacific cod (adult)",
                           "Pacific ocean perch", 
                           "northern rockfish",
                           "dusky rockfish",
                           "shortraker rockfish", 
                           "rougheye rockfish", 
                           "blackspotted rockfish", 
                           "sharpchin rockfish",
                           "arrowtooth flounder",
                           "flathead sole",
                           "southern rock sole",
                           "northern rock sole",
                           "Dover sole", 
                           "rex sole")))
  } else if(region %in% c("BS", "EBS")) {
    return(factor(common_name, 
                  levels = c("walleye pollock", 
                             "walleye pollock (>250 mm)",
                             "walleye pollock (100-250 mm)",
                             "Pacific cod",
                             "Pacific cod (juvenile)",
                             "Pacific cod (adult)",
                             "northern rock sole",
                             "yellowfin sole",
                             "arrowtooth flounder",
                             "Alaska plaice",
                             "flathead sole"),
                  labels = c("walleye pollock", 
                             "walleye pollock (>250 mm)",
                             "walleye pollock (100-250 mm)",
                             "Pacific cod",
                             "Pacific cod (juvenile)",
                             "Pacific cod (adult)",
                             "northern rock sole",
                             "yellowfin sole",
                             "arrowtooth flounder",
                             "Alaska plaice",
                             "flathead sole")))
}
}

#' Set stratum plotting order
#' 
#' @param common_name Vector of stratum names
#' @param region Character vector of length one indicating whether the region is AI, GOA, or BS
#' @export

set_stratum_order <- function(stratum, region) {
  region <- toupper(region)
  if(!(region %in% c("AI", "GOA", "BS"))) {
    stop("Region must be either: AI, BS, or GOA")
  }
  if(region == "GOA") {
    return(factor(stratum,
                  levels = c("Shumagin",
                             "Chirikof",
                             "Kodiak",
                             "Yakutat",
                             "Southeastern")))
  } else if(region == "AI") {
    return(factor(stratum,
                  levels = c("Southern Bering Sea", 
                             "Eastern Aleutians",
                             "Central Aleutians",
                             "Western Aleutians")))
  } else {
    return(factor(stratum))
  }
}