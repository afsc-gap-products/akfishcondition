# Species/life history correlation between regions

library(akfishcondition)

all_regions_df <- dplyr::bind_rows(
  dplyr::filter(EBS_INDICATOR$FULL_REGION) |>
    dplyr::mutate(region = "EBS"),
  dplyr::filter(GOA_INDICATOR$FULL_REGION) |>
    dplyr::mutate(region = "GOA"),
  dplyr::filter(AI_INDICATOR$FULL_REGION) |>
    dplyr::mutate(region = "AI")
) |>
  dplyr::select(year, common_name, mean_wt_resid, region)

by_region_df <- all_regions_df |>
  tidyr::pivot_wider(id_cols = c("common_name", "year"), 
                     values_from = "mean_wt_resid", 
                     names_from = "region")

by_region_df |>
  dplyr::filter(!is.na(GOA) & !is.na(EBS)) |>
  dplyr::group_by(common_name) |>
  dplyr::summarise(EBS_vs_GOA = cor(EBS, GOA, use = "complete.obs"))

by_region_df |>
  dplyr::filter(!is.na(AI) & !is.na(EBS)) |>
  dplyr::group_by(common_name) |>
  dplyr::summarise(EBS_vs_AI = cor(EBS, AI, use = "complete.obs"))
