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
    x_1 |>
      dplyr::ungroup() |>
      dplyr::rename(var_y_1 = var_y,
                    var_y_se_1 = var_y_se) |>
      dplyr::select(display_name, 
                    var_x, 
                    var_y_1,
                    var_y_se_1),
    x_2 |>
      dplyr::ungroup() |>
      dplyr::rename(var_y_2 = var_y,
                    var_y_se_2 = var_y_se) |>
      dplyr::select(display_name, 
                    var_x, 
                    var_y_2,
                    var_y_se_2),
    by = c("display_name", "var_x")) |>
    dplyr::ungroup()
  
  
  corr_df <- x_combined |>
    dplyr::group_by(display_name) |>
    dplyr::summarise(
      r = round(cor(var_y_1, 
                    var_y_2, 
                    use = "complete.obs",
                    method = "pearson"), 2))
  
  corr_df <- corr_df |>
    dplyr::inner_join(
      x_combined |>
        dplyr::group_by(display_name) |>
        dplyr::summarise(min_x = min(var_y_1-2*var_y_se_1),
                         max_x = max(var_y_1+2*var_y_se_1),
                         min_y = min(var_y_2-2*var_y_se_2),
                         max_y = max(var_y_2+2*var_y_se_2)) |>
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