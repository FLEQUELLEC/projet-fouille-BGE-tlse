# 📊 Fouille Project – Analyse de la récidive du cancer de la thyroïde

## 📌 Description
**Fouille Project** est un projet de fouille de données développé dans le cadre du module **Fouille de Données** du Master BGE à l’Université Paul Sabatier - Toulouse III. Il vise à explorer des données médicales afin d’identifier des patterns associés à la récidive du cancer de la thyroïde après traitement.

---

## 🌟 Objectifs de l'analyse

L’objectif principal est d’exploiter des techniques de fouille de données supervisées et non-supervisées pour explorer les facteurs liés à la récidive du cancer. Ce projet se concentre sur :

- L’analyse des **profils cliniques et pathologiques** des patients
- L’identification de **facteurs de risque potentiels**
- L’utilisation d’algorithmes de **classification** pour prédire la récidive
- L’exploration de **groupes de patients similaires** par **clustering**
- La visualisation des résultats pour faciliter l’interprétation médicale

> Cette analyse est exploratoire et les objectifs seront amenés à évoluer avec l’avancement du projet.

---

## ⚙️ Fonctionnalités
- Exploration et traitement de données médicales
- Préparation de la matrice individus-variables
- Application d’algorithmes de classification (arbres de décision, forêts aléatoires, etc.)
- Clustering non supervisé (k-means, DBSCAN…)
- Visualisations des résultats (ACP, heatmaps, arbres…)

---

## 📅 Calendrier du projet

### ✅ Rendu 1 — 21 mars : Création du groupe et dépôt GitLab
- Création du dépôt GitLab
- Ajout de `@rbarriot` en tant que membre
- Envoi d’un mail avec :
  - Lien GitLab
  - Lien du jeu de données
  - Description des données (type, nb individus/variables)

### 🔍 Rendu 2 — 4 avril : Données et objectifs
- Mise à jour du README :
  - Description du dataset
  - Objectifs d’analyse
  - Variables et transformations envisagées
  - Classe prédite (si classification)

### 🧪 Rendu 3 — 18 avril : Matrice individus-variables
- Génération de la matrice
- Stockage dans `/data`
- Scripts dans `/data_preparation`
- Documentation du processus

### 📊 Rendu 4 — 25 avril : Résultats et analyse finale
- Rapport complet dans `/rapport`
- Résultats dans `/analysis`
- Mise à jour du README
- Dépôt du rapport sur Moodle + envoi à RB

---

## 📜 Jeu de données

Données issues de :  
> *Differentiated Thyroid Cancer Recurrence*  
> Auteur : Joe Beach Capital – [Kaggle](https://www.kaggle.com/datasets/joebeachcapital/differentiated-thyroid-cancer-recurrence)

Ce jeu de données a été filtré et nettoyé pour se concentrer sur l’analyse de la récidive post-traitement.

### 📂 Contexte
Le dataset se concentre sur la récidive du **cancer de la thyroïde** après un traitement par **iode radioactif (RAI)**. Il contient des données cliniques, pathologiques, et des informations de suivi pour 383 patients.

### 📊 Vue d’ensemble
- **Nombre d'observations** : 383
- **Nombre de variables** : 13
- **Données manquantes** : Aucune
- **Type** : données tabulaires, mixtes (catégorielles + numériques)

### 🧬 Variables disponibles

| Nom de la variable     | Description |
|------------------------|-------------|
| `Age`                  | Âge du patient |
| `Gender`               | Sexe (Male/Female) |
| `Hx Radiotherapy`      | Antécédents de radiothérapie |
| `Adenopathy`           | Atteinte ganglionnaire |
| `Pathology`            | Type de cancer thyroïdien |
| `Focality`             | Focalité tumorale (Uni/Multi) |
| `Risk`                 | Niveau de risque |
| `T`, `N`, `M`          | Classifications TNM |
| `Stage`                | Stade du cancer |
| `Response`             | Réponse au traitement |
| `Recurred`             | Récidive (Yes/No) |

### 🔍 Utilisation prévue
- **Classification** : prédire la récidive (`Recurred`)
- **Clustering** : regrouper les profils de patients
- **Statistiques exploratoires** : comprendre les corrélations cliniques

---

## 👨‍💻 Installation

```bash
# Cloner le dépôt
git clone https://gitlab.com/fouille_project/projet.git
cd projet
```

---

## 📈 Visuals
📌 *Captures d'écran, visualisations, ou graphiques à insérer ici ultérieurement*

---

## 🤝 Auteurs & Remerciements

Projet mené par :
- **Florent LE QUELLEC**
- **Antonin MENARD**

Encadré par **Roland BARRIOT** – merci pour ses conseils et son accompagnement.

---

## 📜 Licence

Ce projet est sous licence **Apache 2.0** — voir le fichier [LICENSE](LICENSE) pour plus d’informations.

---

## 🚧 Statut du projet

💠 En développement actif

