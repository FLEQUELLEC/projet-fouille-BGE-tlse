# 📦 Chargement des packages nécessaires
library(tidyverse)    # Manipulation des données
library(ggplot2)      # Visualisation
library(patchwork)    # Organisation des graphiques en grilles
library(plotly)       # Utilisation pour l'acm 3d
library(FactoMineR)
library(factoextra)
library(cluster)

# 📥 Chargement des données depuis différents chemins possibles
data <- read_csv("~/Documents/projet/data/thyroid_data.csv")
#data <- read_csv("~/projet/dossier_cancer/thyroid_data.csv")

# Résumé général des données (médianes, min, max, etc.)
summary(data)

# Comptage des modalités pour chaque variable qualitative
data %>%
  select(where(is.character)) %>%
  summarise(across(everything(), ~n_distinct(.)))

# Aperçu des valeurs distinctes pour chaque variable
lapply(data, unique)

# Sélection des variables numériques + variable cible
data_num <- data %>%
  select(where(is.numeric), Recurred)

# Restructuration longue pour créer des boxplots par variable
data_long <- data_num %>%
  pivot_longer(cols = -Recurred, names_to = "Variable", values_to = "Valeur")

# Création de boxplots pour comparer les variables numériques selon la récidive
ggplot(data_long, aes(x = Recurred, y = Valeur, fill = Recurred)) +
  geom_boxplot() +
  facet_wrap(~Variable, scales = "free_y") +
  theme_minimal() +
  labs(title = "Distribution des variables numériques selon la récidive",
       x = "Récidive", y = "Valeur") +
  theme(legend.position = "none")

# Préparation des variables qualitatives avec la variable cible
data_cat <- data %>%
  select(where(is.character), Recurred)


# Passage en format long pour les barplots
data_cat_long <- data_cat %>%
  pivot_longer(cols = -Recurred, names_to = "Variable", values_to = "Valeur")

# Affichage des proportions des modalités selon la récidive
ggplot(data_cat_long, aes(x = Valeur, fill = Recurred)) +
  geom_bar(position = "fill") +
  facet_wrap(~Variable, scales = "free_x") +
  theme_minimal() +
  labs(title = "Répartition des variables catégorielles selon la récidive",
       y = "Proportion", x = NULL) +
  scale_y_continuous(labels = scales::percent_format()) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# Test du Chi² pour chaque variable qualitative (hors Recurred) vs Recurred
cat_vars <- data %>%
  select(where(is.character)) %>%
  select(-Recurred) %>%
  names()

chi_results <- lapply(cat_vars, function(var) {
  tbl <- table(data[[var]], data$Recurred)
  test <- chisq.test(tbl)
  tibble(variable = var,
         p_value = test$p.value,
         statistic = test$statistic)
}) %>%
  bind_rows() %>%
  arrange(p_value)

# ##### Clustering #####

# 1) Récupérer nos variables catégorielles

data_mca = data[2:12]

# 2) ⚙️ Exécution de l'ACM
res_mca <- MCA(data_mca, graph = FALSE)

res_mca$eig
#pourcentage de variance axe 1: 17.3
#pourcentage de variance axe 2 : 9.6 # variance cumulée totale : 26.8 %
#pourcentage de variance axe 3 : 6.3 # variance cumulée totale : 33.2 %


# 3) 📐 Récupération des 5 premières dimensions
mca_coords <- res_mca$ind$coord[, 1:5]
#3bis) silhouette 
fviz_nbclust(mca_coords, kmeans,
             method = "silhouette",
             k.max = 10,       # nombre max de clusters à tester
             nstart = 25,
             verbose = FALSE) +
  labs(title = "Méthode de la silhouette — Choix optimal du nombre de clusters")

# 4) Clustering k-means sur coordonnées ACM
set.seed(123)
km_res <- kmeans(mca_coords, centers = 4, nstart = 25)

# 5) Ajout du cluster à chaque patient dans le jeu de données original
data_clustered <- data %>%
  mutate(cluster = factor(km_res$cluster))

# 6) Affichage 2D des clusters (Dim 1 & 2)
fviz_cluster(list(data = mca_coords, cluster = km_res$cluster),
             palette = "jco", ellipse.type = "convex",
             ggtheme = theme_minimal())

# 7) Table croisée entre clusters et récidive
table(data_clustered$cluster, data_clustered$Recurred)

# 8) Récapitulatif des modalités dominantes dans chaque cluster
data_clustered %>%
  group_by(cluster) %>%
  summarise(across(where(is.character), ~ names(sort(table(.), decreasing = TRUE))[1]))

# #####  Représentation interactive 3D #####

plot_data <- as.data.frame(mca_coords[, 1:3])
colnames(plot_data) <- c("Dim1", "Dim2", "Dim3")
plot_data$cluster <- factor(km_res$cluster)

# Visualisation interactive des clusters (3D)
plot_ly(plot_data, x = ~Dim1, y = ~Dim2, z = ~Dim3,
        color = ~cluster, colors = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728"),
        type = "scatter3d", mode = "markers") %>%
  layout(title = "Clusters sur les 3 premières dimensions ACM")

# Comparaison des âges selon la récidive

age_yes <- data$Age[data$Recurred == "Yes"]
age_no  <- data$Age[data$Recurred == "No"]

# Test de variance
var.test(age_yes, age_no)

# Test de normalité
shapiro.test(age_yes)
shapiro.test(age_no)

# Histogrammes des distributions d'âge
hist(age_yes)
hist(age_no)

# Transformations : log
age_yes_log <- log(age_yes)
age_no_log <- log(age_no)

var.test(age_yes_log, age_no_log)
shapiro.test(age_yes_log)
shapiro.test(age_no_log)
hist(age_yes_log)
hist(age_no_log)

# Transformations : carré
age_yes_carre <- age_yes^2
age_no_carre <- age_no^2

var.test(age_yes_carre, age_no_carre)
shapiro.test(age_yes_carre)
shapiro.test(age_no_carre)

# Test de Wilcoxon (non paramétrique)
wilcox.test(age_yes, age_no, alternative = "greater")

# Affichage de tous les barplots des variables qualitatives
var_quali <- c("Gender", "Hx_Radiothreapy", "Adenopathy", "Pathology", "Focality", 
               "Risk", "T", "N", "M", "Stage", "Response", "Recurred")

plots <- list()
for (var in var_quali) {
  p <- ggplot(data, aes_string(x = var)) +
    geom_bar(fill = "#0073C2FF") +
    ggtitle(paste("Distribution des modalités pour", var)) +
    xlab(var) + ylab("Nombre d'individus") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  plots[[var]] <- p
}
wrap_plots(plots, ncol = 3)  # Affichage organisé 
#(utiliser le "zoom" pour voir le résutlat bien affiché)

# Taux global de récidive
nrow(data[data$Recurred == 'Yes', ]) / nrow(data)  # ~28 %

# Pourcentage de récidive pour chaque modalité
for (var in var_quali) {
  cat("\nVariable:", var, "\n")
  for (mod in unique(data[[var]])) {
    total <- nrow(data[data[[var]] == mod, ])
    rec <- nrow(data[data$Recurred == "Yes" & data[[var]] == mod, ])
    perc <- round((rec / total) * 100, 1)
    cat("  Modalité:", mod, 
        "- Total:", total, 
        "- Récidives:", rec, 
        "- % Récidive:", perc, "%\n")
  }
}

