# R code for classifying images
library(terra)
library(imageRy)
library(ggplot2)
install.packages("patchwork")
library(patchwork)

im.list()

mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 = flip(mato1992)
plot(mato1992)

mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
plot(mato2006)

mato1992c = im.classify(mato1992, num_clusters=2)
# class 1 = human
# class 2 = forest

mato2006c = im.classify(mato2006, num_clusters=2)
# class 1 = forest
# class 2 = human

# Frequenza di quante volte ho un dato valore
f1992 = freq(mato1992c)

# poi da qui seleziono i dati con cui ottenere le proporzioni                            
tot1992 = ncell(mato1992c)
prop1992 = f1992 / tot1992
perc1992 = prop1992 * 100

#human = 17%, forest = 83%

tot2006 = ncell(mato2006c)
perc2006 = freq(mato2006c) * 100 / tot2006

# Creating dataframe
class = c("Forest", "Human")
y1992 = c(83,17)
y2006 = c(45,55)
tabout = data.frame(class, y1992, y2006)

# Di seguito creo un grafico a barre (istogramma) scegliendo il colore bianco, per il 1992 e per il 2006
p1 = ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))

p2 = ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white")+ ylim(c(0,100))

# Accosto i 2 grafici, anziché utilizzando multiframe o altro, utilizzo una funzione del pacchetto patchwork, che è la seguente
p1 = ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))

p2 = ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white")+ ylim(c(0,100))

# Plotto la prima banda del 1992 e del 2006 assieme con la funzione ggplot di imageRy
p0 = im.ggplot(mato1992)
p00 = im.ggplot(mato2006)

p1 + p2
p1 / p2

#Uso la funzione di imageRy "im.ggplot"
p0 = im.ggplot(mato1992)
p00 = im.ggplot(mato2006)

# Metto i 4 grafici tutti uno accanto all'altro
p0 + p00 + p1 + p2

# Coloring bars

ggplot(tabout, aes(x=class, y=y2006, fill=class, color=class)) + 
  geom_bar(stat="identity") + 
  ylim(c(0,100))

# https://www.sthda.com/english/wiki/ggplot2-barplots-quick-start-guide-r-software-and-data-visualization

# Horizontal bars

p1 = ggplot(tabout, aes(x=class, y=y1992, color=class)) +
  geom_bar(stat="identity", fill="white") +
  ylim(c(0,100)) +
  coord_flip()

p2 = ggplot(tabout, aes(x=class, y=y2006, color=class)) +
  geom_bar(stat="identity", fill="white") +
  ylim(c(0,100)) +
  coord_flip()

# Solar orbiter (missione da parte di ESA per il sole)

im.list()
solar = im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
# Esercizio: usa la funzione im.classify() per dividere questa immagine in 3 classi 
solar2006c = im.classify(solar, num_clusters=3)
# Esercizio: plotta l'immagine classificata, creata nel precedente esercizio, assieme all'originale
im.multiframe(1,2)
plot(solar)
plot(solar2006c)

# Ora voglio dare un nome alle 3 classi
# 3 = high
# 1 = low
# 2 = medium

# Esiste una funzione del pacchetto terra per cambiare i numeri in nomi
solarcs = subst(solar2006c, c(3,1,2), c("c1_low","c2_medium","c3_high"))
plot(solarcs)

# Esercizio: calcola le percentuali delle classi dell'energia del sole con una sola linea di codice

# Frequenza di quante volte ho un dato valore
percsolar = freq(solarcs)$count * 100 / ncell(solarcs)

# ricavo le seguenti percentuali digitando su R "percsolar" dopo la suddetta funzione
41.44658 21.21993 37.33349

#approssimo come segue
41 21 38

# Faccio il dataframe
class = c (("c1_low,"c2_medium","c3_high")
perc = c(41,21,38)
tabsol = data.frame(class, perc)

# Creo ora un grafico con ggplot
ggplot(tabsol, aes(x=class, y=perc, fill=class, color=class)) + geom_bar(stat=identity) + 
# ylim(c(0,100))

# Giro il grafico
coord_flip()
# + scale_y_reverse()













