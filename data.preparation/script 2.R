# 📦 Chargement des packages
library(tidyverse)

# 📥 Chargement des données
data <- read_csv("~/Documents/projet/data/thyroid_data.csv")

# 🧾 Résumé général des données
summary(data)

# 🔍 Nombre de modalités par variable catégorielle
data %>%
  select(where(is.character)) %>%
  summarise(across(everything(), ~n_distinct(.)))

# 📊 Préparation des variables numériques pour visualisation
data_num <- data %>%
  select(where(is.numeric), Recurred)

# ⬇️ Passage en format long pour ggplot
data_long <- data_num %>%
  pivot_longer(cols = -Recurred, names_to = "Variable", values_to = "Valeur")

# 📈 Boxplots pour chaque variable numérique selon la récidive
ggplot(data_long, aes(x = Recurred, y = Valeur, fill = Recurred)) +
  geom_boxplot() +
  facet_wrap(~Variable, scales = "free_y") +
  theme_minimal() +
  labs(title = "Distribution des variables numériques selon la récidive",
       x = "Récidive", y = "Valeur") +
  theme(legend.position = "none")

# 📊 Préparation des variables catégorielles
data_cat <- data %>%
  select(where(is.character), Recurred)

# ⬇️ Format long pour barplots
data_cat_long <- data_cat %>%
  pivot_longer(cols = -Recurred, names_to = "Variable", values_to = "Valeur")

# 📊 Barplots en proportion selon la récidive
ggplot(data_cat_long, aes(x = Valeur, fill = Recurred)) +
  geom_bar(position = "fill") +
  facet_wrap(~Variable, scales = "free_x") +
  theme_minimal() +
  labs(title = "Répartition des variables catégorielles selon la récidive",
       y = "Proportion", x = NULL) +
  scale_y_continuous(labels = scales::percent_format()) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# 🧪 Test du Chi² pour chaque variable catégorielle vs Recurred
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

# 🧬 Analyse des correspondances multiples (ACM) avec variables catégorielles principales
library(FactoMineR)
library(factoextra)

res_mca <- MCA(data[, c("Gender", "Pathology", "Risk", "Stage", "Recurred")], graph = FALSE)

# 📊 Visualisation ACM avec coloration selon Recurred
fviz_mca_ind(res_mca, label = "none", habillage = "Recurred")

##### 🧠 Clustering #####

# 1. 🧹 Nettoyage des données : convertir en facteurs + retirer la cible
data_mca <- data %>%
  mutate(across(where(is.character), as.factor)) %>%
  select(-Recurred)

# 2. ❌ Suppression des variables constantes (1 seule modalité)
data_mca <- data_mca %>% select(where(~ nlevels(.) > 1))

# 3. ✨ ACM complète
res_mca <- MCA(data_mca, graph = FALSE)

# 4. 📐 Récupération des 5 premières dimensions (ou plus selon ton scree plot)
mca_coords <- res_mca$ind$coord[, 1:5]

# 5. 🧩 Clustering k-means sur les coordonnées ACM
set.seed(123)
km_res <- kmeans(mca_coords, centers = 4, nstart = 25)

# 6. 🔗 Ajout des clusters au dataset original
data_clustered <- data %>%
  mutate(cluster = factor(km_res$cluster))

# 7. 📈 Visualisation des clusters sur Dim 1 & 2 (projection plane)
fviz_cluster(list(data = mca_coords, cluster = km_res$cluster),
             palette = "jco", ellipse.type = "convex",
             ggtheme = theme_minimal())

# 8. 🧾 Croisement entre clusters et récidive
table(data_clustered$cluster, data_clustered$Recurred)

# 9. 🧠 Résumé du profil dominant dans chaque cluster
data_clustered %>%
  group_by(cluster) %>%
  summarise(across(where(is.character), ~ names(sort(table(.), decreasing = TRUE))[1]))

##### 📍 Visualisation 3D interactive #####

library(plotly)

# 📦 Préparation des 3 premières dimensions ACM + clusters
plot_data <- as.data.frame(mca_coords[, 1:3])
colnames(plot_data) <- c("Dim1", "Dim2", "Dim3")
plot_data$cluster <- factor(km_res$cluster)

# 📊 Plot interactif 3D
plot_ly(plot_data, x = ~Dim1, y = ~Dim2, z = ~Dim3,
        color = ~cluster, colors = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728"),
        type = "scatter3d", mode = "markers") %>%
  layout(title = "Clusters sur les 3 premières dimensions ACM")

