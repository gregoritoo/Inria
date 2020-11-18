# Inria

Objectifs compris :
================== 

- Déterminer différents profils de comsommation énergétiques lors des différents jobs   
    Classification / Clustering sur des signaux temporelles   
- Etre capable de prédire l'utilisation energétique   
    Réutilisation des différentes catégories dans le but de prédire si certain coeurs sont sous exploités afin de pouvoir regrouper les jobs qui consomment peu de ressources.
 
 - Rappel HPC : http://oar.imag.fr/docs/2.5/user/quickstart.html

Ce qui est mit en place : 
======================== 
Récupération des données / Prétraitement :
------------------------------------------

Data collection (RAPL)  
Aggrégation (?) for denoising   
Removing outliers   

Séparations des signaux en trois classes grâce à un arbre : 
----------------------------------------------------------------
 -> is stationnare(moving average/moving standart deviation)-> is variable (threshold on standard déviation) -> is periodic (DFT)
 
Questions :
----------
Types d'aggrégations utilisés pour le débruitage ?
Utilisation des données cpu ? Corrélation trop forte avec la consommation d'énergie ?

Idée : 
------ 
Spectrogramme + CNN  
clustering sur tableau individu / variable sur 3 variables issues de l'arbre => analyse des résultats et ajout de variables si nécessaire

Métriques :
----------- 
TWED / DTW  :  
https://arxiv.org/pdf/1401.3973.pdf   
https://github.com/jzumer/pytwed  


# Semaine 1

Methodes mise en place :
=======================

Hierachical clustering :
-----------------------
- Calcul de la distance entre les séries temporelles grâce à la métrique SBD (Shape Based distance : http://www1.cs.columbia.edu/~jopa/Papers/PaparrizosSIGMOD2015.pdf )
- Construction de la matrice de dissimilarité
- Hierachical clustering (à partir de la matrice de dissimilarité obtenue) avec test des différentes méthode d'aggrégation (average,ward ...)
- Analyse visuelle des résultats

CNN (abandonné):
---
- Construction d'une interface graphique pour simplifier la labélisation
- Labélisation des 797 séries temporelles en 19 classes 
- Transformation des signaux en spectrogramme
- Data augmentation en utilisant la méthode SpecAugment (https://arxiv.org/abs/1904.08779)
- Entrainement d'un CNN en faisant du transfert learning sur un modèle InceptionV3 entrainé sur imageNet (70% d'accuracy sans hyper parameters tunning)



