#' Make condition time series plot
#' 
#' @param x Input data.frame
#' @param region Region. AI, BS, or GOA. Character (1L).
#' @param fill_color Fill color to use for points. Character (1L).
#' @param var_y_name Name of the y variable in the data.frame. Character (1L).
#' @param var_y_se_name Name of the standard error for the y variable. Character (1L).
#' @param var_x_name Name of the x (time variable). Character (1L).
#' @param y_title Y-axis title. Character (1L).
#' @param format_for "rmd" or "png"
#' @param set_intercept Intercept to use for plots. Numeric (1L). 0 for residual, 1 for vAST relative condition, NULL for VAST a
#' @return A ggplot object of the time series
#' @examples 
#' # EBS anomaly timeseries plot
#' 
#' names(EBS_INDICATOR$FULL_REGION)
#' 
#' plot_anomaly_timeseries(x = EBS_INDICATOR$FULL_REGION,
# 'region = "BS", 
#' fill_color = "#0085CA", 
#' var_y_name = "mean_wt_resid", 
#' var_y_se_name = "se_wt_resid",
#' var_x_name = "year",
#' y_title = "Length-weight residual (ln(g))",
#' format_for = "png")
#' @export

plot_anomaly_timeseries <- function(x, 
                                    region, 
                                    fill_color = "#0085CA", 
                                    var_y_name = "mean_wt_resid", 
                                    var_y_se_name = "se_wt_resid",
                                    var_x_name = "year",
                                    y_title = "Length-weight residual (ln(g))",
                                    format_for = "rmd",
                                    plot_type = "point",
                                    set_intercept = NULL) {
  
  region <- toupper(region)
  
  point_rel_size <- c(5, 2.5)[match(tolower(format_for), c("rmd", "png"))]
  
  stopifnot("Invalid region in plot_anomaly_timeseries. Must be 'BS', 'AI', or 'GOA'"  = (region %in% c("BS", "AI", "GOA")))
  
  x$display_name <- akfishcondition::set_plot_order(x$common_name, 
                                                    region = region)
  
  names(x)[which(names(x) == var_x_name)] <- "var_x"
  names(x)[which(names(x) == var_y_name)] <- "var_y"
  names(x)[which(names(x) == var_y_se_name)] <- "se_var_y"
  
  x <- dplyr::filter(x, !is.na(var_y))
  
  # Anomalies
  x_anomaly <- x %>%
    dplyr::group_by(common_name,
                    display_name) %>%
    dplyr::summarise(mean_var_y = mean(var_y),
                     sd_var_y = sd(var_y))
  
  if(!is.null(set_intercept)) {
    x_anomaly$mean_var_y <- set_intercept
  }
  
  # Make plot
  if(plot_type == "point") {
    p1 <- ggplot() + 
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y),
                 linetype = 1,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y + sd_var_y),
                 linetype = 2,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y - sd_var_y),
                 linetype = 2,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y + 2*sd_var_y),
                 linetype = 3,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y - 2*sd_var_y),
                 linetype = 3,
                 color = "grey50") +
      geom_linerange(data = x, 
                     aes(x = var_x, 
                         ymax = var_y + 2*se_var_y,
                         ymin = var_y - 2*se_var_y)) + 
      geom_point(data = x,
                 aes(x = var_x,
                     y = var_y),
                 fill = fill_color,
                 color = "black",
                 shape = 21,
                 size = rel(point_rel_size)) +
      facet_wrap(~display_name, ncol = 2, scales = "free_y") +
      scale_x_continuous(name = "Year", breaks = scales::pretty_breaks(n = 4)) +
      scale_y_continuous(name = y_title)
  } else if(plot_type == "bar") {
    
    if(is.null(set_intercept)) {
      set_intercept <- 0
    }
    
    p1 <- ggplot() + 
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y),
                 linetype = 1,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y + sd_var_y),
                 linetype = 2,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y - sd_var_y),
                 linetype = 2,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y + 2*sd_var_y),
                 linetype = 3,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y - 2*sd_var_y),
                 linetype = 3,
                 color = "grey50") +
      geom_linerange(data = x, 
                     aes(x = var_x, 
                         ymax = var_y + 2*se_var_y,
                         ymin = var_y - 2*se_var_y)) + 
      geom_bar(data = x, 
               aes(x = var_x, 
                   y = var_y),
               stat = "identity", 
               fill = fill_color, 
               color = "black",
               width = 1) +
      facet_wrap(~display_name, ncol = 2, scales = "free_y") +
      scale_x_continuous(name = "Year", 
                         breaks = scales::pretty_breaks(n = 4)) +
      scale_y_continuous(name = y_title,
                         trans = scales::trans_new("shift",
                                                   transform = function(x) {x-set_intercept},
                                                   inverse = function(x) {x+set_intercept}))
  } else if(plot_type == "box") {
    if(is.null(set_intercept)) {
      set_intercept <- 0
    }
    
    p1 <- ggplot() +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y),
                 linetype = 1,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y + sd_var_y),
                 linetype = 2,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y - sd_var_y),
                 linetype = 2,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y + 2*sd_var_y),
                 linetype = 3,
                 color = "grey50") +
      geom_hline(data = x_anomaly,
                 mapping = aes(yintercept = mean_var_y - 2*sd_var_y),
                 linetype = 3,
                 color = "grey50") +
      geom_linerange(data = x,
                     mapping = aes(x = var_x,
                                   ymax = var_y + 2*se_var_y,
                                   ymin = var_y - 2*se_var_y),
                     color = "black") +
      geom_rect(data = x,
                mapping = aes(xmin = var_x+0.4,
                              xmax = var_x-0.4,
                              ymax = var_y + se_var_y,
                              ymin = var_y - se_var_y),
                fill = fill_color) +
      geom_segment(data = x, 
                   aes(x = var_x+0.4,
                       xend = var_x-0.4,
                       y = var_y,
                       yend = var_y,
                       group = var_x),
                   color = "black") +
      facet_wrap(~display_name, ncol = 2, scales = "free_y") +
      scale_x_continuous(name = "Year", 
                         breaks = scales::pretty_breaks(n = 4)) +
      scale_y_continuous(name = y_title,
                         trans = scales::trans_new("shift",
                                                   transform = function(x) {x-set_intercept},
                                                   inverse = function(x) {x+set_intercept}))
  }
  
  return(p1)
  
}



#' Make condition time series stacked bar plot
#' 
#' @param x Input data.frame
#' @param region Region. AI, BS, or GOA. Character (1L).
#' @param var_y_name Name of the y variable in the data.frame. Character (1L).
#' @param var_y_se_name Name of the standard error for the y variable. Character (1L).
#' @param var_x_name Name of the x (time variable). Character (1L).
#' @param var_group_name Name of the variable to use for grouping (i.e., stratum). Character (1L).
#' @param y_title Y-axis title. Character (1L).
#' @param fill_title Name of the fill variable to use for plotting. Character (1L).
#' @return A ggplot object of the time series
#' @examples 
#' # EBS strata stacked bar plot
#' 
#' names(EBS_INDICATOR$STRATUM)
#' 
#' plot_stratum_stacked_bar(x = EBS_INDICATOR$STRATUM,
#' region = "BS",
#' fill_palette = "BrBG",
#' var_y_name = "stratum_resid_mean",
#' var_x_name = "year",
#' var_group_name = "stratum",
#' fill_title = "Stratum",
#' y_title = "Length-weight residual (ln(g))")
#' @export

plot_stratum_stacked_bar <- function(x, 
                                     region, 
                                     fill_palette = "BrBG",
                                     var_y_name = "mean_wt_resid", 
                                     var_x_name = "year",
                                     var_group_name = "stratum",
                                     fill_title = "Stratum",
                                     y_title = "Length-weight residual (ln(g))") {
  
  region <- toupper(region)
  
  stopifnot("Invalid region in plot_anomaly_timeseries. Must be 'BS', 'AI', or 'GOA'"  = (region %in% c("BS", "AI", "GOA")))
  
  x$display_name <- akfishcondition::set_plot_order(x$common_name, 
                                                    region = region)
  
  names(x)[which(names(x) == var_x_name)] <- "var_x"
  names(x)[which(names(x) == var_y_name)] <- "var_y"
  names(x)[which(names(x) == var_group_name)] <- "var_group"
  
  x <- dplyr::filter(x, !is.na(var_y))
  
  p1 <- ggplot(data = x, 
               aes(x = var_x, 
                   y = var_y, 
                   fill = set_stratum_order(trimws(var_group), 
                                            region = region))) + 
    geom_hline(yintercept = 0) +
    geom_bar(stat = "identity", 
             color = "black",
             position = "stack",
             width = 1) +
    facet_wrap(~display_name, ncol = 2, scales = "free_y") +
    scale_x_continuous(name = "Year") +
    scale_y_continuous(name = y_title) +
    scale_fill_brewer(name = fill_title, palette = fill_palette)
  
  return(p1)
  
}



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
#' @param fill_pallete Character vector denoting which color pallette to use. Must be a valid name for RColorBrewer::brewer.pal(name = {fill_palette})
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
      ggplot(data = x %>% 
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
#' @param set_intercept Intercept to use for plots. Numeric (1L). 0 for residual, 1 for vAST relative condition, NULL for VAST a
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
  x_anomaly <- x %>%
    dplyr::group_by(common_name,
                    display_name) %>%
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
      geom_linerange(data = x %>% 
                       dplyr::filter(display_name == unique_groups[ii]),
                     mapping = aes(x = var_x,
                                   ymax = var_y + 2*var_y_se,
                                   ymin = var_y - 2*var_y_se),
                     color = "black") +
      geom_rect(data = x %>% 
                  dplyr::filter(display_name == unique_groups[ii]),
                mapping = aes(xmin = var_x+0.4,
                              xmax = var_x-0.4,
                              ymax = var_y + var_y_se,
                              ymin = var_y - var_y_se),
                fill = fill_color) +
      geom_segment(data = x %>% 
                     dplyr::filter(display_name == unique_groups[ii]), 
                   aes(x = var_x+0.4,
                       xend = var_x-0.4,
                       y = var_y,
                       yend = var_y,
                       group = var_x),
                   color = "black") +
      # geom_bar(stat = "identity", 
      #          color = "black",
      #          fill = fill_color,
      #          width = 1) +
      # geom_linerange() + 
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



#' Two condition time series and correlation
#' 
#' @param x_1 A data.frame for the first time series.
#' @param x_2 A data.frame for the second time series.
#' @param region Region. AI, BS, or GOA. Character (1L).
#' @param fill_colors Fill colors to use for points. Character (2L).
#' @param var_y_name_1 Name of the y variable in the data.frame. Character (1L).
#' @param var_x_name_1 Name of the x (time variable). Character (1L).
#' @param var_y_name_2 Name of the y variable in the data.frame. Character (1L).
#' @param var_x_name_2 Name of the x (time variable). Character (1L).
#' @param scale_y Logical. Should y variables be Z-score transformed?
#' @param year_break Optional. Year to split a times series for geom_line(); denotes a break in the time series (i.e., EBS and NBS in 2020)
#' @param y_title Y-axis title. Character (1L).
#' @param x_offset Offset value to add to an x variable (e.g. year) from one of the time series to improve interpretability. Numeric (1L).
#' @param fill_title Name of the fill variable to use for plotting. Character (1L).
#' @param fill_color Fill colors to use for points.
#' @param shapes Shapes to use for points.
#' @param format_for "rmd" or "png"
#' @return A ggplot object of the time series
#' @export

plot_two_timeseries <- function(x_1,
                                x_2,
                                region,
                                series_name_1 = "Historical",
                                var_y_name_1 = "mean_wt_resid", 
                                var_x_name_1 = "year",
                                series_name_2 = "VAST",
                                var_y_name_2 = "mean_wt_resid", 
                                var_x_name_2 = "year",
                                var_group_name = "common_name",
                                y_title = "Condition (Z-score)",
                                fill_title = "Method",
                                scale_y = TRUE,
                                year_break = NULL,
                                x_offset = 0.25,
                                fill_colors = c("#001743", "#0085CA"), 
                                shapes = c(24, 21),
                                format_for = "rmd") {
  
  region <- toupper(region)
  
  point_rel_size <- c(5, 2.5)[match(tolower(format_for), c("rmd", "png"))]
  
  stopifnot("Invalid region in plot_anomaly_timeseries. Must be 'BS', 'AI', or 'GOA'"  = (region %in% c("BS", "AI", "GOA")))
  
  shared_cols <- c("var_x", "var_y", "var_y_se", "display_name", "common_name", "series")
  
  # Setup time series 1
  
  names(x_1)[which(names(x_1) == var_group_name)] <- "var_group"
  
  if(var_group_name == "common_name") {
    x_1$display_name <- akfishcondition::set_plot_order(x_1$var_group, 
                                                        region = region)
  } else {
    x_1$display_name <- x_1$var_group
  }
  
  names(x_1)[which(names(x_1) == var_x_name_1)] <- "var_x"
  names(x_1)[which(names(x_1) == var_y_name_1)] <- "var_y"
  x_1$series <- series_name_1
  x_1 <- x_1[, which(names(x_1) %in% shared_cols)]
  x_1 <- dplyr::filter(x_1, !is.na(var_y))
  
  # Setup time series 2
  names(x_2)[which(names(x_2) == var_group_name)] <- "var_group"
  
  if(var_group_name == "common_name") {
    x_2$display_name <- akfishcondition::set_plot_order(x_2$var_group, 
                                                        region = region)
  } else {
    x_2$display_name <- x_2$var_group
  }

  names(x_2)[which(names(x_2) == var_x_name_2)] <- "var_x"
  names(x_2)[which(names(x_2) == var_y_name_2)] <- "var_y"
  x_2$series <- series_name_2
  x_2 <- x_2[, which(names(x_2) %in% shared_cols)]
  x_2 <- dplyr::filter(x_2, !is.na(var_y))
  
  # Scale y variables
  if(scale_y) {
    x_1 <- x_1 %>%
      dplyr::group_by(common_name, display_name) %>%
      dplyr::mutate(var_y = scale(var_y)[,1])
    x_2 <- x_2 %>%
      dplyr::group_by(common_name, display_name) %>%
      dplyr::mutate(var_y = scale(var_y)[,1])
  }
  
  
  # Correlation between timeseries
  corr_df <- dplyr::inner_join(
    x_1 %>%
      dplyr::ungroup() %>%
      dplyr::rename(var_y_1 = var_y) %>%
      dplyr::select(display_name, 
                    var_x, 
                    var_y_1),
    x_2 %>%
      dplyr::ungroup() %>%
      dplyr::rename(var_y_2 = var_y) %>%
      dplyr::select(display_name, 
                    var_x, 
                    var_y_2),
    by = c("display_name", "var_x")) %>%
    dplyr::group_by(display_name) %>%
    dplyr::summarise(
      r = round(cor(var_y_1, 
                    var_y_2, 
                    use = "complete.obs",
                    method = "pearson"), 2))
  
  x_2$var_x <- x_2$var_x + x_offset
  x_combined <- dplyr::bind_rows(x_1, x_2)
  
  if(!is.null(year_break)) {
    x_combined$grp <- x_combined$var_x < year_break
  } else {
    x_combined$grp <- 1
  }
  
  max_x <- max(x_combined$var_x)
  min_x <- min(x_combined$var_x)
  lab_x <- max_x - (max_x - min_x)*0.12
  
  min_y <- min(x_combined$var_y)
  max_y <- max(x_combined$var_y)
  lab_y <- min_y + (max_y - min_y)*0.07
  
  # Make plot
  p1 <- ggplot() + 
    geom_hline(yintercept = 0,
               linetype = 1,
               color = "grey50") +
    geom_hline(yintercept = c(-1,1),
               linetype = 2,
               color = "grey50") +
    geom_hline(yintercept = c(-2,2),
               linetype = 3,
               color = "grey50") +
    geom_point(data = x_combined, 
               aes(x = var_x, 
                   y = var_y, 
                   fill = series,
                   shape = series),
               color = "black",
               size = rel(point_rel_size)) +
    geom_text(data = corr_df,
              aes(x = lab_x,
                  y = lab_y,
                  label = paste0("r = ", format(r, nsmall = 2))),
              size = rel(point_rel_size*1.9)) +
    scale_fill_manual(name = fill_title, 
                      values = fill_colors) +
    scale_shape_manual(name = fill_title, 
                       values = shapes) +
    facet_wrap(~display_name, ncol = 2) +
    scale_x_continuous(name = "Year", breaks = scales::pretty_breaks(n = 4)) +
    scale_y_continuous(name = y_title, limits = c(range(x_combined$var_y)))
  
  return(p1)
  
}



#' Plot of condition versus condition
#' 
#' @param x_1 A data.frame for the first time series.
#' @param x_2 A data.frame for the second time series.
#' @param region Region. AI, BS, or GOA. Character (1L).
#' @param fill_colors Fill colors to use for points. Character (2L).
#' @param var_y_name_1 Name of the y variable in the data.frame. Character (1L).
#' @param var_y_se_name_1 Name of the standard error for the y variable. Character (1L).
#' @param var_x_name_1 Name of the x (time variable). Character (1L).
#' @param var_y_name_2 Name of the y variable in the data.frame. Character (1L).
#' @param var_y_se_name_2 Name of the standard error for the y variable. Character (1L).
#' @param var_x_name_2 Name of the x (time variable). Character (1L).
#' @param scale_y Logical. Should y variables be Z-score transformed?
#' @param y_title Y-axis title. Character (1L).
#' @param format_for "rmd" or "png"
#' @return A ggplot object of the time series
#' @export

plot_xy_corr <- function(x_1,
                         x_2,
                         region,
                         series_name_1 = "Historical",
                         var_y_name_1 = "mean_wt_resid", 
                         var_y_se_name_1 = "se_wt_resid",
                         var_x_name_1 = "year",
                         series_name_2 = "VAST",
                         var_y_name_2 = "mean_wt_resid", 
                         var_y_se_name_2 = "se_wt_resid",
                         var_x_name_2 = "year",
                         format_for = "rmd") {
  
  region <- toupper(region)
  
  point_rel_size <- c(5, 2.5)[match(tolower(format_for), c("rmd", "png"))]
  
  stopifnot("Invalid region in plot_anomaly_timeseries. Must be 'BS', 'AI', or 'GOA'"  = (region %in% c("BS", "AI", "GOA")))
  
  shared_cols <- c("var_x", "var_y", "var_y_se", "display_name", "common_name", "series")
  
  # Setup time series 1
  x_1$display_name <- akfishcondition::set_plot_order(x_1$common_name, 
                                                      region = region)
  names(x_1)[which(names(x_1) == var_x_name_1)] <- "var_x"
  names(x_1)[which(names(x_1) == var_y_name_1)] <- "var_y"
  names(x_1)[which(names(x_1) == var_y_se_name_1)] <- "var_y_se"
  x_1$series <- series_name_1
  x_1 <- x_1[, which(names(x_1) %in% shared_cols)]
  x_1 <- dplyr::filter(x_1, !is.na(var_y))
  
  # Setup time series 2
  x_2$display_name <- akfishcondition::set_plot_order(x_2$common_name, 
                                                      region = region)
  names(x_2)[which(names(x_2) == var_x_name_2)] <- "var_x"
  names(x_2)[which(names(x_2) == var_y_name_2)] <- "var_y"
  names(x_2)[which(names(x_2) == var_y_se_name_2)] <- "var_y_se"
  x_2$series <- series_name_2
  x_2 <- x_2[, which(names(x_2) %in% shared_cols)]
  x_2 <- dplyr::filter(x_2, !is.na(var_y))

  # Correlation between timeseries
  x_combined <- dplyr::inner_join(
    x_1 %>%
      dplyr::ungroup() %>%
      dplyr::rename(var_y_1 = var_y,
                    var_y_se_1 = var_y_se) %>%
      dplyr::select(display_name, 
                    var_x, 
                    var_y_1,
                    var_y_se_1),
    x_2 %>%
      dplyr::ungroup() %>%
      dplyr::rename(var_y_2 = var_y,
                    var_y_se_2 = var_y_se) %>%
      dplyr::select(display_name, 
                    var_x, 
                    var_y_2,
                    var_y_se_2),
    by = c("display_name", "var_x")) %>%
    dplyr::ungroup()
  
  
  corr_df <- x_combined %>%
    dplyr::group_by(display_name) %>%
    dplyr::summarise(
      r = round(cor(var_y_1, 
                    var_y_2, 
                    use = "complete.obs",
                    method = "pearson"), 2))
  
  corr_df <- corr_df %>%
    dplyr::inner_join(
      x_combined %>%
        dplyr::group_by(display_name) %>%
        dplyr::summarise(min_x = min(var_y_1-2*var_y_se_1),
                         max_x = max(var_y_1+2*var_y_se_1),
                         min_y = min(var_y_2-2*var_y_se_2),
                         max_y = max(var_y_2+2*var_y_se_2)) %>%
        dplyr::mutate(lab_x = max_x - (max_x - min_x)*0.12,
                      lab_y = min_y + (max_y - min_y)*0.07),
      by = "display_name")
  
  # Make plot
  p1 <- ggplot() + 
    geom_linerange(data = x_combined,
               aes(x = var_y_1,
                   ymin = var_y_2 - 2 * var_y_se_2,
                   ymax = var_y_2 + 2 * var_y_se_2),
               color = "black") +
      geom_linerange(data = x_combined,
                    aes(y = var_y_2,
                        xmin = var_y_1 - 2 * var_y_se_1,
                        xmax = var_y_1 + 2 * var_y_se_1),
                    color = "black") +
    geom_point(data = x_combined,
              aes(x = var_y_1,
                  y = var_y_2),
              color = "black",
              size = rel(point_rel_size)) +
    geom_text(data = corr_df,
              aes(x = lab_x,
                  y = lab_y,
                  label = paste0("r = ", format(r, nsmall = 2))),
              size = rel(point_rel_size*1.9)) +
    facet_wrap(~display_name, ncol = 2, scale = "free") +
    scale_x_continuous(name = series_name_1, breaks = scales::pretty_breaks()) +
    scale_y_continuous(name = series_name_2)
  
  return(p1)
  
}



#' Generate tables with b coefficient and VAST Settings
#' 
#' Generate tables containing settings for VAST and the VAST estimate of the allometric slope of the length-weight (b in W = a*L^b) relationship.
#' 
#' @param region One or more region as a character vector ("EBS", "NBS", "AI", "GOA")
#' @param write_table Should the table be written as a .csv file to /plots/[region]/[region]_VAST_summary_table.csv?
#' @export

make_vast_table <- function(region, write_table = TRUE) {
  
  library(VAST)

  output_region_dir <- c("BS", "BS", "AI", "GOA")[match(region, c("EBS", "NBS", "AI", "GOA"))]
  
  sel_region <- region
  
  sel_spp <- dplyr::filter(akfishcondition::ESR_SETTINGS$VAST_SETTINGS, 
                           region %in% sel_region )
  
  out_df <- data.frame()
  
  for(ii in 1:length(sel_spp)) {
    vast_file <- here::here("results", 
                            sel_spp$region[ii], 
                            sel_spp$species_code[ii],
                            paste0(sel_spp$species_code[ii], "_VASTfit.rds"))
    
    if(file.exists(vast_file)) {
      message("make_vast_tables: Reading VASTfit.rds for species ", sel_spp$species_code[ii], " in ", sel_spp$region[ii], ".")
      vast_fit <- readRDS(file = vast_file)
      
      if(!is.na(vast_fit$parameter_estimates$SD$par.fixed['log_sigmaPhi2_k'])) {
        bb <- vast_fit$parameter_estimates$SD$par.fixed['lambda2_k']
        se <- exp(vast_fit$parameter_estimates$SD$par.fixed['log_sigmaPhi2_k'])
      } else {
        fixed_summary <- summary(vast_fit$parameter_estimates$SD, "fixed")
        bb <- fixed_summary[which(row.names(fixed_summary) == "lambda2_k"), 1]
        se <- fixed_summary[which(row.names(fixed_summary) == "lambda2_k"), 2]
      }

      
      out_df <- dplyr::bind_rows(out_df,
                                 dplyr::bind_cols(sel_spp[ii,],
                                                  data.frame(b_est = bb,
                                                             b_se = se,
                                                             max_gradient = vast_fit$parameter_estimates['max_gradient']$max_gradient,
                                                             convergence_check = vast_fit$parameter_estimates['Convergence_check']$Convergence_check,
                                                             knots_match = vast_fit$spatial_list$n_x == sel_spp$n_knots[ii])))
      
    } else {
      warning("\nmake_vast_tables: VASTfit file for species ", sel_spp$species_code[ii], " in ", sel_spp$region[ii], " cannot be found in ", vast_file, "\n")
    }
  }
  
  if(write_table) {
    if(length(region) > 1) {
      out_loc <- here::here("plots", paste0(paste0(region, collapse = "_"), "_VAST_summary_table.csv"))
    } else {
      out_loc <- here::here("plots", output_region_dir, paste0(region, "_VAST_summary_table.csv"))
    }
    
    message("make_vast_tables: Writing table to ", out_loc)
    
    write.csv(x = out_df, file = out_loc, row.names = FALSE)
    
  }
  
  row.names(out_df) <- 1:nrow(out_df)
  
  return(out_df)
  
}