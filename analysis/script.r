library(tidyverse)

jd <- read.delim("~/Documents/projet/data/jeu_de_donnees_ebird.txt")

jdp <- jd %>%
  select(COMMON.NAME, OBSERVATION.DATE, TIME.OBSERVATIONS.STARTED, OBSERVATION.COUNT) %>%
  mutate(heure = lubridate::hour(hms::as_hms(TIME.OBSERVATIONS.STARTED)))

write_csv(jdp, "~/Documents/projet/data.preparation/jeu_donnée_v1.csv")
