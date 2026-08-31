library(akfishcondition)

akfishcondition:::ATF_ESP$FULL_REGION_GOA |>
  dplyr::filter(common_name == "arrowtooth flounder (adult)") |>
  dplyr::mutate(indicator_name = "Summer_Arrowtooth_Flounder_Condition_Adult_GOA_Survey",
                data_value = mean_wt_resid) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Arrowtooth_Flounder_Condition_Adult_GOA_Survey.csv"),
            row.names = FALSE)

akfishcondition:::ATF_ESP$FULL_REGION_GOA |>
  dplyr::filter(common_name == "arrowtooth flounder (juvenile)") |>
  dplyr::mutate(indicator_name = "Summer_Arrowtooth_Flounder_Condition_Juvenile_GOA_Survey",
                data_value = mean_wt_resid) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Arrowtooth_Flounder_Condition_Juvenile_GOA_Survey.csv"),
            row.names = FALSE)

akfishcondition:::GT_ESP$FULL_REGION_EBS |>
  dplyr::filter(common_name == "Greenland turbot (adult)") |>
  dplyr::mutate(indicator_name = "Summer_Greenland_Turbot_Condition_Adult_EBS_Survey",
                data_value = mean_wt_resid) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Greenland_Turbot_Condition_Adult_EBS_Survey.csv"),
            row.names = FALSE)

akfishcondition:::GT_ESP$FULL_REGION_EBS |>
  dplyr::filter(common_name == "Greenland turbot (juvenile)") |>
  dplyr::mutate(indicator_name = "Summer_Greenland_Turbot_Condition_Juvenile_EBS_Survey",
                data_value = mean_wt_resid) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Greenland_Turbot_Condition_Juvenile_EBS_Survey.csv"),
            row.names = FALSE)


# Arrowtooth flounder (GOA) ----

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

# Greenland turbot (EBS) ----

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


#### Atka mackerel (WAI) ----

p_atka_wai_esp <- 
  plot_anomaly_timeseries(
    x = akfishcondition::ATKA_ESP$STRATUM_AI |> dplyr::filter(area_id == 299),
    region = "AI",
    fill_color = "#0085CA",
    var_y_name = "stratum_resid_mean",
    var_y_se_name = "stratum_resid_se",
    var_x_name = "year",
    y_title = "Length-weight residual (ln(g))",
    plot_type = "box",
    format_for = "png"
  ) +
  theme_blue_strip()

png(here::here("plots", "AI", "ESP_WAI_ATKA_condition.png"),width=6,height=3,units="in",res=600)
print(p_atka_wai_esp)
dev.off()

akfishcondition::ATKA_ESP$STRATUM_AI |> 
  dplyr::filter(area_id == 299) |>
  dplyr::filter(common_name == "Atka mackerel (adult)") |>
  dplyr::mutate(indicator_name = "Summer_Atka_Mackerel_Condition_Adult_WAI_Survey",
                data_value = stratum_resid_mean) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Atka_Mackerel_Condition_Adult_WAI_Survey.csv"),
            row.names = FALSE)

akfishcondition::ATKA_ESP$STRATUM_AI |> 
  dplyr::filter(area_id == 299) |>
  dplyr::filter(common_name == "Atka mackerel (juvenile)") |>
  dplyr::mutate(indicator_name = "Summer_Atka_Mackerel_Condition_Juvenile_WAI_Survey",
                data_value = stratum_resid_mean) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Atka_Mackerel_Condition_Juvenile_WAI_Survey.csv"),
            row.names = FALSE)


#### Atka mackerel (CAI) ----

p_atka_cai_esp <- 
  plot_anomaly_timeseries(
    x = akfishcondition::ATKA_ESP$STRATUM_AI |> dplyr::filter(area_id == 3499),
    region = "AI",
    fill_color = "#0085CA",
    var_y_name = "stratum_resid_mean",
    var_y_se_name = "stratum_resid_se",
    var_x_name = "year",
    y_title = "Length-weight residual (ln(g))",
    plot_type = "box",
    format_for = "png"
  ) +
  theme_blue_strip()

png(here::here("plots", "AI", "ESP_CAI_ATKA_condition.png"),width=6,height=3,units="in",res=600)
print(p_atka_cai_esp)
dev.off()

akfishcondition::ATKA_ESP$STRATUM_AI |> 
  dplyr::filter(area_id == 3499) |>
  dplyr::filter(common_name == "Atka mackerel (adult)") |>
  dplyr::mutate(indicator_name = "Summer_Atka_Mackerel_Condition_Adult_CAI_Survey",
                data_value = stratum_resid_mean) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Atka_Mackerel_Condition_Adult_CAI_Survey.csv"),
            row.names = FALSE)

akfishcondition::ATKA_ESP$STRATUM_AI |> 
  dplyr::filter(area_id == 3499) |>
  dplyr::filter(common_name == "Atka mackerel (juvenile)") |>
  dplyr::mutate(indicator_name = "Summer_Atka_Mackerel_Condition_Juvenile_CAI_Survey",
                data_value = stratum_resid_mean) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Atka_Mackerel_Condition_Juvenile_CAI_Survey.csv"),
            row.names = FALSE)


#### Atka mackerel (EAI) ----

p_atka_eai_esp <- 
  plot_anomaly_timeseries(
    x = akfishcondition::ATKA_ESP$STRATUM_AI |> dplyr::filter(area_id == 5699),
    region = "AI",
    fill_color = "#0085CA",
    var_y_name = "stratum_resid_mean",
    var_y_se_name = "stratum_resid_se",
    var_x_name = "year",
    y_title = "Length-weight residual (ln(g))",
    plot_type = "box",
    format_for = "png"
  ) +
  theme_blue_strip()

png(here::here("plots", "AI", "ESP_EAI_ATKA_condition.png"),width=6,height=3,units="in",res=600)
print(p_atka_eai_esp)
dev.off()

akfishcondition::ATKA_ESP$STRATUM_AI |> 
  dplyr::filter(area_id == 5699) |>
  dplyr::filter(common_name == "Atka mackerel (adult)") |>
  dplyr::mutate(indicator_name = "Summer_Atka_Mackerel_Condition_Adult_EAI_Survey",
                data_value = stratum_resid_mean) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Atka_Mackerel_Condition_Adult_EAI_Survey.csv"),
            row.names = FALSE)

akfishcondition::ATKA_ESP$STRATUM_AI |> 
  dplyr::filter(area_id == 5699) |>
  dplyr::filter(common_name == "Atka mackerel (juvenile)") |>
  dplyr::mutate(indicator_name = "Summer_Atka_Mackerel_Condition_Juvenile_EAI_Survey",
                data_value = stratum_resid_mean) |>
  dplyr::select(year, indicator_name, data_value) |>
  write.csv(file = here::here("output", "Summer_Atka_Mackerel_Condition_Juvenile_EAI_Survey.csv"),
            row.names = FALSE)

