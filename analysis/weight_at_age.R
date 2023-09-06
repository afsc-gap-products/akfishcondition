library(akfishcondition)
library(gamm4)

channel <- akfishcondition:::get_connected(schema = "AFSC")

akfishcondition::get_condition_data(channel = channel)

region <- "EBS"

oke_sst_df <- read.csv(file = here::here("data", "oke_ebs_sst.csv"))

lw_dat <- read.csv(file = here::here("data", paste0(region, "_all_species.csv"))) |>
  dplyr::filter(!is.na(age), species_code == 21740) |>
  dplyr::filter(age < 16) |>
  dplyr::mutate(start_time = as.POSIXct(start_time),
                cohort = factor(year-age),
                log_weight_g = log(weight_g),
                log_length_mm = log(length_mm)) |>
  dplyr::mutate(doy = lubridate::yday(start_time),
                fac_year = factor(year),
                fac_haul = factor(paste0(year, "_", haul))) |>
  dplyr::inner_join(oke_sst_df) |>
  dplyr::group_by(age) |>
  dplyr::mutate(age_scaled_log_weight_g = scale(log_weight_g)[,1]) |>
  dplyr::ungroup() |>
  dplyr::mutate(fac_age = factor(age))

scaled_log_weight_g <- scale(lw_dat$log_weight_g)
scaled_log_length_mm <- scale(lw_dat$log_length_mm)

lw_dat$scaled_log_weight_g <- scaled_log_weight_g[,1]
lw_dat$scaled_log_length_mm <- scaled_log_length_mm[,1]

lw_dat <- lw_dat |>
  dplyr::inner_join(lw_dat |>
                      dplyr::select(fac_haul) |>
                      dplyr::group_by(fac_haul) |>
                      dplyr::summarise(n = n()))

age_scaled_gamm <- gamm4::gamm4(formula = age_scaled_log_weight_g ~ 
                           t2(longitude, latitude) + 
                           s(cohort, bs = 're') + 
                           s(fac_haul, bs = 're') +
                           s(sst, by = factor(age)) +
                           s(doy, k = 4),
                         data = lw_dat)

age_scaled_gamm_oke <- gamm4::gamm4(formula = age_scaled_log_weight_g ~ 
                                  t2(longitude, latitude) + 
                                  s(cohort, bs = 're') + 
                                  s(fac_haul, bs = 're') +
                                  s(sst, by = factor(age), k = 4) +
                                  s(doy, k = 4),
                                data = lw_dat)

age_scaled_oke_gamm <- gamm4::gamm4(formula = age_scaled_log_weight_g ~ 
                            t2(longitude, latitude) + 
                            s(cohort, bs = 're') + 
                            s(fac_haul, bs = 're') +
                            s(fac_age, bs = 're') +
                            fac_year +
                            s(doy, k = 4),
                          data = lw_dat)

age_scaled_year_gamm_no_cohort <- gamm4::gamm4(formula = age_scaled_log_weight_g ~ 
                                                 t2(longitude, latitude) + 
                                                 s(fac_haul, bs = "re") +
                                                 s(fac_age, bs = "re") +
                                                 fac_year +
                                                 s(doy, k = 4),
                                               data = lw_dat)

age_scaled_year_effect <- gamm4::gamm4(formula = age_scaled_log_weight_g ~ 
                                      t2(longitude, latitude) + 
                                      s(fac_haul, bs = "re") +
                                      s(year, by = factor(age)) +
                                      s(doy, k = 4),
                                    data = lw_dat)


age_scaled_gamm_oke_no_re_haul <- gamm4::gamm4(formula = age_scaled_log_weight_g ~ 
                                      t2(longitude, latitude) + 
                                      s(cohort, bs = 're') + 
                                      s(sst, by = factor(age), k = 4) +
                                      s(doy, k = 4),
                                    data = lw_dat)

age_scaled_yearfac_effect <- gamm4::gamm4(formula = age_scaled_log_weight_g ~ 
                                         t2(longitude, latitude) + 
                                         # s(fac_haul, bs = "re") +
                                         fac_year:fac_age +
                                         s(doy, k = 4),
                                       data = lw_dat)


plot(age_scaled_year_gamm_no_cohort$gam)

plot(age_scaled_year_effect$gam)

plot(age_scaled_gamm_oke_no_re_haul$gam)


age_scaled_year_gamm_no_cohort$gam$coefficients

# oke_gamm <- gamm4::gamm4(formula = scaled_log_weight_g ~ 
#                            t2(longitude, latitude) + 
#                            s(cohort, bs = "re") + 
#                            s(fac_haul, bs = "re") +
#                            s(sst, by = factor(age)) +
#                            s(doy, k = 4),
#                          data = lw_dat)
# 
# year_gamm <- gamm4::gamm4(formula = scaled_log_weight_g ~ 
#                            t2(longitude, latitude) + 
#                            s(cohort, bs = "re") + 
#                            s(fac_haul, bs = "re") +
#                            s(factor(age), bs = "re") +
#                            fac_year +
#                            s(doy, k = 4),
#                          data = lw_dat)
# 
# year_gamm_no_cohort <- gamm4::gamm4(formula = scaled_log_weight_g ~ 
#                             t2(longitude, latitude) + 
#                             s(fac_haul, bs = "re") +
#                             s(factor(age), = "re") +
#                             fac_year +
#                             s(doy, k = 4),
#                           data = lw_dat)
# 
# plot(age_scaled_gamm_oke$gam)
