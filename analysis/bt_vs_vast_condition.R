library(coldpool)
library(akfishcondition)
library(ggpubr)
library(janitor)

temp_v_condition_plot <- coldpool::cold_pool_index |>
  janitor::clean_names() |>
  dplyr::inner_join(akfishcondition::EBS_INDICATOR$FULL_REGION) |>
  dplyr::mutate(display_name = akfishcondition::set_plot_order(common_name = common_name,
                                                               region = "BS")) |>
  ggplot(mapping = aes(x = scale(mean_gear_temperature)[,1], 
                       y = scaled_vast_condition)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  stat_cor(label.y.npc = "top") +
  scale_x_continuous(name = "Bottom temperature anomaly") +
  scale_y_continuous(name = "VAST condition anomaly") +
  facet_wrap(~display_name, ncol = 4) +
  theme_blue_strip()

png(file = here::here("plots", "temp_vs_condition.png"), width = 8, height = 4, units = "in", res = 600)
print(temp_v_condition_plot)
dev.off()