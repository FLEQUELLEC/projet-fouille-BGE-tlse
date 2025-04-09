
# Fouille Project

## Description
**Fouille Project** est un projet de fouille de données visant à [ajouter ici l’objectif précis du projet – par exemple : explorer des ensembles de données environnementales, biologiques ou génomiques pour en extraire des patterns pertinents].

Ce projet est développé dans le cadre du module **Fouille de Données** du Master BGE à l’Université Paul Sabatier - Toulouse III.

## Fonctionnalités
- Exploration et traitement de données biologiques
- Visualisation des résultats
- Méthodes de fouille supervisée et non-supervisée
- Comparaison de performances selon plusieurs algorithmes

## Badges
![Build Status](https://img.shields.io/gitlab/pipeline-status/fouille_project/projet/main)  
![License](https://img.shields.io/badge/license-Apache%202.0-blue)

## 📅 Calendrier du projet

### ✅ Rendu 1 — 21 mars : Création du groupe et dépôt GitLab
- Création du projet GitLab
- Ajout de `@rbarriot` en tant que membre (rôle developer ou maintainer)
- Envoi d’un mail à RB avec :
  - Le lien GitLab
  - Le lien du jeu de données
  - Le type de données, le nombre d’individus et de variables

### 🔍 Rendu 2 — 4 avril : Données et objectifs
- Mise à jour de ce README avec :
  - Description du jeu de données
  - Lien vers les données
  - Objectifs détaillés (classification / clustering, etc.)
  - Variables utilisées et transformations prévues
  - Classe prédite (si classification)

### 🧪 Rendu 3 — 18 avril : Matrice individus-variables
- Fourniture de la matrice individus-variables
- Scripts de préparation dans `/data_preparation`
- Données et matrice dans `/data`
- Documentation sur le processus

### 📊 Rendu 4 — 25 avril : Analyse et résultats
- Mise à jour du README avec les résultats principaux
- Scripts d’analyse dans `/analysis`
- Rapport complet dans `/rapport`
- Dépôt du rapport PDF sur Moodle
- Envoi d’un mail final à RB

---

## Prérequis
- 🚧 **Projet en cours de développement actif**
  - `futur environnement`

## Installation

```bash
# Cloner le dépôt
git clone https://gitlab.com/fouille_project/projet.git
cd projet

# Installer les dépendances
pip install -r requirements.txt
```

## Utilisation

```bash
# Exemple d'exécution
python main.py data/input.csv
```

Un notebook `notebook.ipynb` est également disponible pour une exploration interactive.

## Visuals
*Capture d’écran ou graphique à ajouter ici si besoin.*

## Support
Pour toute question ou bug :
- Ouvrir une *issue* sur GitLab
- Ou me contacter via florent.lequellec@univ-tls3.fr / antonin.menard1@univ-tls3.fr

## 🎯 Objectifs de l'analyse

Ce projet vise à explorer l’influence du **moment d’observation** sur la détection d’oiseaux, en utilisant un jeu de données issu de la plateforme eBird. L'objectif est de mieux comprendre comment des variables temporelles comme l’heure, la date ou la durée influencent :

1. **La quantité d’oiseaux observés**  
   - Identifier les plages horaires ou les jours où les observations sont les plus fréquentes.
   - Étudier la relation entre la durée d’observation et le nombre d’individus détectés.

2. **La diversité et la répartition des espèces**  
   - Analyser si certaines espèces sont davantage observées à des moments spécifiques (heure de la journée, période du mois).
   - Étudier les préférences temporelles des espèces (ex. : oiseaux matinaux vs. crépusculaires).

3. **Les profils d’observation**  
   - Regrouper les observations en fonction de caractéristiques temporelles et d’effort (durée, distance parcourue, heure) à l’aide d’algorithmes de **clustering**.
   - Identifier des "profils types" d’observateurs ou de sorties d’observation (ex. : balade courte du matin, sortie longue en après-midi, etc.).

4. **Explorer des pistes de prédiction**  
   - Tester la capacité d’un modèle de **classification** à prédire certaines caractéristiques (ex. : espèce observée, nombre d’individus) en se basant uniquement sur des variables temporelles.

## Auteurs et remerciements
Projet initié par Florent LE QUELLEC et Antonin MENARD  
Merci à Roland BARRIOT pour son encadrement et retours.

## Provenance des données
Nos données proviennent du site [EBird](https://ebird.org/about) qui est une base de donnée de suivi d'ornithologie.

## Licence
Ce projet est sous licence **Apache 2.0** — voir le fichier [LICENSE](LICENSE) pour plus d’informations.

## Statut du projet
🚧 **Projet en cours de développement actif**
