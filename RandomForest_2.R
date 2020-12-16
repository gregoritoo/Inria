
#Création d'un modèle de classification randomForest basé sur la classification SBD


#Importation des données et de la libraire randomForest. On enlève les variables inutiles et redondantes 
#( pas besoin d'avoir start time et stop time quand on a runtime). 
#Les classes viennent de la classification SBD

library(randomForest)
data = read.csv('C:\\Users\\ibiza\\OneDrive\\Desktop\\Data\\1.csv')
classes = read.csv('C:\\Users\\ibiza\\OneDrive\\Desktop\\Classeur1.csv')
data_2 = data[-c(5,6,12,13,15,16,17,18,19,20,21,22,23)]



#On crée un histogramme de la variable 'total_energy_consumption' afin d'avoir une idée générale de la distribution de la variable.

hist(data_2$total_energy_consumption)



#Transformation de la  variable 'total_energy_consumption' en variable catégorielle afin de pouvoir appliquer un arbre de classification. Ces classes ont vocation à etre remplacée par les "vraies" classes trouvées par les algorithmes de classification de séries temporelles.

decoupage = function(x) {
  if (x <= 2.86576685e+09/2) 
    return ("Catégorie 0")
  else if (x <= 1.82064049e+11) 
    return ("Catégorie 1")
  else if (x <= 3.61262332e+11) 
    return ("Catégorie 2")
  else if (x <= 5.40460614e+11) 
    return ("Catégorie 3")
  else if (x <= 7.19658896e+11) 
    return ("Catégorie 4")
  else if (x <= 8.98857179e+11)
    return ("Catégorie 5")
  else if (x <= 1.07805546e+12) 
    return ("Catégorie 6")
  else if (x <= 1.25725374e+12)
    return ("Catégorie 8")
  else if (x <= 1.43645203e+12)
    return ("Catégorie 9")
  else if (x <= 1.61565031e+12)
    return ("Catégorie 10")
  else  
    return ("Catégorie 11")
}
data_2$catégorie = apply(data_2[,c("total_energy_consumption"),drop = F],1,decoupage)


#On enlève la variable 'total_energy_consumption'et on précise que la nouvelle variable 'catégorie' (qui représente la consommation énergétique) est un facteur. Cette étape est nécessaire pour que le randomForest fonctionne


data_3 = data_2[-c(11)]
data_3$classes = factor(classes$classe)
data_3$catégorie = factor(data_3$catégorie)


#On sépare en train/test à hauteur de 70%/30%

train = sample(nrow(data_3), 0.7*nrow(data_3), replace = FALSE)
TrainSet = data_3[train,]
ValidSet = data_3[-train,]


#on crée un modèle randomForest avec les paramètres par défaut (500 arbres générés et 3 variables sélectionnées pour un split). On obtient un taux d'erreur de 1.8%. Ce taux d'erreur est le plus important pour la catégorie 9, qui correspond à une consommation très importante. Ces erreurs sont peut être dues au faible nombre d'individus dans cette catégorie.

foret_1 = randomForest(catégorie ~ ., data = TrainSet, importance = TRUE,proximity = TRUE)
foret_1


#On utilise le modèle pour prédire sur le jeu d'entrainement. Comme on pouvait s'y attendre, il n'y a pas d'erreurs.

predTrain <- predict(foret_1, TrainSet, type = "class")
table(predTrain, TrainSet$catégorie)  



#On utilise le modèle pour prédire sur le jeu d'entrainement.La précision toune 

predValid <- predict(foret_1, ValidSet, type = "class")
mean(predValid == ValidSet$catégorie)                    
table(predValid,ValidSet$catégorie)


#On regarde quelles variables sont les plus importantes. MeanDecreaseAccuracy indique à quel point la précision diminue quand la variable n'est pas prise en compte pour une séparation au niveau d'un noeud. MeanDecreaseGini indique à quel point prendre en compte cette variable pour la séparation d'un noeud résulte en une diminution de l'impureté de ce noeud. Ainsi, les variables les plus predictives sont :
 # - run_time_oar
 # - job_user_oar
  #- submission_time_oar (étonnant)
 # - job_id_oar
 # _host_oar (la machine semble avoir un rôle à jouer, ou alors est-ce l'inverse, c'est à dire que certaines machines sont choisies en priorité pour effecteur les jobs les plus gourmants par exemple ?)

importance(foret_1) 
varImpPlot(foret_1)


#On essaye de trouver le nombre optimal de variables à prendre en compte pour les séparations

Précisions=c()
i=5
for (i in 3:11) {
  foret_3 <- randomForest(catégorie ~ ., data = TrainSet, ntree = 500, mtry = i, importance = TRUE)
  predValid <- predict(foret_3, ValidSet, type = "class")
  Précisions[i-2] = mean(predValid == ValidSet$catégorie)
}
Précisions

#En général, on remarque que la précision augmente jusqu'à ce que l'on prenne 5-6 variables, en compte. Elle descent ensuite pour 7 puis remonte évidemment si l'on prend en compte toutes les variables. Ainsi, il semble être optimal de prendre 5 variables, qui sont celles présentées auparavant :
 #- run_time_oar
 #classes
 # - job_user_oar
 # - submission_time_oar 
 # - job_id_oar
 # _host_oar

#Ce modèle a des limites évidentes : La prédiction repose presque uniquement sur le runtime. Peut être serait-il intéressent d'avoir accès à plus de variables explicatives, où à défaut à plus de données pour affiner la prédiction.

plot(3:11,Précisions,type='l',xlab ='nombre de variables')



`









