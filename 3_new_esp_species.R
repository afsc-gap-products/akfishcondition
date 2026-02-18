library(akfishcondition)

akfishcondition:::ATF_ESP$FULL_REGION_GOA %>%
  dplyr::mutate(indicator_name = "Summer_Arrowtooth_Flounder_Condition_Adult_GOA_Survey",
                data_value = mean_wt_resid) %>%
  dplyr::select(year, indicator_name, data_value) %>%
  write.csv(file = here::here("output", "Summer_Arrowtooth_Flounder_Condition_Adult_GOA_Survey.csv"),
            row.names = FALSE)

akfishcondition:::GT_ESP$FULL_REGION_EBS %>%
  dplyr::mutate(indicator_name = "Summer_Greenland_Turbot_Condition_Adult_EBS_Survey",
                data_value = mean_wt_resid) %>%
  dplyr::select(year, indicator_name, data_value) %>%
  write.csv(file = here::here("output", "Summer_Greenland_Turbot_Condition_Adult_EBS_Survey.csv"),
            row.names = FALSE)

p_gt_ebs_esp <- 
  plot_anomaly_timeseries(
    x = akfishcondition::GT_ESP$FULL_REGION_EBS,
    region = "BS",
    fill_color = "#0085CA",
    var_y_name = "mean_wt_resid",
    var_y_se_name = "se_wt_resid",
    var_x_name = "year",
    y_title = "Length-weight residual (ln(g))",
    plot_type = "box",
    format_for = "png"
  ) +
  theme_blue_strip()

png(here::here("plots", "BS", "ESP_EBS_GT_condition.png"),width=6,height=3,units="in",res=600)
print(p_gt_ebs_esp)
dev.off()


p_atf_goa_esp <- 
  plot_anomaly_timeseries(
    x = akfishcondition::ATF_ESP$FULL_REGION_GOA,
    region = "GOA",
    fill_color = "#0085CA",
    var_y_name = "mean_wt_resid",
    var_y_se_name = "se_wt_resid",
    var_x_name = "year",
    y_title = "Length-weight residual (ln(g))",
    plot_type = "box",
    format_for = "png"
  ) +
  theme_blue_strip()

png(here::here("plots", "GOA", "ESP_GOA_ATF_condition.png"),width=6,height=3,units="in",res=600)
print(p_atf_goa_esp)
dev.off()



p_atf_goa <- 
  plot_anomaly_timeseries(
    x = akfishcondition::GOA_INDICATOR$FULL_REGION |>
      dplyr::filter(common_name == "arrowtooth flounder"),
    region = "GOA",
    fill_color = "#0085CA",
    var_y_name = "mean_wt_resid",
    var_y_se_name = "se_wt_resid",
    var_x_name = "year",
    y_title = "Length-weight residual (ln(g))",
    plot_type = "box",
    format_for = "png"
  ) +
  theme_blue_strip()

png(here::here("plots", "GOA", "ALL_GOA_ATF_condition.png"),width=6,height=3,units="in",res=600)
print(p_atf_goa)
dev.off()


p_gt_ebs <- 
  plot_anomaly_timeseries(
    x = akfishcondition::EBS_INDICATOR$FULL_REGION |>
      dplyr::filter(common_name == "Greenland turbot"),
    region = "BS",
    fill_color = "#0085CA",
    var_y_name = "mean_wt_resid",
    var_y_se_name = "se_wt_resid",
    var_x_name = "year",
    y_title = "Length-weight residual (ln(g))",
    plot_type = "box",
    format_for = "png"
  ) +
  theme_blue_strip()

png(here::here("plots", "BS", "ALL_EBS_GT_condition.png"),width=6,height=3,units="in",res=600)
print(p_gt_ebs)
dev.off()
