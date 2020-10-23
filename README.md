# Inria

Objectifs compris :
================== 

- Déterminer différents profils de comsommation énergétiques lors des différents jobs   
    Classification / Clustering sur des signaux temporelles   
- Etre capable de prédire l'utilisation enrgétique   
    Réutilisation des différentes catégories afin de prédire si certain coeurs sont sous exploités.  

Ce qui est mit en place : 
======================== 
Récupération des données / Prétraitement :
------------------------------------------

Data collection (RAPL)  
Aggrégation (?) for denoising   
Removing outliers   

Séparations des signaux en trois sous signaux grâce à un arbre : 
----------------------------------------------------------------
 -> is stationnare(moving average/moving standart deviation)-> is variable (threshold on standard déviation) -> is periodic (DFT)
