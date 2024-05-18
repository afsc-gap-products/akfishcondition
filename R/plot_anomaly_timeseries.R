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
#' @param set_intercept Intercept to use for plots. Numeric (1L). 0 for residual, 1 for VAST relative condition, NULL for VAST a
#' @return A ggplot object of the time series
#' @examples 
#' \dontrun{
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
#' }
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
  x_anomaly <- x |>
    dplyr::group_by(common_name,
                    display_name) |>
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