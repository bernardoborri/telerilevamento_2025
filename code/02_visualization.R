# R code for visualizing satellite data
# i pachetti vanno sempre in cima
install.packages("viridis")
library(viridis)
# install.packages("devtools")
library(devtools)
install_github("ducciorocchini/imageRy")

library(terra) 
library(imageRy)

im.list()
 
# For the whole course we are going to make use of = instead of <-
# This is based on the following video:
# https://www.youtube.com/watch?v=OJMpKCKH1hM

b2 = im.import("sentinel.dolomites.b2.tif")
plot(b2, col=cl)

cl = colorRampPalette(c("black", "dark grey", "light grey"))(100)
plot(b2, col=cl)

cl = colorRampPalette(c("black", "dark grey", "light grey"))(3)
plot(b2, col=cl)
# tlumley@u.washington.edu, Thomas Lumley

# Exercise: make your own color ramp
# https://sites.stat.columbia.edu/tzheng/files/Rcolor.pdf

cl = colorRampPalette(c("royalblue3", "seagreen1", "red1"))(100)
plot(b2, col=cl)

library(terra) 
library(imageRy)

#band 3
b3 = im.import("sentinel.dolomites.b3.tif")

b4= im.import("sentinel.dolomites.b4.tif")

b8= im.import("sentinel.dolomites.b8.tif")

im.multiframe #par facilitata

par (mfrow=c(1,4))
b2 = im.import("sentinel.dolomites.b2.tif")
b3 = im.import("sentinel.dolomites.b3.tif")
b4= im.import("sentinel.dolomites.b4.tif")
b8= im.import("sentinel.dolomites.b8.tif")

par (mfrow=c(1,4))
plot(b2)
plot(b3)
plot(b4)
plot(b8)

#Exercuse: plot the bands using im.multiframe() one on top of the other
par (mfrow=c(4,1))
plot(b2)
plot(b3)
plot(b4)
plot(b8)

cl = colorRampPalette(c("black", "light grey")) (100)
par (mfrow=c(2,2))                
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

sent = c(b2, b3, b4, b8)
plot(sent, col=cl)

names(sent) = c("b2blue", "b3green", "b4red", "b8NIR")
sent

plot(sent, col=cl)
plot (sent)

plot (sent$b8NIR)

plot (sent[[4]])
#how to import several bands together
sentdol = im.import("sentinel.dolomites")

#how to import several sets together
pairs (sentdol)

#viridis
plot(sentdol, col=viridis(100))
plot(sentdol, col=mako(100))
plot(sentdol, col=mako(100))


dev.off() #significa spegni il device, per far sparire il grafico creato

im.multiframe(1,4)
