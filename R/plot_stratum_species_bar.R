#' Make single species stratum bar plots
#' 
#' Make condition time series bar plots with separate panels for each stratum.
#' 
#' @param x Input data.frame
#' @param region Region. AI, BS, or GOA. Character (1L).
#' @param var_x_name Name of the x (time variable). Character (1L).
#' @param var_y_name Name of the y variable in the data.frame. Character (1L).
#' @param var_y_se_name Name of the standard error for the y variable. Character (1L).
#' @param y_title Y-axis title. Character (1L).
#' @param fill_title Name of the fill variable to use for plotting. Character (1L).
#' @param fill_palette Character vector denoting which color palette to use. Must be a valid name for RColorBrewer::brewer.pal(name = {fill_palette})
#' @param var_group_name Name of the variable to use for grouping (i.e., stratum). Character (1L).
#' @param write_plot Should plots be written to the /plot/ directory?
#' @return A list of bar plots as ggplot objects
#' @examples 
#' # EBS single species stratum bar plots
#' 
#' names(EBS_INDICATOR$STRATUM)
#' 
#' plot_species_stratum_bar(
#' x = EBS_INDICATOR$STRATUM,
#' region = "BS",
#' var_x_name = "year",
#' var_y_name = "stratum_resid_mean",
#' var_y_se_name = "stratum_resid_se",
#' y_title = "Length-weight residual (ln(g))",
#' var_group_name = "stratum",
#' fill_title = "Stratum",
#' fill_palette = "BrBG",
#' write_plot = FALSE)
#' @export

plot_species_stratum_bar <- function(x, 
                                     region, 
                                     var_x_name, 
                                     var_y_name, 
                                     var_y_se_name, 
                                     y_title = "Length-weight residual (ln(g))", 
                                     var_group_name = "stratum", 
                                     fill_title = "Stratum",  
                                     fill_palette = "BrBG", 
                                     write_plot = TRUE) {
  
  region <- toupper(region)
  
  stopifnot("Invalid region in plot_anomaly_timeseries. Must be 'EBS', 'NBS', 'AI', or 'GOA'" = (region %in% c("EBS", "NBS", "AI", "GOA")))
  
  if(region %in% c("EBS", "NBS")) {
    region_dir <- "BS"
    region_order <- "BS"
  } else {
    region_dir <- region
    region_order <- region
  }
  
  names(x)[which(names(x) == var_x_name)] <- "var_x"
  names(x)[which(names(x) == var_y_name)] <- "var_y"
  names(x)[which(names(x) == var_group_name)] <- "var_group"
  names(x)[which(names(x) == var_y_se_name)] <- "var_y_se"
  x <- dplyr::filter(x, !is.na(var_y))
  
  x$display_name <- akfishcondition::set_plot_order(x$common_name, region = region_order)
  
  unique_groups <- unique(x$display_name)
  
  out_list <- list()
  for(ii in 1:length(unique_groups)) {
    
    if(is.na(unique_groups[ii])) {
      next
    }
    
    spp_dir <- gsub(pattern = ">", replacement  = "gt", unique_groups[ii])
    
    if(!dir.exists(here::here("plots", region_dir, spp_dir))) {
      dir.create(here::here("plots", region_dir, spp_dir), recursive = TRUE)
    }
    
    p1 <- 
      ggplot(data = x |> 
               dplyr::filter(display_name == unique_groups[ii]),
             aes(x = var_x, 
                 y = var_y, 
                 fill = set_stratum_order(trimws(var_group), region = region_order),
                 ymin = var_y - 2*var_y_se,
                 ymax = var_y + 2*var_y_se)) +
      geom_hline(yintercept = 0) +
      geom_linerange() +
      geom_bar(stat = "identity", 
               color = "black", 
               position = "stack", 
               width = 1) +
      facet_wrap(~set_stratum_order(trimws(var_group), 
                                    region = region_order), 
                 ncol = 2, 
                 scales = "free_y") +
      ggtitle(unique_groups[ii]) +
      scale_x_continuous(name = "Year", breaks = scales::pretty_breaks()) +
      scale_y_continuous(name = y_title) +
      scale_fill_brewer(name = fill_title, 
                        palette = fill_palette, 
                        drop = FALSE) +
      theme(legend.position = "none",
            title = element_text(hjust = 0.5))
    
    
    if(write_plot) {
      
      png(here::here("plots", region_dir, spp_dir,
                     paste0(region, "_STRATUM_CONDITION_", spp_dir, ".png")), 
          width = 6, height = 7, units = "in", res = 600)
      print(p1 + theme_blue_strip() + 
              theme(legend.position = "none",
                    title = element_text(hjust = 0.5)))
      dev.off()
    }
    
    out_list[ii] <- p1
    
  }
  
  
  return(out_list)
  
}