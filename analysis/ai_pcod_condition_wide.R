library(akfishcondition)

pcod_condition <- akfishcondition::AI_INDICATOR$STRATUM |>
  dplyr::filter(common_name == "Pacific cod") |>
  dplyr::inner_join(data.frame(inpfc_stratum = c("Western Aleutians", "Central Aleutians", "Eastern Aleutians", "Southern Bering Sea"),
                               nmfs_area = c("543", "542", "541", "518 + 519")))

pcod_condition$inpfc_stratum <- factor(pcod_condition$inpfc_stratum,
                                       levels = c("Western Aleutians", "Central Aleutians", "Eastern Aleutians", "Southern Bering Sea"))

pcod_condition$nmfs_area <- factor(pcod_condition$nmfs_area,
                                       levels = c("543", "542", "541", "518 + 519"))

p1 <- 
  ggplot(data = pcod_condition,
         aes(x = year, 
             y = stratum_resid_mean, 
             fill = inpfc_stratum,
             ymin = stratum_resid_mean - 2*stratum_resid_se,
             ymax = stratum_resid_mean + 2*stratum_resid_se)) +
  geom_hline(yintercept = 0) +
  geom_linerange() +
  geom_bar(stat = "identity", 
           color = "black", 
           position = "stack", 
           width = 1) +
  facet_wrap(~inpfc_stratum, 
             ncol = 4, 
             scales = "free_y") +
  scale_x_continuous(name = "Year", breaks = scales::pretty_breaks()) +
  scale_y_continuous(name = "Length-weight residual (ln(g))") +
  scale_fill_brewer(name = "Stratum", 
                    palette = "BrBG", 
                    drop = FALSE) + 
  theme_blue_strip() + 
  theme(legend.position = "none",
        title = element_text(hjust = 0.5),
        axis.text.y = element_text(size = 7), 
        axis.text.x = element_text(size = 7), 
        panel.grid = element_blank(), 
        axis.title = element_text(color = "black", 
                                  face = "bold", size = 8),
        legend.title = element_blank(), 
        strip.text = element_text(size = 7.5, color = "white", 
                                  face = "bold", margin = margin(0.5, 0, 0.5, 0, "mm"))
  )

p2 <- 
  ggplot(data = pcod_condition,
         aes(x = year, 
             y = stratum_resid_mean, 
             fill = nmfs_area,
             ymin = stratum_resid_mean - 2*stratum_resid_se,
             ymax = stratum_resid_mean + 2*stratum_resid_se)) +
  geom_hline(yintercept = 0) +
  geom_linerange() +
  geom_bar(stat = "identity", 
           color = "black", 
           position = "stack", 
           width = 1) +
  facet_wrap(~nmfs_area, 
             ncol = 4, 
             scales = "free_y") +
  scale_x_continuous(name = "Year", breaks = scales::pretty_breaks()) +
  scale_y_continuous(name = "Length-weight residual (ln(g))") +
  scale_fill_brewer(name = "Stratum", 
                    palette = "BrBG", 
                    drop = FALSE) + 
  theme_blue_strip() + 
  theme(legend.position = "none",
        title = element_text(hjust = 0.5),
        axis.text.y = element_text(size = 7), 
        axis.text.x = element_text(size = 7), 
        panel.grid = element_blank(), 
        axis.title = element_text(color = "black", 
                                  face = "bold", size = 8),
        legend.title = element_blank(), 
        strip.text = element_text(size = 7.5, color = "white", 
                                  face = "bold", margin = margin(0.5, 0, 0.5, 0, "mm"))
  )
  
png(here::here("PCOD_AI_INPFC_CONDITION_WIDE.png"), 
    width = 6, height = 2, units = "in", res = 300)
print(p1)
dev.off()

png(here::here("PCOD_AI_NMFS_AREA_CONDITION_WIDE.png"), 
    width = 6, height = 2, units = "in", res = 300)
print(p2)
dev.off()
