library(akgfmaps)

akfishcondition::plot_species_stratum_bar(x = EBS_INDICATOR$STRATUM, 
                                          region = "EBS", 
                                          var_x_name = "year", 
                                          var_y_name = "stratum_resid_mean", 
                                          var_y_se_name = "stratum_resid_se",
                                          y_title = "Length-weight residual (ln(g))",
                                          var_group_name = "stratum",
                                          fill_title = "Stratum",
                                          fill_palette = "BrBG",
                                          write_plot = TRUE)

akfishcondition::plot_species_stratum_bar(x = NBS_INDICATOR$STRATUM, 
                                          region = "NBS", 
                                          var_x_name = "year", 
                                          var_y_name = "stratum_resid_mean", 
                                          var_y_se_name = "stratum_resid_se",
                                          y_title = "Length-weight residual (ln(g))",
                                          var_group_name = "stratum",
                                          fill_title = "Stratum",
                                          fill_palette = "BrBG",
                                          write_plot = TRUE)

akfishcondition::plot_species_stratum_bar(x = AI_INDICATOR$STRATUM, 
                                          region = "AI", 
                                          var_x_name = "year", 
                                          var_y_name = "stratum_resid_mean", 
                                          var_y_se_name = "stratum_resid_se",
                                          y_title = "Length-weight residual (ln(g))",
                                          var_group_name = "inpfc_stratum",
                                          fill_title = "INPFC Subarea",
                                          fill_palette = "BrBG",
                                          write_plot = TRUE)

akfishcondition::plot_species_stratum_bar(x = GOA_INDICATOR$STRATUM, 
                                          region = "GOA", 
                                          var_x_name = "year", 
                                          var_y_name = "stratum_resid_mean", 
                                          var_y_se_name = "stratum_resid_se",
                                          y_title = "Length-weight residual (ln(g))",
                                          var_group_name = "inpfc_stratum",
                                          fill_title = "INPFC Subarea",
                                          fill_palette = "BrBG",
                                          write_plot = TRUE)
