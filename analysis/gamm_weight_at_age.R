library(akfishcondition)
library(gamm4)
library(visreg)

channel <- akfishcondition:::get_connected(schema = "AFSC")

akfishcondition::get_condition_data(channel = channel)

region <- "EBS"
spp <- 21740
plus_group <- 15

models_list <- list(
  list(model = "m1",
                  formula = age_scaled_log_weight_g ~
                    t2(longitude, latitude) +
                    s(cohort, bs = 're') +
                    s(fac_haul, bs = 're') +
                    s(sst, by = fac_age_plus, k = 4) +
                    s(doy, k = 4)),
  list(model = "m2",
       formula = age_scaled_log_weight_g ~
         t2(longitude, latitude) + 
         s(year, by = fac_age_plus) +
         s(doy, k = 4)
       ),
  list(model = "m3",
       formula = age_scaled_log_weight_g ~
         t2(longitude, latitude) +
         s(cohort, bs = 're') +
         s(fac_haul, bs = 're') +
         s(year, by = fac_age_plus, k = 4) +
         s(doy, k = 4)),
       list(model = "m4",
            formula = age_scaled_log_weight_g ~
              t2(longitude, latitude) +
              s(cohort, bs = 're') +
              s(fac_haul, bs = 're') +
              s(abundance, by = fac_age_plus, k = 4) +
              s(doy, k = 4))
  )

ebs_pollock_ssb <- read.csv(file = here::here("data", "ebs_pollock_biomass.csv"))
oke_sst_df <- read.csv(file = here::here("data", "oke_ebs_sst.csv"))

lw_dat <- read.csv(file = here::here("data", paste0(region, "_all_species.csv"))) |>
  dplyr::filter(!is.na(age), species_code == spp) |>
  dplyr::mutate(start_time = as.POSIXct(start_time),
                cohort = factor(year-age),
                log_weight_g = log(weight_g),
                log_length_mm = log(length_mm)) |>
  dplyr::mutate(doy = lubridate::yday(start_time),
                fac_year = factor(year),
                fac_haul = factor(paste0(year, "_", haul))) |>
  dplyr::inner_join(oke_sst_df) |>
  dplyr::inner_join(ebs_pollock_ssb) |>
  dplyr::group_by(age) |>
  dplyr::mutate(age_scaled_log_weight_g = scale(log_weight_g)[,1]) |>
  dplyr::ungroup()

# Handle date line
lw_dat$longitude[lw_dat$longitude > 0] <- -180 - (180 - lw_dat$longitude[lw_dat$longitude > 0])
lw_dat <- lw_dat |>
  dplyr::mutate(fac_age = factor(age),
                fac_age_plus = factor(age, labels = c(1:plus_group, rep(plus_group, length(unique(lw_dat$age[lw_dat$age > plus_group]))))))

scaled_log_weight_g <- scale(lw_dat$log_weight_g)
scaled_log_length_mm <- scale(lw_dat$log_length_mm)

lw_dat$scaled_log_weight_g <- scaled_log_weight_g[,1]
lw_dat$scaled_log_length_mm <- scaled_log_length_mm[,1]

lw_dat <- lw_dat |>
  dplyr::inner_join(lw_dat |>
                      dplyr::select(fac_haul) |>
                      dplyr::group_by(fac_haul) |>
                      dplyr::summarise(n = n()))

for(hh in 1:length(models_list)) {
  assign(paste0(models_list[[hh]]$model, "_", region, "_", spp),
         gamm4::gamm4(formula = models_list[[hh]]$formula,
                      data = lw_dat))
}

for(hh in 1:length(models_list)) {
  assign(paste0(models_list[[hh]]$model, "_ML_", region, "_", spp),
         gamm4::gamm4(formula = models_list[[hh]]$formula,
                      data = lw_dat, REML = FALSE))
}


plot(m1_EBS_21740$gam)

plot(m2_EBS_21740$gam)

plot(m3_EBS_21740$gam)

plot(m4_EBS_21740$gam)

test <- gamm4::gamm4(formula = age_scaled_log_weight_g ~
               t2(longitude, latitude) +
               s(abundance, by = fac_age_plus, k = 4) +
               s(doy, k = 4),
             data = lw_dat, 
             random = ~ (1|cohort) + (1|fac_haul))


ggplot(data = lw_dat |>
         dplyr::select(year, abundance, sst) |>
         unique(),
       aes(x = sst, 
           y = abundance)) +
  geom_point() +
  geom_smooth(method = 'lm')
