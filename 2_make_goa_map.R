library(akgfmaps)
library(shadowtext)
library(akfishcondition)

map_layers <- akgfmaps::get_base_layers(select.region = "goa", set.crs = "EPSG:3338")

map_layers$survey.strata$GOA_SUBAREA <- floor((map_layers$survey.strata$STRATUM %% 100)/10)

map_layers$survey.strata <- map_layers$survey.strata |>
  dplyr::inner_join(
    data.frame(
      GOA_SUBAREA = 1:5,
      NMFS_AREA = seq(610, 650, 10)
      ),
    by = "GOA_SUBAREA"
  )

subareas <- 
  map_layers$survey.strata |>
  dplyr::select(NMFS_AREA, GOA_SUBAREA) |>
  dplyr::group_by(NMFS_AREA, GOA_SUBAREA) |>
  dplyr::summarise(do_union = TRUE)

subarea_labels <- sf::st_centroid(subareas)
subarea_labels[c("X", "Y")] <- sf::st_coordinates(subarea_labels)

location_labels <-
  data.frame(
    x = c(-145, -157.5),
    y = c(57, 60),
    label = c("Gulf of Alaska", "Alaska")
  ) |>
  sf::st_as_sf(coords = c("x", "y"), crs = "WGS84") |>
  sf::st_transform(crs = "EPSG:3338")

location_labels[c("X", "Y")] <- sf::st_coordinates(location_labels)

goa_map <- 
  ggplot() +
  geom_sf(data = map_layers$akland, color = "grey30", fill = "grey70", linewidth = rel(0.2)) +
  geom_sf(data = subareas, 
          mapping = aes(fill = akfishcondition::set_stratum_order(NMFS_AREA, region = "GOA")),
          color = "black",
          linewidth = 0.2) +
  geom_shadowtext(data = subarea_labels, 
                  mapping = aes(
                    x = X,
                    y = Y,
                    label = NMFS_AREA),
                    # color = akfishcondition::set_stratum_order(NMFS_AREA, region = "GOA")),
                  color = "black",
                  bg.color = "white") +
  geom_shadowtext(data = location_labels, 
                  mapping = aes(
                    x = X,
                    y = Y,
                    label = label),
                  color = "black",
                  bg.color = "white") +
  geom_sf(data = map_layers$graticule,
          linewidth = 0.1, 
          alpha = 0.3) +
  scale_fill_brewer(palette = "BrBG") +
  scale_color_brewer(palette = "BrBG") +
  scale_x_continuous(limits = map_layers$plot.boundary$x) +
  scale_y_continuous(limits = map_layers$plot.boundary$y) +
  theme_blue_strip() +
  theme(legend.position = "none",
        axis.title = element_blank())

png(here::here("plots", "GOA", "GOA_survey_area.png"), width = 169, height = 60, units = "mm", res = 300)
print(goa_map)
dev.off()
