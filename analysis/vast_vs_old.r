library(akfishcondition)
library(ggthemes)
library(coldpool)

spp_folders <- list.files(here::here("results", "goa"))
spp_paths <- list.files(here::here("results", "goa"), full.names = TRUE)

old_condition_df <- data.frame()
unique_species <- unique(akfishcondition::GOA_INDICATOR$FULL_REGION$common_name)

for(kk in 1:length(unique_species)) {
  old_condition_df <- old_condition_df %>%
    dplyr::bind_rows(akfishcondition::GOA_INDICATOR$FULL_REGION %>%
                       dplyr::filter(common_name == unique_species[kk]) |>
                       dplyr::mutate(scaled_mean_wt_resid = scale(mean_wt_resid)[,1]))
}

vast_condition_df <- data.frame()

for(jj in 1:length(spp_paths)) {
  if(file.exists(here::here("results", "goa", spp_folders[jj], "index.csv"))) {
  vast_condition_df <- vast_condition_df %>% 
    dplyr::bind_rows(
      read.csv(file = here::here("results", "goa", spp_folders[jj], "index.csv")) |>
        dplyr::filter(Category == "Condition (grams per cm^power)", Time %in% unique(old_condition_df$year)) |>
        dplyr::mutate(species_code = as.numeric(spp_folders[jj])) %>%  
        dplyr::rename(year = Time) %>%
        dplyr::mutate(scaled_condition = scale(Estimate)[,1])
    )
  }
}

combined_condition_df <- vast_condition_df %>%
  dplyr::inner_join(read.csv(file = system.file("/extdata/species_by_region.csv", package = "akfishcondition")) %>%
                      dplyr::filter(region == "GOA")) %>%
  dplyr::inner_join(old_condition_df )

ggplot(data = combined_condition_df,
       aes(x = scaled_mean_wt_resid,
           y = scaled_condition,
           color = common_name)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  scale_x_continuous(name = "Stratum-biomass-weighted indicator (Z-score)") +
  scale_y_continuous(name = "VAST indicator (Z-score)") +
  scale_color_colorblind() +
  facet_wrap(~common_name, scales = "free") +
  coldpool::theme_multi_map_blue_strip()

png(file = here::here("plots", "goa_vast_vs_saw.png"), width = 7, height = 6, units = "in", res = 300)
print(
ggplot(data = combined_condition_df,
       aes(x = mean_wt_resid,
           y = Estimate,
           ymin = Estimate - Std..Error.for.Estimate*2,
           ymax = Estimate + Std..Error.for.Estimate*2,
           xmin = mean_wt_resid - se_wt_resid*2,
           xmax = mean_wt_resid + se_wt_resid*2)) +
  geom_smooth(method = 'lm') +
  geom_point() +
  geom_errorbar() +
  geom_errorbarh() +
  scale_x_continuous(name = "Stratum-biomass-weighted indicator") +
  scale_y_continuous(name = "VAST indicator") +
  facet_wrap(~akfishcondition::set_plot_order(common_name = common_name,
                                              region = "GOA"), 
             scales = "free") +
  coldpool::theme_multi_map_blue_strip() +
  theme(axis.text = element_text(size = 8),
        legend.position = "none")
)
dev.off()


png(file = here::here("plots", "goa_vast_vs_saw_timeseries.png"), width = 7, height = 6, units = "in", res = 300)
print(
ggplot(data = combined_condition_df |>
         tidyr::pivot_longer(cols = c("scaled_condition", "scaled_mean_wt_resid")),
       aes(x = year,
           y = value,
           fill = factor(name, labels = c("Scaled VAST", "Scaled stratum-area-weighted")),
           color = factor(name, labels = c("Scaled VAST", "Scaled stratum-area-weighted")))) +
  geom_path() +
  geom_point(shape = 21) +
  scale_x_continuous(name = "Stratum-biomass-weighted indicator (Z-score)") +
  scale_y_continuous(name = "VAST indicator (Z-score)") +
  scale_fill_manual(values = c("black", "plum")) +
  scale_color_manual(values = c("black", "plum")) +
  facet_wrap(~common_name, scales = "free") +
  coldpool::theme_multi_map_blue_strip() +
  theme(axis.text = element_text(size = 8))
)
dev.off()

  
