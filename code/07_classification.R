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

#human = 54%, forest = 45%

# Creating dataframe
class = c("Forest", "Human")
y1992 = c(83,17)
y2006 = c(45,55)
tabout = data.frame(class, y1992, y2006)

# Di seguito creo un grafico a barre (istogramma) scegliendo il colore bianco, per il 1992 e per il 2006
p1 = ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))

p2 = ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white")+ ylim(c(0,100))

# Accosto i 2 grafici, anziché utilizzando multiframe o altro, utilizzo il la funzione "patchwork" del pacchetto omonimo, che è la seguente
p1 = ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))

p2 = ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white")+ ylim(c(0,100))

# Plotto la prima banda del 1992 e del 2006 assieme con la funzione ggplot di imageRy
p0 = im.ggplot(mato1992)
p00 = im.ggplot(mato2006)

p1 + p2
p1 / p2

p0 = im.ggplot(mato1992)
p00 = im.ggplot(mato2006)

# Metto i 4 grafici tutti uno accanto all'altro
p0 + p00 + p1 + p2





