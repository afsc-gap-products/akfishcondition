#' Condition indicator calculated based on day of year
#' 
#' @param species_code Species code as a 1L numeric vector
#' @param region Region as a 1L character vector ("EBS", "NBS", "AI", "GOA")
#' @param method Regression function method, either lm or stan_lm
#' @param form Formula for the regression.
#' @export

run_condition_doy <- function(species_code, 
                              region = "EBS", 
                              method = "lm", 
                              form = log(weight_g)~log(length_cm):factor(sex)+yday:factor(year)) {
  
  print(paste0(species_code, "-", region))
  
  spp_code <- species_code
  
  lw_dat.sub <- read.csv(file = here::here("data", paste0(region, "_all_species.csv"))) |>
    dplyr::filter(species_code == spp_code ) |>
    dplyr::filter(!is.na(length_mm)) |>
    dplyr::select(year, species_code, start_time, specimenid, length_mm, weight_g, sex, latitude, longitude, common_name) |>
    dplyr::mutate(length_cm = length_mm/10,
                  start_time = as.POSIXct(start_time, tz = "America/Anchorage")) |>
    dplyr::mutate(yday = lubridate::yday(start_time),
                  loglendoy = log(length_cm)*yday)
  
  # Linear regression-------------------------------------------------------------------------------
  if(method == "lm") {
    m1 <- lm(formula = form, data = lw_dat.sub)
    se_m1<- coef(summary(m1))[, "Std. Error"][grepl("yday", x = names(coef(summary(m1))[, "Std. Error"]))]
    
  } else if(method == "stan_lm") {
    m1 <- rstanarm::stan_lm(formula = form, prior = NULL, data = lw_dat.sub)
    se_m1 <- m1$ses[grepl("yday", x = names(m1$ses))]
  }

  # Predict-----------------------------------------------------------------------------------------
  # lw_predict <- expand.grid(yday = c(180,181), 
  #                           length_cm = c(25),
  #                           year = unique(lw_dat.sub$year))
  # 
  # lw_predict$loglendoy <- log(lw_predict$length_cm)*lw_predict$yday
  # 
  # lw_predict$fit <- exp(predict(m1, newdata = lw_predict, type = "response"))
  # lw_predict$se.fit <- predict(m1, newdata = lw_predict, type = "response", se.fit = TRUE)$se.fit
  # 
  # lw_predict <- lw_predict |>
  #   dplyr::select(-loglendoy) |>
  #   dplyr::mutate(upr = fit + se.fit*2,
  #                 lwr = fit - se.fit*2)
  # 
  # gg_per_day <- dplyr::inner_join(lw_predict |>
  #                                       tidyr::pivot_wider(id_cols = c(year, length_cm),
  #                                                          values_from = c(fit),
  #                                                          names_from = c(yday)) |>
  #                                       dplyr::mutate(gg_per_day_mean = (`181`-`180`)/`180`) |>
  #                                       dplyr::select(-`180`, -`181`),
  #                                     lw_predict |>
  #                                       tidyr::pivot_wider(id_cols = c(year, length_cm),
  #                                                          values_from = c(upr),
  #                                                          names_from = c(yday)) |>
  #                                       dplyr::mutate(gg_per_day_upr = (`181`-`180`)/`180`) |>
  #                                       dplyr::select(-`180`, -`181`), 
  #                                     by = "year") |>
  #   dplyr::inner_join(
  #     lw_predict |>
  #       tidyr::pivot_wider(id_cols = c(year, length_cm),
  #                          values_from = c(lwr),
  #                          names_from = c(yday)) |>
  #       dplyr::mutate(gg_per_day_lwr = (`181`-`180`)/`180`) |>
  #       dplyr::select(-`180`, -`181`), 
  #     by = "year") |>
  #   dplyr::arrange(year)
  
  
  return(list(coef_summary = data.frame(species_code = spp_code,
                                        region = region,
                                        year = sort(unique(lw_dat.sub$year)),
                                        coef = m1$coefficients[grepl("yday", x = names(m1$coefficients))],
                                        # gg_per_day_mean = gg_per_day$gg_per_day_mean,
                                        # gg_per_day_lwr = gg_per_day$gg_per_day_lwr,
                                        # gg_per_day_upr = gg_per_day$gg_per_day_upr,
                                        se_coef = se_m1),
              # fit = lw_predict,
              dat = lw_dat.sub))
}
