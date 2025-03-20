# R code for performing multitemporal analysis

library(terra)
library(imageRy)
library(viridis)

#apro la lista tramite il comando im.list
im.list()
#scelgo dalla lista im.list la prima immagine della serie EN numerata
EN_01 = im.import("EN_01.png")
#la flippo
EN_01=flip(EN_01)
#plotto per poter visualizzare il flip
plot(EN_01)

#scelgo dalla lista l'ultima immagine EN della serie EN numerata
EN_13 = im.import("EN_13.png") 
#la flippo
EN_13=flip(EN_13)
#plotto per poter visualizzare il flip
plot(EN_13)

#esercizio: plot 2 images one beside the other
im.multiframe(1,2)
plot(EN_01)
plot(EN_13)

#se scrivo EN-01 su R otterrò le sue informazioni e vedo che l'immagine è su 3 livelli

#voglio fare la differenza tra i valori di azoto tramite una differenza utilizzando il livello 1
ENdif = EN_01[[1]] - EN_13[[1]]
plot(ENdif)

#cambio legenda con una scelta dal pacchetto viridis
plot(ENdif, col=inferno(100))

#utilizzo un dataset completo scegliendo da im.list delle immagini di nome greenland e gli do nome "gr"
#scrivendo solo "greenland" importerò tutto il dataset che comprende la scritta "greenland"
#Greenland ice melt
gr = im.import("greenland")

#plotto il primo e il quarto livello con multiframe e scelgo i colori da viridis
im.multiframe(1,2)
plot(gr[[1]], col=rocket(100))
plot(gr[[4]], col=rocket(100))

#faccio anche qui la differenza tra l'immagine del 2000 e quella del 2015
grdif = gr[[1]] - gr[[4]]
plot(grdif)

#esiste una funzione per andare a selezionare la cartella di lavoro
#questa funzione ricava un set dalla cartella
#posso scegliere una cartella dal mio computer (es:download, ma anche il desktop)
#vado sulla cartella del mio computer, clicco sul tasto destro e vado alla voce "proproetà" per visualizzare il path (percorso) di quella cartella
#il path riporterà una scritta simile a C:\Users\bobby\OneDrive\Desktop
#bisogna cambiare la direzione degli slash nel comando come segue







