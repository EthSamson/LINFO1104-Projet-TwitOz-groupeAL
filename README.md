DEBELLE Anouk et RIDELLE Louis
# LINFO1104-Projet-TwitOz-groupeAL
LINFO1104 - Projet Oz 2019-2020


## Introduction

Ce projet a été mené dans le cadre du cours de LINFO1104 par le groupe AL.
L'objectif était de prédire un mot à partir du mot précédent suivant une base de donnée texte.


## Structure globale

*< main.oz >* : permet l'exécution global du code et reprend l'ensemble des functions de LECTURE, PARSING, SAUVEGARDE ainsi que la PREDICTION.

*< Reader.oz >* : fichier qui reprend le nécessaire afin de lire un fichier texte.

*< Makefile >* : permet l'automatisation du lancement de l'interface graphique.

*< tweets >*  : reprend l'ensemble des 208 fichiers textes donnés.

*< tweets_dummies >*  : reprend les 24 premiers fichiers textes donnés.


## Makefile

Ce projet contient un makefile qui reprend les commandes d'automatisaion du lancement du programme :

#### Pour lancer le programme
Pour lancer tout le programme, il faut exécuter la commande suivante :
```
usern@me:~yourpath$  make run
```

#### Pour supprimer les exécutables
Pour le supprimer les exécutables, il faut exécuter la commande suivante :
```
usern@me:~yourpath$  make clean
```

## Comportement du code

Nous divisons le programme en quatres exécutions :

- La lecture : Ce sont deux threads qui sont chargé de lire en parallèle les fichiers texte (part_(1-208).txt). Ils agissent comme des Producer et renvoie un flux de donnée pour le parsing.

- Le parsing : Il y a également deux threads responsables de cette étapes. Ceux-ci reprennent le flux des threads de lectures et y retire tous les caractères non désirés. Cette étapes agit comme un Consumer en fonction de l'étape de lecture et comme un Producer par rapport à la Sauvegarde.

- La sauvegarde : Ici nous enregistrons les paires de mots dans un dictionnaire ce qui permettra d'aller chercher plus facilement les  prédictions. Ce travaille est effectué par un seul thread qui reprend le informations des deux threads de parsing.

- La prédiction : Cette étape débute dans l'interface graphique. Lorsqu'on appuye sur le bouton "Prédiction" et qu'un mot est entré dans la zone de texte blanche le programme va détercté le dernier mot écrit et va renvoyer la prédiction du mot suivant dans la zone de texte noir.
