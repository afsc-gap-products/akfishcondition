library(akfishcondition)
library(tidyverse)
library(ggpubr)

dat <- akfishcondition:::AI_INDICATOR$STRATUM |>
  dplyr::select(year, common_name, inpfc_stratum, stratum_resid_mean, stratum_resid_se) |>
  dplyr::inner_join(akfishcondition:::AI_INDICATOR$FULL_REGION |>
                      dplyr::select(year, common_name, mean_wt_resid, se_wt_resid, vast_relative_condition, vast_relative_condition_se)) |>
  dplyr::filter(common_name %in% akfishcondition::ESR_SETTINGS$ESR_SPECIES$common_name[akfishcondition::ESR_SETTINGS$ESR_SPECIES$AI])

unique_spp <- unique(dat$common_name)

pdf(here::here("output", "AI", "AI_SBW_STRATUM_vs_VAST_scatterplot.pdf"), onefile = TRUE)

for(ii in 1:length(unique_spp)) {
  
  if(unique_spp[ii] != "walleye pollock (100–250 mm)") {
    
    print(
      ggplot(data = dat |>
               dplyr::filter(common_name == unique_spp[ii]),
             aes(x = vast_relative_condition,
                 y = stratum_resid_mean,
                 xmin = vast_relative_condition - 2*vast_relative_condition_se,
                 xmax = vast_relative_condition + 2*vast_relative_condition_se,
                 ymin = stratum_resid_mean - 2*stratum_resid_se,
                 ymax = stratum_resid_mean + 2*stratum_resid_se)) +
        geom_point() +
        geom_errorbar() +
        geom_errorbarh() +
        ggpubr::stat_cor(na.rm = TRUE) +
        ggtitle(label = unique_spp[ii]) +
        facet_wrap(~akfishcondition::set_stratum_order(inpfc_stratum, region= "AI"),
                   ncol = 2) +
        scale_x_continuous(name = "VAST relative condition (all regions)") +
        scale_y_continuous(name = "Mean stratum residual (region-specific)") +
        theme_blue_strip() +
        theme(plot.title = element_text(hjust = 0.5))
    )
  }
  
}

dev.off()



pdf(here::here("output", "AI", "AI_SBW_STRATUM_vs_VAST_timeseries.pdf"), onefile = TRUE)

for(ii in 1:length(unique_spp)) {
  
  if(unique_spp[ii] != "walleye pollock (100–250 mm)") {
    
    print(
      akfishcondition::plot_two_timeseries(x_1 = dat |> dplyr::filter(common_name == unique_spp[ii]),
                                           x_2 = dat |> dplyr::filter(common_name == unique_spp[ii]),
                                           region = "AI",
                                           series_name_1 = "VAST relative condition (all strata)",
                                           series_name_2 = "Mean stratum residual (stratum-specific)",
                                           var_y_name_1 = "vast_relative_condition",
                                           var_y_name_2 = "stratum_resid_mean",
                                           var_group_name = "inpfc_stratum",
                                           y_title = "Condition (Z-score)",
                                           fill_title = "Method",
                                           scale_y = TRUE,
                                           year_break = NULL,
                                           x_offset = 0.25,
                                           fill_colors = c("red", "black"),
                                           shapes = c(24, 21),
                                           format_for = "png"
      ) +
        ggtitle(unique_spp[ii]) +
        theme_blue_strip() +
        theme(plot.title = element_text(hjust = 0.5),
              legend.position = "bottom")
    )
  }
}

dev.off()

### Stratum trends

pdf(here::here("output", "AI", "AI_SBW_STRATUM_vs_REGION_scatterplot.pdf"), onefile = TRUE)

for(ii in 1:length(unique_spp)) {
  
  if(unique_spp[ii] != "walleye pollock (100–250 mm)") {
    
    print(
      ggplot(data = dat |>
               dplyr::filter(common_name == unique_spp[ii]),
             aes(x = mean_wt_resid,
                 y = stratum_resid_mean,
                 xmin = mean_wt_resid - 2*se_wt_resid,
                 xmax = mean_wt_resid + 2*se_wt_resid,
                 ymin = stratum_resid_mean - 2*stratum_resid_se,
                 ymax = stratum_resid_mean + 2*stratum_resid_se)) +
        geom_point() +
        geom_errorbar() +
        geom_errorbarh() +
        ggpubr::stat_cor(na.rm = TRUE) +
        ggtitle(label = unique_spp[ii]) +
        facet_wrap(~akfishcondition::set_stratum_order(inpfc_stratum, region= "AI"),
                   ncol = 2) +
        scale_x_continuous(name = "VAST relative condition (all regions)") +
        scale_y_continuous(name = "Mean stratum residual (region-specific)") +
        theme_blue_strip() +
        theme(plot.title = element_text(hjust = 0.5))
    )
  }
  
}

dev.off()

pdf(here::here("output", "AI", "AI_SBW_STRATUM_vs_REGION_timeseries.pdf"), onefile = TRUE)

for(ii in 1:length(unique_spp)) {
  
  if(unique_spp[ii] != "walleye pollock (100–250 mm)") {
    
    print(
      akfishcondition::plot_two_timeseries(x_1 = dat |> dplyr::filter(common_name == unique_spp[ii]),
                                           x_2 = dat |> dplyr::filter(common_name == unique_spp[ii]),
                                           region = "AI",
                                           series_name_1 = "VAST relative condition (all strata)",
                                           series_name_2 = "Mean stratum residual (stratum-specific)",
                                           var_y_name_1 = "mean_wt_resid",
                                           var_y_name_2 = "stratum_resid_mean",
                                           var_group_name = "inpfc_stratum",
                                           y_title = "Condition (Z-score)",
                                           fill_title = "Method",
                                           scale_y = TRUE,
                                           year_break = NULL,
                                           x_offset = 0.25,
                                           fill_colors = c("red", "black"),
                                           shapes = c(24, 21),
                                           format_for = "png"
      ) +
        ggtitle(unique_spp[ii]) +
        theme_blue_strip() +
        theme(plot.title = element_text(hjust = 0.5),
              legend.position = "bottom")
    )
  }
}

dev.off()



# EBS ----


dat <- akfishcondition::EBS_INDICATOR$STRATUM |>
  dplyr::select(year, common_name,stratum, stratum_resid_mean, stratum_resid_se) |>
  dplyr::inner_join(akfishcondition:::EBS_INDICATOR$FULL_REGION |>
                      dplyr::select(year, common_name, mean_wt_resid, se_wt_resid, vast_relative_condition, vast_relative_condition_se)) |>
  dplyr::filter(common_name %in% akfishcondition::ESR_SETTINGS$ESR_SPECIES$common_name[akfishcondition::ESR_SETTINGS$ESR_SPECIES$EBS])

unique_spp <- unique(dat$common_name)

pdf(here::here("output", "EBS", "EBS_SBW_STRATUM_vs_VAST_scatterplot.pdf"), onefile = TRUE)

for(ii in 1:length(unique_spp)) {
    
    print(
      ggplot(data = dat |>
               dplyr::filter(common_name == unique_spp[ii]),
             aes(x = vast_relative_condition,
                 y = stratum_resid_mean,
                 xmin = vast_relative_condition - 2*vast_relative_condition_se,
                 xmax = vast_relative_condition + 2*vast_relative_condition_se,
                 ymin = stratum_resid_mean - 2*stratum_resid_se,
                 ymax = stratum_resid_mean + 2*stratum_resid_se)) +
        geom_point() +
        geom_errorbar() +
        geom_errorbarh() +
        ggpubr::stat_cor(na.rm = TRUE) +
        ggtitle(label = unique_spp[ii]) +
        facet_wrap(~akfishcondition::set_stratum_order(stratum, region= "BS"),
                   ncol = 2) +
        scale_x_continuous(name = "VAST relative condition (all regions)") +
        scale_y_continuous(name = "Mean stratum residual (region-specific)") +
        theme_blue_strip() +
        theme(plot.title = element_text(hjust = 0.5))
    )
  
}

dev.off()



pdf(here::here("output", "EBS", "EBS_SBW_STRATUM_vs_VAST_timeseries.pdf"), onefile = TRUE)

for(ii in 1:length(unique_spp)) {
 
    print(
      akfishcondition::plot_two_timeseries(x_1 = dat |> dplyr::filter(common_name == unique_spp[ii]),
                                           x_2 = dat |> dplyr::filter(common_name == unique_spp[ii]),
                                           region = "BS",
                                           series_name_1 = "VAST relative condition (all strata)",
                                           series_name_2 = "Mean stratum residual (stratum-specific)",
                                           var_y_name_1 = "vast_relative_condition",
                                           var_y_name_2 = "stratum_resid_mean",
                                           var_group_name = "stratum",
                                           y_title = "Condition (Z-score)",
                                           fill_title = "Method",
                                           scale_y = TRUE,
                                           year_break = NULL,
                                           x_offset = 0.25,
                                           fill_colors = c("red", "black"),
                                           shapes = c(24, 21),
                                           format_for = "png"
      ) +
        ggtitle(unique_spp[ii]) +
        theme_blue_strip() +
        theme(plot.title = element_text(hjust = 0.5),
              legend.position = "bottom")
    )
}

dev.off()


### Stratum trends

pdf(here::here("output", "EBS", "EBS_SBW_STRATUM_vs_REGION_scatterplot.pdf"), onefile = TRUE)

for(ii in 1:length(unique_spp)) {
    
    print(
      ggplot(data = dat |>
               dplyr::filter(common_name == unique_spp[ii]),
             aes(x = mean_wt_resid,
                 y = stratum_resid_mean,
                 xmin = mean_wt_resid - 2*se_wt_resid,
                 xmax = mean_wt_resid + 2*se_wt_resid,
                 ymin = stratum_resid_mean - 2*stratum_resid_se,
                 ymax = stratum_resid_mean + 2*stratum_resid_se)) +
        geom_point() +
        geom_errorbar() +
        geom_errorbarh() +
        ggpubr::stat_cor(na.rm = TRUE) +
        ggtitle(label = unique_spp[ii]) +
        facet_wrap(~akfishcondition::set_stratum_order(stratum, region= "BS"),
                   ncol = 2) +
        scale_x_continuous(name = "VAST relative condition (all regions)") +
        scale_y_continuous(name = "Mean stratum residual (region-specific)") +
        theme_blue_strip() +
        theme(plot.title = element_text(hjust = 0.5))
    )
  
}

dev.off()

pdf(here::here("output", "EBS", "EBS_SBW_STRATUM_vs_REGION_timeseries.pdf"), onefile = TRUE)

for(ii in 1:length(unique_spp)) {
    
    print(
      akfishcondition::plot_two_timeseries(x_1 = dat |> dplyr::filter(common_name == unique_spp[ii]),
                                           x_2 = dat |> dplyr::filter(common_name == unique_spp[ii]),
                                           region = "BS",
                                           series_name_1 = "VAST relative condition (all strata)",
                                           series_name_2 = "Mean stratum residual (stratum-specific)",
                                           var_y_name_1 = "mean_wt_resid",
                                           var_y_name_2 = "stratum_resid_mean",
                                           var_group_name = "stratum",
                                           y_title = "Condition (Z-score)",
                                           fill_title = "Method",
                                           scale_y = TRUE,
                                           year_break = NULL,
                                           x_offset = 0.25,
                                           fill_colors = c("red", "black"),
                                           shapes = c(24, 21),
                                           format_for = "png"
      ) +
        ggtitle(unique_spp[ii]) +
        theme_blue_strip() +
        theme(plot.title = element_text(hjust = 0.5),
              legend.position = "bottom")
    )
}

dev.off()