# R code for performing multitemporal analysis

install.packages("ggridges") #servirà per creare ridgeline plots
library(terra)
library(imageRy)
library(viridis)
library(ggridges)

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

#avendo già importato le 4 immagini "greenland" adesso uso una funzione per utilizzare i Ridgeline plots, secondo l'apposita funzione
#questa funzione è ottenibile soltanto dal pacchetto "ggridges", dunque lo installo (ma va in cima a questo file il relativo comando, perché i pacchetti nei codici si scrivono in cima!)
#Ridgeline plots
im.ridgeline(gr, scale=1)
#adesso vado a cambiare il parametro di scala 
im.ridgeline(gr, scale=2)
im.ridgeline(gr, scale=3)

#i seguenti coamandi mi forniscono informazioni sul grafico
?im.ridgeline
im.ridgeline

#gli cambio colore con una legenda dal pacchetto viridis
im.ridgeline(gr, scale=2, palette="inferno")

#abbiamo visto un set pluriennale, guardiamo un'altro tipo di set da im.list()
#importo le immagini Sentinel2_NDVI e gli do nome "ndvi"

im.list()
ndvi = im.import("Sentinel2_NDVI")
im.ridgeline(ndvi, scale=1)

#cambiare il nome dei layers del dataset, perché altrimenti scrivendo solo NDVI creo un solo grafico (si chiamano tutti NDVI)
#changing names
#sources "Sentinel2_NDVI_2020-02-21.tif"                     
#sources "Sentinel2_NDVI_2020-05-21.tif"                     
#sources "Sentinel2_NDVI_2020-08-01.tif"                     
#sources "Sentinel2_NDVI_2020-11-27.tif" 

#uso il comando "pairs" per confrontare i vari set di dati, di seguito i comandi per ottenere i dati di febbraio e di maggio
pairs(ndvi)
plot(ndvi[[1]], ndvi[[2]])

#creo una linea 1:1 dove i dati di febbraio e maggio risultino uguali, tramite la seguente funzione
# y = x # may y, feb x
# y = a + bx
# a=0, b=1
# y = a + bx = 0 + 1x = x

plot(ndvi[[1]], ndvi[[2]], xlim=c(0.3,0.9), ylim(-0.3, 0.9))
abline(0, 1, col=red)

#faccio un multiframe
im.multiframe(1,3)
plot(ndvi[[1]])
plot(ndvi[[1]])
plot(ndvi[[1]])

