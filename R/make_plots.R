#' Generate condition time series plot
#' 
#' @param x Input data.frame
#' @param region Region. AI, BS, or GOA. Character (1L).
#' @param fill_color Fill color to use for points. Character (1L).
#' @param var_y_name Name of the y variable in the data.frame. Character (1L).
#' @param var_y_se_name Name of the standard error for the y variable. Character (1L).
#' @param var_x_name Name of the x (time variable). Character (1L).
#' @param y_title Y-axis title. Character (1L).
#' @param format_for "rmd" or "png"
#' @return A ggplot object of the time series
#' @export

plot_anomaly_timeseries <- function(x, 
                                    region, 
                                    fill_color = "#0085CA", 
                                    var_y_name = "mean_wt_resid", 
                                    var_y_se_name = "se_wt_resid",
                                    var_x_name = "year",
                                    y_title = "Length-weight residual (ln(g))",
                                    format_for = "rmd") {
  
  region <- toupper(region)
  
  point_rel_size <- c(5, 2.5)[match(tolower(format_for), c("rmd", "png"))]
  
  stopifnot("Invalid region in plot_anomaly_timeseries. Must be 'BS', 'AI', or 'GOA'"  = (region %in% c("BS", "AI", "GOA")))
  
  x$display_name <- akfishcondition::set_plot_order(x$common_name, 
                                                    region = region)
  
  names(x)[which(names(x) == var_x_name)] <- "var_x"
  names(x)[which(names(x) == var_y_name)] <- "var_y"
  names(x)[which(names(x) == var_y_se_name)] <- "se_var_y"
  
  # Anomalies
  x_anomaly <- x %>%
    dplyr::group_by(common_name,
                    display_name) %>%
    dplyr::summarise(mean_var_y = mean(var_y),
                     sd_var_y = sd(var_y))
  
  # Make plot
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
    geom_errorbar(data = x, 
                  aes(x = var_x, 
                      ymax = var_y + 2*se_var_y,
                      ymin = var_y - 2*se_var_y),
                  width = 0) +
    geom_point(data = x, 
               aes(x = var_x, 
                   y = var_y),
               stat = "identity", 
               fill = fill_color, 
               color = "black",
               shape = 21,
               size = rel(point_rel_size)) +
    facet_wrap(~display_name, ncol = 2, scales = "free_y") +
    scale_x_continuous(name = "Year") +
    scale_y_continuous(name = y_title)
  
  return(p1)
  
}


#' Generate condition time series plot
#' 
#' @param x Input data.frame
#' @param region Region. AI, BS, or GOA. Character (1L).
#' @param var_y_name Name of the y variable in the data.frame. Character (1L).
#' @param var_y_se_name Name of the standard error for the y variable. Character (1L).
#' @param var_x_name Name of the x (time variable). Character (1L).
#' @param var_group_name Name of the variable to use for grouping (i.e., stratum). Character (1L).
#' @param y_title Y-axis title. Character (1L).
#' @return A ggplot object of the time series
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
  
  p1 <- ggplot(data = x, 
               aes(x = var_x, 
                   y = var_y, 
                   fill = set_stratum_order(trimws(var_group), 
                                            region = region))) + 
    geom_hline(yintercept = 0) +
    geom_bar(stat = "identity", 
             color = "black",
             position = "stack",
             width = 0.8) +
    facet_wrap(~display_name, ncol = 2, scales = "free_y") +
    scale_x_continuous(name = "Year") +
    scale_y_continuous(name = y_title) +
    scale_fill_brewer(name = fill_title, palette = fill_palette)
  
  return(p1)
  
}