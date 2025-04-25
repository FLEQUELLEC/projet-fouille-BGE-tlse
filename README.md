# 📊 Fouille Project – Analyse de la récidive du cancer de la thyroïde

## 📌 Description

**Fouille Project** est un projet de fouille de données mené dans le cadre du module **Fouille de Données** du Master BGE à l’Université de Toulouse (anciennement Paul Sabatier). Il vise à explorer un jeu de données médicales afin d’identifier les facteurs de risque associés à la récidive du cancer de la thyroïde après traitement.

------------------------------------------------------------------------

## 🌟 Objectifs de l’analyse

L’objectif principal est de mobiliser des méthodes de **fouille de données supervisées et non-supervisées** pour mieux comprendre les mécanismes de récidive du **cancer de la thyroïde** après administration d’iode radioactif (RAI).

Le projet vise notamment à :

-   🧬 **Analyser les profils cliniques et pathologiques** des patients
-   ⚠️ **Identifier les facteurs de risque potentiels** (âge, type de tumeur, réponse au traitement, etc.)
-   🧠 **Tester des algorithmes de classification** (arbre de décision, forêt aléatoire, bayésien)
-   🧩 **Regrouper les patients par similarité** via le **clustering non supervisé** (ACM + k-means)

------------------------------------------------------------------------

## ⚙️ Fonctionnalités

-   Analyse statistique descriptive et visualisation des variables
-   Préparation d’une matrice individus-variables
-   Application de modèles de classification supervisée
-   Clustering non supervisé basé sur l’ACM
-   Visualisations dynamiques 2D et 3D des groupes détectés

------------------------------------------------------------------------

## 📅 Calendrier du projet

### ✅ Rendu 1 — 21 mars

-   Création du dépôt GitLab
-   Partage du lien avec l’enseignant
-   Description préliminaire des données

### 🔍 Rendu 2 — 4 avril

-   Définition des objectifs
-   Sélection et préparation du jeu de données
-   Prévision des méthodes d’analyse

### 🧪 Rendu 3 — 18 avril

-   Préparation des jeux de données transformés
-   Construction de la matrice individus-variables
-   Début des visualisations et traitements exploratoires

### 📊 Rendu 4 — 25 avril

-   Finalisation des analyses (classification et clustering)
-   Rédaction et dépôt du rapport final
-   Nettoyage du dépôt GitLab et dépôt sur Moodle

------------------------------------------------------------------------

## 📜 Jeu de données

Jeu de données provenant de :\
\> *Thyroid Cancer Recurrence Dataset (modifié)*\
\> Auteur original : Joe Beach Capital – [Kaggle](https://www.kaggle.com/datasets/joebeachcapital/differentiated-thyroid-cancer-recurrence)\
\> Version nettoyée et filtrée par : Aneesha Anto – [Kaggle](https://www.kaggle.com/datasets/aneevinay/thyroid-cancer-recurrence-dataset?resource=download)

### 📂 Contexte

Ce dataset rassemble les données cliniques de **383 patients** atteints d’un cancer de la thyroïde, ayant reçu un traitement à l’iode radioactif. Il permet d’étudier les facteurs liés à la **récidive**.

### 📊 Vue d’ensemble

-   **Observations** : 383
-   **Variables** : 13
-   **Données manquantes** : aucune
-   **Types** : catégorielles et une quantitative (`Age`)

### 🧬 Variables principales

| Variable          | Description                    |
|-------------------|--------------------------------|
| `Age`             | Âge du patient                 |
| `Gender`          | Sexe (Male/Female)             |
| `Hx Radiotherapy` | Antécédents de radiothérapie   |
| `Adenopathy`      | Présence de ganglions atteints |
| `Pathology`       | Type histologique du cancer    |
| `Focality`        | Focalité tumorale (uni/multi)  |
| `Risk`            | Niveau de risque               |
| `T`, `N`, `M`     | Classifications TNM            |
| `Stage`           | Stade du cancer                |
| `Response`        | Réponse au traitement          |
| `Recurred`        | Récidive observée (Yes/No)     |

### 🔍 Utilisation prévue

-   Prédiction de la récidive (`Recurred`) par classification
-   Exploration des profils patients via clustering
-   Analyse statistique des variables cliniques et TNM

------------------------------------------------------------------------

## 👨‍💻 Installation

``` bash
# Cloner le dépôt
git clone https://gitlab.com/fouille_project/projet.git
cd projet
```

------------------------------------------------------------------------

## 🤝 Auteurs & Remerciements

Projet mené par : - **Florent LE QUELLEC** - **Antonin MENARD**

Encadrement : **Roland BARRIOT** – Merci pour son suivi et ses retours tout au long du projet.

------------------------------------------------------------------------

## 📜 Licence

Ce projet est sous licence **Apache 2.0** – voir le fichier [LICENSE](LICENSE).

------------------------------------------------------------------------

## ✅ Statut du projet

✔️ **Projet terminé**\
Toutes les étapes prévues ont été réalisées et les livrables ont été remis conformément au cahier des charges pédagogique.

------------------------------------------------------------------------

## 🏁 Résultats clés

-   🔍 Le taux global de récidive observé est de 28 %, les facteurs les plus corrélés à la récidive étant : adénopathie, type de réponse au traitement, et niveau de risque.
-   🌳 Les meilleurs modèles de classification (arbre de décision, forêt aléatoire) ont obtenu des taux d’erreur inférieurs à 5 %.
-   🔗 Le clustering a permis d’identifier des profils patients distincts et cohérents avec les classes cliniques.
-   📊 Une interface interactive 3D permet de visualiser les clusters issus de l’ACM et du k-means.

------------------------------------------------------------------------

## 🧪 Matériel utilisé

L’analyse des données a été réalisée à l’aide de :

-   **R (v4.4.2)** et **RStudio** pour l’analyse exploratoire, les visualisations, l’analyse multivariée (ACM) et le clustering
    -   Packages principaux : `tidyverse`, `ggplot2`, `patchwork`, `FactoMineR`, `factoextra`, `plotly`, `cluster`
-   **KNIME (v5.4.3)** pour la classification automatique avec validation croisée (arbres, forêts, naïf bayésien)

------------------------------------------------------------------------

## 🗂️ Structure du dépôt

-   `/data` : données sources et matrice individus-variables
-   `/data_preparation` : scripts de transformation et nettoyage
-   `/analysis` : scripts R et workflows KNIME pour les analyses
-   `/rapport` : rapport final au format PDF
