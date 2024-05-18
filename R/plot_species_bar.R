#' Make single species bar plots
#' 
#' Make condition time series bar plots for single species.
#' 
#' @param x Input data.frame
#' @param region Region. AI, BS, or GOA. Character (1L).
#' @param var_x_name Name of the x (time variable). Character (1L).
#' @param var_y_name Name of the y variable in the data.frame. Character (1L).
#' @param var_y_se_name Name of the standard error for the y variable. Character (1L).
#' @param y_title Y-axis title. Character (1L).
#' @param fill_colors Fill color to use for bars. Character (1L).
#' @param set_intercept Intercept to use for plots. Numeric (1L). 0 for residual, 1 for VAST relative condition, NULL for VAST a
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
#' write_plot = FALSE)
#' @export

plot_species_bar <- function(x, 
                             region, 
                             var_x_name = "year", 
                             var_y_name, 
                             var_y_se_name, 
                             fill_color = "#0085CA",
                             y_title = "Length-weight residual (ln(g))",
                             set_intercept = NULL,
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
  
  x$display_name <- akfishcondition::set_plot_order(x$common_name, 
                                                    region = region_order)
  
  names(x)[which(names(x) == var_x_name)] <- "var_x"
  names(x)[which(names(x) == var_y_name)] <- "var_y"
  names(x)[which(names(x) == var_y_se_name)] <- "var_y_se"
  x <- dplyr::filter(x, !is.na(var_y))
  
  # Anomalies
  x_anomaly <- x |>
    dplyr::group_by(common_name,
                    display_name) |>
    dplyr::summarise(mean_var_y = mean(var_y),
                     sd_var_y = sd(var_y))
  
  if(!is.null(set_intercept)) {
    x_anomaly$mean_var_y <- set_intercept
  }
  
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
    
    if(is.null(set_intercept)) {
      set_intercept <- 0
    }
    
    sel_anomaly <- dplyr::filter(x_anomaly, display_name ==  unique_groups[ii])
    
    p1 <- 
      ggplot() +
      geom_hline(data = sel_anomaly,
                 mapping = aes(yintercept = mean_var_y),
                 linetype = 1,
                 color = "grey50") +
      geom_hline(data = sel_anomaly,
                 mapping = aes(yintercept = mean_var_y + sd_var_y),
                 linetype = 2,
                 color = "grey50") +
      geom_hline(data = sel_anomaly,
                 mapping = aes(yintercept = mean_var_y - sd_var_y),
                 linetype = 2,
                 color = "grey50") +
      geom_hline(data = sel_anomaly,
                 mapping = aes(yintercept = mean_var_y + 2*sd_var_y),
                 linetype = 3,
                 color = "grey50") +
      geom_hline(data = sel_anomaly,
                 mapping = aes(yintercept = mean_var_y - 2*sd_var_y),
                 linetype = 3,
                 color = "grey50") +
      geom_linerange(data = x |> 
                       dplyr::filter(display_name == unique_groups[ii]),
                     mapping = aes(x = var_x,
                                   ymax = var_y + 2*var_y_se,
                                   ymin = var_y - 2*var_y_se),
                     color = "black") +
      geom_rect(data = x |> 
                  dplyr::filter(display_name == unique_groups[ii]),
                mapping = aes(xmin = var_x+0.4,
                              xmax = var_x-0.4,
                              ymax = var_y + var_y_se,
                              ymin = var_y - var_y_se),
                fill = fill_color) +
      geom_segment(data = x |> 
                     dplyr::filter(display_name == unique_groups[ii]), 
                   aes(x = var_x+0.4,
                       xend = var_x-0.4,
                       y = var_y,
                       yend = var_y,
                       group = var_x),
                   color = "black") +
      facet_grid(~display_name) +
      scale_x_continuous(name = "Year", breaks = scales::pretty_breaks(n = 4)) +
      scale_y_continuous(name = y_title,
                         trans = scales::trans_new("shift",
                                                   transform = function(x) {x-set_intercept},
                                                   inverse = function(x) {x+set_intercept})) +
      scale_fill_manual(name = )
    theme(legend.position = "none",
          title = element_text(hjust = 0.5))
    
    
    if(write_plot) {
      
      png(here::here("plots", region_dir, spp_dir,
                     paste0(region, "_CONDITION_", spp_dir, ".png")), 
          width = 6, height = 4, units = "in", res = 600)
      print(p1 + theme_blue_strip() + 
              theme(legend.position = "none",
                    title = element_text(hjust = 0.5)))
      dev.off()
    }
    
    out_list[ii] <- p1
    
  }
  
  
  return(out_list)
  
}