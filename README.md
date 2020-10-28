# Inria

Objectifs compris :
================== 

- Déterminer différents profils de comsommation énergétiques lors des différents jobs   
    Classification / Clustering sur des signaux temporelles   
- Etre capable de prédire l'utilisation energétique   
    Réutilisation des différentes catégories afin de prédire si certain coeurs sont sous exploités afin de pouvoir regrouper les jobs qui consomment peu de ressources.

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
