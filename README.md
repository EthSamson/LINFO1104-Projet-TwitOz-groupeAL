DEBELLE Anouk et RIDELLE Louis
# LINFO1104-Projet-TwitOz-groupeAL
LINFO1104 - Projet Oz 2019-2020

## Introduction
Ce projet a été mené dans le cadre du cours de LINFO1104 par le groupe AL.
L'objectif était de prédire un mot à partir du mot précédent.

## Structure globale

Ce dossier contient :
 - main.oz 
 - Reader.oz
 - makefile

## Makefile
Ce projet contient un makefile qui vous permet de lancer le programme.

#### Pour lancer le programme
Pour lancer tout le programme, il faut juste exécuter la commande suivante
```
usern@me:~yourpath$  make run
```
#### Pour supprimer les exécutables
Pour les supprimer, il faut jsute exécuter la commande suivante
```
usern@me:~yourpath$  make clean
```


## Fonction dans le Reader.oz:
 - Scan : une fonction qui prend comme argument le nom d'un fichier et un nombre.Et elle retourne la Nème ligne où N est le nombre mis en argument.

## Fonctions dans le main.oz:
 - Lecture : Elle prend comme argument un nom de fichier et retourne une liste où chaque ligne du fichier est un élément de la liste
 - Parsing : Elle prend comme argument une liste et renvoie une liste où chaque éléments sont une liste de mots
 - ParsStr : Elle prend la liste qui lui ai donnée par Parsing et elle modifier les caractères inutiles d'un tweet
 - SaveInDic1 : Elle regarde la liste tweet par tweet
 - SaveIndic2 : Elle regarde le tweet mot par mot
 - AddInDic : Elle ajoute dans le dictionnaire les mots
 - ChangeTupleInDic : elle renvoie le tuple modifié (il a un élément en plus)
 - Pred : Elle renvoie le label du tuple qui a la plus grande longueur en fonction d'une key

 
