# Code for calculating spatial variability

library(terra)
library(imageRy)
library(viridis)
library(patchwork)
install.packages("RStoolbox")
library(RStoolbox)

# Standard deviation in people age
23, 22, 23, 49

# Calcolo dapprima la media
m (23+22+23+49) / 4
# m = 29.25

# Deviazione standard = quanto si scosta il dato dalla media
(23-29.5)^2 + (22-29.5)^2 + (23-29.5)^2 + (49-29.5)^2 = 521 = num
den = 4 - 1

# Ho estratto la somma di tutti gli scarti quadratici e gli ho dato nome "num" (numeratore) mentre "den" è il denominatore
# num / den mi da la varianza

variance = num / den = 521/4 -1 = 173,66
stdev = sqrt(variance)

# Deviazione standard finale
#stdev √173,66 = 13.17

# Provo ad escludere dal gruppo il dato più grande per vedere come varia la deviazione standard
sd(c(23, 22, 23))
#stdev = 0.5773503

#---

#importo un'immagine di Sentinel
im.list()
sent = im.import("sentinel.png")

#band 1 = NIR
#band 2 = red
#band 3 = green

#Esercizio: plotta l'immagine in RGB con il NIR sopra al rosso
im.plotRGB(sent, r=1, g=2, b=3)

#Esercizio: make three plots with NIR ontop of each component: r, g, b
im.multiframe (1,3)
im.plotRGB(sent, r=1, g=2, b=3)
im.plotRGB(sent, r=2, g=1, b=3)
im.plotRGB(sent, r=3, g=2, b=1)

# Ora voglio calcolare la deviazione standard
# Per prima cosa ora associo una prima banda al NIR
nir = sent[[1]]
plot(nir)

# Esercizio: plotta la banda del nir con la ramp palette "inferno" di viridis
plot(nir, col=inferno(100))

# Uso la funzione "focal" del pacchetto terra per ottenere la deviazione standard
sd3 = focal(nir, w=c(3,3), fun=sd)
plot(sd3)

# Adesso plotto una accanto all’altra l’immagine originale e quella con la deviazione standard
im.multiframe(1,2)
im.plotRGB(sent, r=1, g=2, b=3)
plot(sd3)

# Esercizio: fare la stessa cosa con una finestra di 5 x 5 anziché 3 x 3:
sd5 = focal(nir, w=c(5,5), fun=sd)
plot(sd5)

# Esercizio: usa il pacchetto ggplot per plottare la deviazione standard
im.ggplot(sd3)

# Esercizio: usa ggplot per plottare una accanto all’altra le 2 mappe di deviazione standard con finestra 3 x 3 e 5 x 5
p1 = im.ggplot(sd3)
p2 = im.ggplot(sd5)
p1 + p2

# Esercizio: plotta con ggplot il set originale in RGB (ggRGB) assieme alle 2 deviazioni standard viste utilizzando il pacchetto RStoolbox
p3 = ggRGB(sent, r=1, g=2, b=3)
p1 + p2 + p3
p3 + p1 + p2

# Cosa fare in caso di immagini molto grandi: si usa la funzione ncell che moltiplica le righe per le colonne
ncell(sent) * nlyr(sent)

#794 (righe) * 798 (colonne)
# 2534448

# Uso la funzione aggregate per avere meno pixel e gli do nome "senta"
senta = aggregate(sent, fact=2)

# poi digito "senta" e vedo cosa è cambiato nella risoluzione e altro
# A questo punto riutilizzando la funzione ncell vedrò che il numero di pixel è diminuito quanto atteso
ncell(senta) * nlyr(senta)
# 633612

# proviamo con fattore 5
senta5 = aggregate(sent, fact=5)
ncell(senta5) * nlyr(senta5)
#risultato 101760

#Esercizio: fai un multiframe e plotta in RGB le 3 immagini (originale, fattore 2, fattore 5)
im.multiframe(1,3)
im.plotRGB(sent, 1, 2, 3)
im.plotRGB(senta, 1, 2, 3)
im.plotRGB(senta5, 1, 2, 3)

# Deviazione standard dell'immagine con fattore 2
nira = senta[[1]]
sd3a = focal(nira, w=c(3,3) fun="sd")

# Esercizio: calcola la deviazione standard con fattore 5
nira5 = senta5[[1]]
sd3a5 = focal(nira5, w=c(5,5) fun="sd")
plot(sd5a5)

# Multiframe per confronto
im.multiframe(2,2)
plot(sd3) 
plot(sd3a) 
plot(sd3a5) 
plot(sd5a5) 

# Ora lo faccio con ggplot e per questo mi serve il pacchetto patchwork e anche eventualmente viridis per scegliere il colore
im.multiframe(2,2)
p1 = im.ggplot(sd3)
p2 = im.ggplot(sd3a)
p3 = im.ggplot(sd3a5)
p4 = im.ggplot(sd5a5)

p1 + p2 + p3 + p4

#Lo faccio con multiframe ed una scala di colori dal pacchetto viridis:
im.multiframe(2,2)
plot(sd3, col=mako(100))
plot(sd3a, col=mako(100))
plot(sd3a5, col=mako(100))
plot(sd5a5, col=mako(100))

# Calcolo della varianza
nir = sent[[1]]
var3 = sd3^2

im.multiframe(1,2)
plot(sd3)
plot(var3)
sd5 = focal(nir, w=c(5,5), fun="sd")
var5 = sd5^2













