library(akfishcondition)
library(nlme)

channel <- akfishcondition:::get_connected(schema = "AFSC")

yfs_specimen <- RODBC::sqlQuery(
  channel = channel,
  query = "select s.*, h.stratum 
  from racebase.specimen s, racebase.haul h where s.cruise in (202501, 202502) 
  and s.species_code in 10210 
  and s.vessel in (162, 134) 
  and s.hauljoin = h.hauljoin"
)


yfs_specimen <- RODBC::sqlQuery(
  channel = channel,
"select s.*, h.stratum, c.year
  from gap_products.akfin_specimen s, 
  gap_products.akfin_haul h,
  gap_products.akfin_cruise c
  where 
  s.species_code = 10210
  and c.survey_definition_id = 98
  and s.hauljoin = h.hauljoin
  and h.cruisejoin = c.cruisejoin"
)


yfs_female <-
  yfs_specimen |>
  dplyr::filter(
    SEX == 2, 
    STRATUM < 70,
    !is.na(MATURITY),
    MATURITY > 0
  ) |>
  dplyr::mutate(
    maturity = factor(MATURITY),
    developing = ifelse(
      YEAR == 2025,
      ifelse(MATURITY %in% c(2:4), 
             "Dev/Spawn",
             "Imm/Spent/Rest/Trans"),
      ifelse(MATURITY %in% c(2, 3),
             "Dev/Spawn", 
             "Imm/Spent/Rest/Trans")),
    loglen = log(LENGTH_MM),
    logwt = log(WEIGHT_G),
    stratum = factor(floor(STRATUM/10))
  )

table(yfs_female$YEAR, yfs_female$developing)/rowSums(table(yfs_female$YEAR, yfs_female$developing))
table(yfs_female$YEAR, yfs_female$developing)
table(yfs_female$MATURITY, yfs_female$YEAR)

table(yfs_female$YEAR, !is.na(yfs_female$WEIGHT_G))

prop_developing <- 
  yfs_female |>
dplyr::group_by(YEAR, developing) |>
  dplyr::summarise(n = n()) |>
  dplyr::inner_join(
    yfs_female |>
      dplyr::group_by(YEAR) |>
      dplyr::summarise(n_year = n())
  ) |>
  dplyr::mutate(prop = n/n_year)

ggplot() +
  geom_histogram(data = dplyr::filter(prop_developing, YEAR != 1999),
           mapping = aes(x = YEAR, y = prop*100, fill = developing),
           position = "stack",
           stat = "identity") +
  scale_fill_viridis_d(name = "Stage") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous("Samples (%)", expand = c(0, 0)) +
  theme_bw()


m0 <- lm(formula = logwt~loglen, data = yfs_female)
m1 <- lm(formula = logwt~loglen, data = yfs_female)
m2 <- lm(formula = logwt~loglen:stratum + stratum + 0, data = yfs_female)
m3 <- lm(formula = logwt~loglen:stratum + stratum + maturity + 0, data = yfs_female)
m4 <- lm(formula = logwt~loglen:stratum + stratum + developing + 0, data = yfs_female)
m5 <- lm(formula = logwt~loglen:stratum:developing + stratum + developing + 0, data = yfs_female)

AIC(m0, m1, m2, m3, m4, m5) |>
  dplyr::arrange(AIC)

m_best <- m4

fit_df <- 
  expand.grid(
    maturity = factor(1:6),
    stratum = factor(1:4),
    length = min(yfs_female$LENGTH):max(yfs_female$LENGTH)
  ) |>
  dplyr::mutate(loglen = log(length),
                developing = ifelse(maturity == 2, "Dev/Spawn", "Imm/Spent/Rest/Trans"))

fit_df$logwt <- predict(m_best, fit_df)
fit_df$logwt_se <- predict(m_best, fit_df, se.fit = TRUE)$se

# Bias correction
syx <- summary(m_best)$sigma
cf <- exp((syx^2)/2) 

# Correction for mean and SE
fit_df$fit <- cf *(exp(fit_df$logwt))
fit_df$lwr <- cf *(exp(fit_df$logwt - 2*fit_df$logwt))
fit_df$upr <- cf *(exp(fit_df$logwt + 2*fit_df$logwt))

ggplot() +
  geom_path(
    data = dplyr::filter(fit_df),
    mapping = aes(x = length, y = fit, color = maturity)
            ) +
  facet_wrap(~stratum) +
  scale_y_log10() +
  scale_x_lo


maturity_weight <- 
  fit_df |>
  dplyr::select(length, maturity, stratum, fit) |>
  tidyr::pivot_wider(
    values_from = "fit",
    names_from = "maturity",
    names_prefix = "mat_"
  ) |>
  dplyr::mutate(dev_v_spent = (mat_2-mat_6)/mat_6)

maturity_weight$dev_v_spent


ggplot() +
  geom_histogram(
    data = dplyr::filter(yfs_female, YEAR == 2025),
                 mapping = aes(x = LENGTH_MM, fill = factor(MATURITY)),
                 position = "stack",
                 color = "grey50"
    ) +
  scale_fill_brewer(name = "Maturity") +
  theme_bw() +
  facet_wrap(~SPECIES_CODE, nrow = 3)

### Compare males and females
lw_dat <- read.csv(file = here::here("data", "ebs_all_species.csv")) |>
  dplyr::filter(species_code == 10210)

biomass_dat <- read.csv(file = here::here("data", "ebs_stratum_biomass_all_species.csv")) |>
  dplyr::filter(species_code == 10210)

lw_bio_male <- dplyr::inner_join(
  lw_dat,
  biomass_dat
) |>
  dplyr::filter(sex == 1)


lw_resids <-  
  calc_lw_residuals_multimodel(
    len = lw_bio_male$length_mm,
    wt = lw_bio_male$weight_g,
    stratum = lw_bio_male$stratum,
    year = lw_bio_male$year,
    make_diagnostics = FALSE,
    species_code = 102101
  ) |>
  dplyr::inner_join(
    lw_bio_male |>
      dplyr::mutate(stratum = factor(stratum)) |>
      dplyr::select(year, stratum, biomass_mt) |>
      unique()
  )

stratum_resids <-  
  lw_resids |>
  dplyr::group_by(year, species_code, stratum, biomass_mt) |>
  dplyr::summarise(stratum_resid_mean = mean(lw.res_mean, na.rm = TRUE),
                   stratum_resid_sd = sd(lw.res_mean, na.rm = TRUE),
                   n = n()) |>
  dplyr::filter(n >= 10) |>
  dplyr::mutate(stratum_resid_se = stratum_resid_sd/sqrt(n))


stratum_resids$weighted_resid_mean <- 
  weight_lw_residuals(
    residuals = stratum_resids$stratum_resid_mean,
    year = stratum_resids$year,
    stratum = stratum_resids$stratum,
    stratum_biomass = stratum_resids$biomass_mt
  )

stratum_resids$weighted_resid_se <- 
  weight_lw_residuals(
    residuals = stratum_resids$stratum_resid_se,
    year = stratum_resids$year,
    stratum = stratum_resids$stratum,
    stratum_biomass = stratum_resids$biomass_mt
  )




yfs_male_condition <-  
  stratum_resids |>
  dplyr::group_by(year, species_code) |>
  dplyr::summarise(mean_wt_resid = mean(weighted_resid_mean),
                   se_wt_resid = mean(weighted_resid_se))


ggplot() +
  geom_point(data = yfs_male_condition,
             mapping = aes(x = year, y = mean_wt_resid)) +
  geom_errorbar(data = yfs_male_condition,
                mapping = aes(x = year,
                              ymin = mean_wt_resid - se_wt_resid,
                              ymax = mean_wt_resid + se_wt_resid),
                width = 0
  ) +
  geom_hline(yintercept = mean(yfs_male_condition$mean_wt_resid), linetype = 2) +
  theme_bw() +
  scale_y_continuous(name = "Wt resid")



