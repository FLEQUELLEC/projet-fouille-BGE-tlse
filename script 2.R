library(tidyverse)
library(lubridate)
library(cluster)
library(factoextra)  # pour l’ACP et la visualisation du clustering
library(dbscan)


jd <- read.delim("~/Documents/projet/data/jeu_de_donnees_ebird.txt")

jdp <- jd %>%
  select(COMMON.NAME, OBSERVATION.DATE, TIME.OBSERVATIONS.STARTED, OBSERVATION.COUNT) %>%
  mutate(heure = lubridate::hour(hms::as_hms(TIME.OBSERVATIONS.STARTED)))

# Extraire les variables utiles et transformer l’heure
jdp_clust <- jd %>%
  select(`OBSERVATION.COUNT`, `DURATION.MINUTES`, `EFFORT.DISTANCE.KM`, `TIME.OBSERVATIONS.STARTED`) %>%
  filter(!is.na(`OBSERVATION.COUNT`) & !is.na(`DURATION.MINUTES`) & !is.na(`EFFORT.DISTANCE.KM`) & !is.na(`TIME.OBSERVATIONS.STARTED`)) %>%
  mutate(heure = hour(hms(`TIME.OBSERVATIONS.STARTED`))) %>%
  select(heure, `DURATION.MINUTES`, `EFFORT.DISTANCE.KM`, `OBSERVATION.COUNT`) %>%
  drop_na()

jdp_scaled <- scale(jdp_clust)

set.seed(123)  # Pour reproductibilité

kmeans_res <- kmeans(jdp_scaled, centers = 5, nstart = 25)
jdp_clust$cluster <- as.factor(kmeans_res$cluster)


fviz_cluster(kmeans_res, data = jdp_scaled,
             geom = "point",
             ellipse.type = "convex",
             palette = "jco",
             ggtheme = theme_minimal())

jdp_clust %>%
  group_by(cluster) %>%
  summarise(across(everything(), mean), .groups = "drop")

fviz_nbclust(jdp_scaled, kmeans, method = "wss")  # wss = within sum of squares


kNNdistplot(jdp_scaled, k = 5)  # k = minPts (tu peux essayer aussi avec 4, 6…)
abline(h = 1.5, col = "red", lty = 2)  # On ajustera h selon l'inflexion visuelle

db_res <- dbscan(jdp_scaled, eps = 1.2, minPts = 5)
jdp_clust$dbscan_cluster <- as.factor(db_res$cluster)

fviz_cluster(list(data = jdp_scaled, cluster = db_res$cluster),
             geom = "point", ellipse = FALSE,
             palette = "jco", ggtheme = theme_minimal())

jdp_clust %>%
  group_by(dbscan_cluster) %>%
  summarise(across(c(heure, DURATION.MINUTES, EFFORT.DISTANCE.KM, OBSERVATION.COUNT), mean), .groups = "drop")

jdp_clust <- bind_cols(jdp_clust, COMMON.NAME = jdp$COMMON.NAME)

table(jdp_clust$dbscan_cluster, jdp_clust$COMMON.NAME)
