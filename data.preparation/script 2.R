# 📦 Chargement des packages
library(tidyverse)
library(ggplot2)
library(patchwork)

# 📥 Chargement des données
data <- read_csv("~/Documents/projet/data/thyroid_data.csv")
data <- read_csv("~/projet/dossier_cancer/thyroid_data.csv")


# 🧾 Résumé général des données
summary(data)

# 🔍 Nombre de modalités par variable catégorielle
data %>%
  select(where(is.character)) %>%
  summarise(across(everything(), ~n_distinct(.)))

lapply(data, unique)

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
""
#13.6 + 23.2

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
#20 +20%

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



#acm sans age
data <- read_csv("~/projet/data/thyroid_data.csv")

data_no_age = data[2:13]
library(ade4)
acm1=dudi.coa(data_no_age)
scatter(acm1, col =rainbow(7))

# acm sans age et recurred # presque la même chose 

data_no_age_rec = data[2:12]
library(ade4)
acm1=dudi.coa(data_no_age_rec)
scatter(acm1, col =rainbow(7))

acm1$eig[1]/sum(acm1$eig)*100 #43.47
acm1$eig[2]/sum(acm1$eig)*100 #15.67
# = 59.1%



# compraison des moyennes des ages avec et sans Recurred

# données de base
age_yes <- data$Age[data$Recurred == "Yes"]
age_no  <- data$Age[data$Recurred == "No"]

var.test(age_yes, age_no)
#p-value = 7.678e-06

shapiro.test(age_yes)
#p-value = 0.0003752

shapiro.test(age_no)
#p-value = 1.963e-08

hist(age_yes)

hist(age_no)

#log
age_yes_log <- log(data$Age[data$Recurred == "Yes"])
age_no_log  <- log(data$Age[data$Recurred == "No"])

var.test(age_yes_log, age_no_log)
#p-value = 0.001365

shapiro.test(age_yes_log)
#p-value = 0.0006241

shapiro.test(age_no_log)
#p-value = 0.04131

hist(age_yes_log)

hist(age_no_log)

#carré
age_yes_carre <- data$Age[data$Recurred == "Yes"]^2
age_no_carre  <- data$Age[data$Recurred == "No"]^2

var.test(age_yes_carre, age_no_carre)
#p-value = 2.426e-09

shapiro.test(age_yes_carre)
#p-value = 1.611e-06

shapiro.test(age_no_carre)
#p-value = 2.765e-15

#wilcox.test


wilcox.test(age_yes, age_no, alternative = "greater")
p-value = 1.777e-05

# afficher tous les barplots des effectifs pour chaque variables (utiliser le zoom, 
# la prévisualisation s'affiche mal)

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


# Afficher tous les graphiques ensemble
wrap_plots(plots, ncol = 3)



# tx de récidive
nrow(data[data$Recurred == 'No', ])# 108/383 -> 0.2819843% de recidive
nrow(data[data$Recurred == 'Yes', ]) # 0.72





# valeurs numérique graphique de répartition de nos variables catégorielles selon la récidive 

var_quali <- c("Gender", "Hx_Radiothreapy", "Adenopathy", "Pathology", "Focality", 
               "Risk", "T", "N", "M", "Stage", "Response")

# (nb d'ind par modalité avec récidive)
for (var in var_quali) {
  cat("\nVariable:", var, "\n")
  
  for (mod in unique(data[[var]])) {
    # Nombre total d'individus pour cette modalité
    total <- nrow(data[data[[var]] == mod, ])
    
    # Nombre de récidives pour cette modalité
    rec <- nrow(data[data$Recurred == "Yes" & data[[var]] == mod, ])
    
    # Pourcentage de récidives
    perc <- round((rec / total) * 100, 1)
    
    cat("  Modalité:", mod, 
        "- Total:", total, 
        "- Récidives:", rec, 
        "- % Récidive:", perc, "%\n")
  }
}





