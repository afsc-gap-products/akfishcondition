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
#' \dontrun{
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
#' }
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