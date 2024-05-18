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
    x_1 <- x_1 |>
      dplyr::group_by(common_name, display_name) |>
      dplyr::mutate(var_y = scale(var_y)[,1])
    x_2 <- x_2 |>
      dplyr::group_by(common_name, display_name) |>
      dplyr::mutate(var_y = scale(var_y)[,1])
  }
  
  
  # Correlation between timeseries
  corr_df <- dplyr::inner_join(
    x_1 |>
      dplyr::ungroup() |>
      dplyr::rename(var_y_1 = var_y) |>
      dplyr::select(display_name, 
                    var_x, 
                    var_y_1),
    x_2 |>
      dplyr::ungroup() |>
      dplyr::rename(var_y_2 = var_y) |>
      dplyr::select(display_name, 
                    var_x, 
                    var_y_2),
    by = c("display_name", "var_x")) |>
    dplyr::group_by(display_name) |>
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