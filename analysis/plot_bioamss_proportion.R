library(akfishcondition)
library(cowplot)

biomass_dat <- read.csv(file = here::here("data", "goa_stratum_biomass_all_species.csv")) |>
  dplyr::filter(species_code %in% c(30051, 30052), year >= 2007) |>
  dplyr::inner_join(
    akfishcondition::ESR_SETTINGS$ESR_SPECIES
  )

biomass_summary <- 
  biomass_dat |>
  dplyr::group_by(
    year, species_code, common_name
  ) |>
  dplyr::summarise(
    total_biomass = sum(biomass_mt)
  ) |>
  dplyr::inner_join(
    biomass_dat
  ) |>
  dplyr::mutate(
    prop_biomass = biomass_mt/total_biomass
  )


p_biomass <- 
  ggplot() + 
  geom_bar(data = 
             biomass_dat,
           mapping = aes(
             x = year, 
             y = biomass_mt, 
             fill = set_stratum_order(area_id, region = "GOA"), 
             group = year
           ),
           color = "black",
           linewidth = 0.2,
           stat = "identity") +
  scale_fill_brewer(name = "Area", palette = "BrBG") +
  scale_x_continuous(name = "Year") +
  scale_y_continuous(name = "Biomass (mt)") +
  facet_wrap(~akfishcondition::set_plot_order(common_name, region = "GOA")) +
  theme_bw()

p_prop_biomass <- 
  ggplot() + 
  geom_bar(data = 
             biomass_summary,
           mapping = aes(
             x = year, 
             y = prop_biomass*100, 
             fill = set_stratum_order(area_id, region = "GOA"), 
             group = year
           ),
           color = "black",
           linewidth = 0.2,
           width = 2,
           stat = "identity") +
  scale_fill_brewer(name = "Area", palette = "BrBG") +
  scale_x_continuous(name = "Year", expand = c(0,0)) +
  scale_y_continuous(name = "Biomass (%)", expand = c(0,0)) +
  facet_wrap(~akfishcondition::set_plot_order(common_name, region = "GOA")) +
  theme_bw()


cowplot::plot_grid(
  p_biomass,
  p_prop_biomass,
  nrow = 2
)
