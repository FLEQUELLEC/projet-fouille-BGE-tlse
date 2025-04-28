# Rapport de fouille

## La fouille de données au service de la médecine
Antonin MÉNARD – Florent LE QUELLEC

---

## Sommaire

- [Introduction](#introduction)
- [Matériel et Méthode](#matériel-et-méthode)
- [Résultats](#résultats)
  - [Analyse exploratoire](#analyse-exploratoire)
  - [Adenopathy](#adenopathy)
  - [Focality](#focality)
  - [Gender](#gender)
  - [Hx Radiotherapy](#hx-radiotherapy)
  - [Métastase (M)](#métastase-m)
  - [Ganglion touché (N)](#ganglion-touché-n)
  - [Taille (T)](#taille-t)
  - [Pathology](#pathology)
  - [Response](#response)
  - [Risk](#risk)
  - [Stage](#stage)
  - [Clustering](#clustering)
  - [Classification](#classification)
- [Conclusion](#conclusion)
- [Bibliographie](#bibliographie)
- [Annexes](#annexes)

---

# Introduction

Une tumeur se caractérise par la prolifération anormale de cellules dont le système de division est déréglé, conduisant à la formation d’une masse. Cette tumeur peut être bénigne (localisée, sans caractère invasif) ou maligne (capable d’envahir les tissus voisins ou de se propager à distance). Lorsqu’une tumeur est maligne, on parle alors de tumeur cancéreuse, ou plus simplement de cancer.[1][2]

Dans notre cas, nous nous intéressons au cancer de la thyroïde, qui représente environ 5 % des tumeurs thyroïdiennes, et qui est essentiellement diagnostiqué chez des femmes[3]. Ce cancer reste relativement rare en France, mais son incidence est en augmentation constante depuis plusieurs années, notamment grâce à l'amélioration des techniques de détection[4]. D’après la Société canadienne du cancer, sur 6 600 nouveaux cas de cancer de la thyroïde diagnostiqués en une année, environ 280 décès sont enregistrés, soit un taux de mortalité de 4,2 %. Il s’agit en réalité d’un cancer au pronostic globalement favorable, mais qui nécessite un suivi attentif en raison des risques de récidive. [5]
Grâce à la fouille de données, il devient possible d'explorer de grands ensembles de données cliniques afin de détecter des profils à risque, des relations cachées entre variables, ou encore de prédire des issues médicales comme dans notre cas : la récidive. Cela permet de transformer des données statiques en connaissances utilisables pour la recherche médicale.

Ce projet a pour objectif d’explorer un jeu de données clinique regroupant 383 patients atteints de cancer de la thyroïde, dans le but de :
Identifier les variables les plus fortement liées à la récidive
Regrouper les patients selon des profils communs (clustering)
Tester des modèles de classification pour prédire la récidive
Pour répondre à ces objectifs, une série d’analyses ont été menées : analyse exploratoire des données, application d’une Analyse des Correspondances Multiples (ACM) pour la réduction de dimension, clustering non supervisé par k-means pour détecter des groupes de patients similaires, et enfin des modèles supervisés (arbre de décision, forêt aléatoire, modèle bayésien) ont été évalués pour prédire la récidive.

---

# Matériel et Méthode

Notre jeu de données provient du site Kaggle. Ce jeu de données porte sur la récidive du cancer de la thyroïde après un traitement par iode radioactif (RAI). Il regroupe les informations cliniques de 383 patients, décrites à travers 13 variables clés, telles que l’âge, le sexe, le type de pathologie, le stade du cancer, la classification du risque, la réponse au traitement et la survenue éventuelle d’une récidive.

Ces données sont particulièrement utiles pour prédire le risque de récidive, mieux comprendre les facteurs de risque associés et évaluer l’efficacité des traitements administrés.

Le jeu de données comprend 13 variables décrivant les caractéristiques cliniques, pathologiques et thérapeutiques de 383 patients atteints d’un cancer de la thyroïde. Parmi ces variables, une seule est quantitative : l’âge du patient. Les douze autres sont qualitatives et couvrent des aspects variés tels que le sexe, les antécédents de radiothérapie, la présence de ganglions lymphatiques atteints (Adenopathy), le type histologique de la tumeur (Pathology), la focalité tumorale, ou encore la classification TNM (T, N, M). On y trouve également des variables résumant le stade global du cancer (Stage), la réponse au traitement (Response), et enfin la présence ou non d’une récidive (Recurred), qui constitue la variable cible dans les analyses de classification. L’ensemble de ces variables permet d’analyser en profondeur les profils de patients et d’explorer les facteurs potentiels de récidive. Pour plus d'information, consulter les tableaux annexes 1, 2 et 3.

Les données ont été traitées à l’aide de R (version 4.4.2) et de RStudio pour la phase d’analyse exploratoire et de clustering. Les packages utilisés incluent :
tidyverse (Wickham et al., 2019), ggplot2 (Wickham, 2016) et patchwork (Pedersen, 2024) pour la manipulation des données et la création de visualisations graphiques,
Cluster (Maechler et al., 2025), FactoMineR (Lê, Josse & Husson, 2008) et factoextra (Kassambara & Mundt, 2020) pour la réalisation de l’analyse des correspondances multiples (ACM),
plotly (Sievert, 2020) pour les visualisations interactives en trois dimensions,

L’ensemble des données a été soumis à plusieurs étapes de prétraitement avant l’analyse :

Conversion des variables catégorielles au format factor afin de permettre une analyse statistique adaptée,
Analyse univariée par la création de statistiques descriptives, d’histogrammes pour les variables numériques et de diagrammes en barres pour les variables catégorielles,
Réalisation de tests de normalité (Shapiro-Wilk) et de variance (F-test), ainsi qu’un test de Wilcoxon sur la variable Âge afin de comparer les groupes avec et sans récidive,
Application du test du Chi² pour évaluer l’indépendance entre les variables qualitatives et la variable cible Recurred,
Transformation des données au format long pour les représentations graphiques avec ggplot2,
Réalisation d’une ACM afin de réduire la dimensionnalité des données catégorielles en amont du clustering et réalisation d’un diagramme de silhouette pour représenter le nombre idéal de groupements de patients pour nos analyses, sur base d’un calcul de score de silhouette qui détermine la qualité de ces groupements,
Clustering non supervisé par la méthode des k-means sur les premières dimensions issues de l’ACM,
Interprétation des clusters par croisement avec les variables cliniques et la variable cible.

La phase de classification supervisée a été effectuée à l’aide de KNIME (version 5.4.3). À partir du fichier de données complet, plusieurs modèles ont été testés. Une validation croisée a été mise en place à l’aide des nœuds Partitioning (pour séparer les jeux d’apprentissage et de test) et X-Aggregator (pour compiler les résultats). Cela a permis d’évaluer la robustesse des modèles selon des métriques telles que le taux d’erreur moyen, le nombre moyen d’erreurs et la taille moyenne du jeu de test.


---

# Résultats

## Analyse exploratoire

Répartition de nos variables catégorielles (annexe 5)
Bien que notre nombre d’individus soit d’une taille respectable compte tenu des analyses qui vont être réalisées dessus, il demeure certains déséquilibres dans la répartition des modalités de nos données.
Les modalités présentes en majorité sont celles indiquant que les patients n’ont pas subi de radiographie Hx, n’ont pas d’adénopathie, ont un cancer à un niveau de développement intermédiaire, n’ont pas de métastase ou de tumeur qui aurait atteint au moins un ganglion, ont un cancer unilocal, une excellente réponse au traitement et un risque de propagation du cancer faible (un nombre inférieur, mais non négligeable d’individus possèdent un risque intermédiaire).
Tous ces éléments nous indiquent que la majorité de nos patients sont atteints de cancers relativement peu développés et qui réagissent bien au traitement, en lien avec le taux relativement faible de récidive. 
En outre, la majorité de nos individus sont atteints d’un cancer de type papillaire et sont des femmes (en conformité avec le sex ratio des patients atteints d’un cancer de la thyroïde), bien que notre échantillon d’individus hommes soit d’une taille acceptable (312 contre 71).


### Répartition des variables catégorielles

![Figure 1](./ky3132vp.png)

La figure 1 est une représentation de la distribution des différentes modalités pour chacune de nos variables catégorielles en fonction d’une récidive ou non du cancer (Recurred). Ce sont des barres empilées exprimées en pourcentage, afin d’observer la proportion relative de récidive pour chaque modalité.

### Adenopathy

*(Texte)*

### Focality

*(Texte)*

### Gender

*(Texte)*

### Hx Radiotherapy

*(Texte)*

### Métastase (M)

*(Texte)*

### Ganglion touché (N)

*(Texte)*

### Taille (T)

*(Texte)*

### Pathology

*(Texte)*

### Response

*(Texte)*

### Risk

*(Texte)*

### Stage

*(Texte)*

![Figure 2](./hsl0tafe.png)

![Figure 3](./cm3ncptz.png)

![Tableau 1](./2y0p0uan.png)

---

## Clustering

![Figure 4](./ya14e0pw.png)

Description des 4 clusters.

---

## Classification

Description des 4 modèles testés.

---

# Conclusion

*(Texte détaillé inchangé)*

---

# Bibliographie

*(Liste de références numérotées)*

---

# Annexes

## Annexe 1 : Description des variables utilisées

*(Tableau à insérer)*

## Annexe 2 : Classification TNM [6][7]

*(Tableau à insérer)*

## Annexe 3 : Classification des cancers par stade [8]

*(Tableau à insérer)*

## Annexe 4 : Caractéristiques des clusters

![Clusters](./awmyzhw4.png)

## Annexe 5 : Diagrammes en barre des variables

![Diagrammes en barre](./rhwlxy3s.png)

## Annexe 6 : Graphique silhouette

![Graphique silhouette](./awmyzhw4.png)

---

